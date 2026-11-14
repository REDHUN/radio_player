import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../constants/station_data.dart';
import '../models/radio_station.dart';

class RadioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final List<RadioStation> _stations = defaultStations;

  int _currentIndex = 0;
  bool _isConnecting = false;
  String? _errorMessage;
  double _volume = 0.72;

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<PlaybackEvent>? _playbackEventSub;
  StreamSubscription<int?>? _currentIndexSub;

  late final List<AudioSource> _audioSources = _stations.map((station) {
    return AudioSource.uri(
      Uri.parse(station.streamUrl),
      tag: MediaItem(
        id: station.id,
        album: station.category,
        title: station.name,
        artist: '${station.location} • ${station.frequencyBadge}',
        displayTitle: station.name,
        displaySubtitle: station.subtitle,
        displayDescription: '${station.category} • ${station.location}',
      ),
    );
  }).toList();

  RadioPlayerProvider() {
    _init();
  }

  List<RadioStation> get stations => _stations;
  int get currentIndex => _currentIndex;
  RadioStation get currentStation => _stations[_currentIndex];
  bool get isPlaying => _player.playing;
  double get volume => _volume;
  String? get errorMessage => _errorMessage;

  bool get isLoading {
    final state = _player.playerState;
    return _isConnecting ||
        state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering;
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Handle phone calls and audio ducking
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(_volume * 0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              _player.pause();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(_volume);
              break;
            case AudioInterruptionType.pause:
              _player.play();
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      // Handle headphones unplugged (pause so it doesn't blast phone speaker)
      session.becomingNoisyEventStream.listen((_) {
        _player.pause();
      });
    } catch (e) {
      debugPrint('AudioSession init error: $e');
    }

    await _player.setVolume(_volume);

    // Set loop mode so notification Next and Prev wrap around seamlessly
    await _player.setLoopMode(LoopMode.all);

    // Pre-initialize playlist so notification has queue for Next and Prev
    try {
      await _player.setAudioSources(
        _audioSources,
        initialIndex: _currentIndex,
        initialPosition: Duration.zero,
        preload: false,
      );
    } catch (e) {
      debugPrint('Audio source init error: $e');
    }

    // Sync app UI whenever notification Next / Prev buttons are clicked
    _currentIndexSub = _player.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < _stations.length) {
        if (_currentIndex != index) {
          _currentIndex = index;
          _errorMessage = null;
          notifyListeners();
        }
      }
    });

    _playerStateSub = _player.playerStateStream.listen((_) {
      notifyListeners();
    });

    _playbackEventSub = _player.playbackEventStream.listen(
      (_) {},
      onError: (Object e) {
        _errorMessage = 'Playback error occurred. Tap to retry.';
        notifyListeners();
      },
    );
  }

  Future<void> playStation(RadioStation station) async {
    final index = _stations.indexWhere((s) => s.id == station.id);
    if (index != -1) {
      await playIndex(index);
    }
  }

  Future<void> playIndex(int index) async {
    if (index < 0 || index >= _stations.length) return;

    if (_currentIndex == index && _player.playing) {
      await pause();
      return;
    }

    _currentIndex = index;
    _isConnecting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_player.audioSource == null) {
        await _player.setAudioSources(
          _audioSources,
          initialIndex: index,
          initialPosition: Duration.zero,
          preload: false,
        );
      } else {
        await _player.seek(Duration.zero, index: index);
      }
      await _player.play();
    } catch (e) {
      _errorMessage = 'Could not stream ${_stations[index].name}. Stream might be temporarily busy.';
      debugPrint('Stream play error: $e');
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      if (_player.processingState == ProcessingState.idle) {
        await playIndex(_currentIndex);
      } else {
        try {
          await _player.play();
        } catch (e) {
          await playIndex(_currentIndex);
        }
      }
    }
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    notifyListeners();
  }

  Future<void> nextStation() async {
    _errorMessage = null;
    if (_player.hasNext) {
      await _player.seekToNext();
      if (!_player.playing) {
        await _player.play();
      }
    } else {
      final next = (_currentIndex + 1) % _stations.length;
      await playIndex(next);
    }
  }

  Future<void> previousStation() async {
    _errorMessage = null;
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
      if (!_player.playing) {
        await _player.play();
      }
    } else {
      final prev = (_currentIndex - 1 + _stations.length) % _stations.length;
      await playIndex(prev);
    }
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void retry() {
    playIndex(_currentIndex);
  }

  @override
  void dispose() {
    _currentIndexSub?.cancel();
    _playerStateSub?.cancel();
    _playbackEventSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}
