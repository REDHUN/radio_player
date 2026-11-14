import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/radio_player_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/popular_stations_list.dart';
import '../widgets/station_artwork.dart';
import '../widgets/volume_slider.dart';
import '../widgets/waveform_visualizer.dart';

class HomePlayerScreen extends StatelessWidget {
  const HomePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<RadioPlayerProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final station = playerProvider.currentStation;
    final isFav = favoritesProvider.isFavorite(station);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top Action Bar matching user screenshot
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Left Chevron / Minimize Icon Button
                    _CircularHeaderButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      onTap: () {
                        context.read<NavigationProvider>().setIndex(1);
                      },
                    ),

                    // Top Right Heart / Favorite Icon Button
                    _CircularHeaderButton(
                      icon: isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      iconColor: isFav ? AppColors.primaryPink : Colors.white,
                      onTap: () {
                        favoritesProvider.toggleFavorite(station);
                      },
                    ),
                  ],
                ),
              ),

              // Error notification banner if any
              if (playerProvider.errorMessage != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B1522),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primaryPink.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primaryPink, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          playerProvider.errorMessage!,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: playerProvider.retry,
                        child: const Text('RETRY', style: TextStyle(color: AppColors.primaryPink)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                        onPressed: playerProvider.clearError,
                      ),
                    ],
                  ),
                ),

              // Main Artwork Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: StationArtwork(
                  station: station,
                  isPlaying: playerProvider.isPlaying,
                ),
              ),
              const SizedBox(height: 18),

              // "NOW PLAYING" Header
              const Text(
                'NOW PLAYING',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),

              // Big Station Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  station.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  station.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),

              // Tag / Bitrate Chip
              Text(
                '${station.category} · ${station.bitrate}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              // Waveform Visualizer
              WaveformVisualizer(
                isPlaying: playerProvider.isPlaying,
              ),
              const SizedBox(height: 20),

              // Player Controls (Previous, Play/Pause gradient, Next)
              PlayerControls(
                isPlaying: playerProvider.isPlaying,
                isLoading: playerProvider.isLoading,
                onTogglePlay: playerProvider.togglePlayPause,
                onPrevious: playerProvider.previousStation,
                onNext: playerProvider.nextStation,
              ),
              const SizedBox(height: 22),

              // Volume Slider (Matching 72% layout)
              VolumeSlider(
                volume: playerProvider.volume,
                onVolumeChanged: playerProvider.setVolume,
              ),
              const SizedBox(height: 32),

              // "KEEP LISTENING" / Popular Stations Horizontal Shelf
              PopularStationsList(
                stations: playerProvider.stations,
                currentStation: station,
                isPlaying: playerProvider.isPlaying,
                onSelectStation: (selected) {
                  playerProvider.playStation(selected);
                },
                onSeeAll: () {
                  context.read<NavigationProvider>().setIndex(1);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircularHeaderButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1F1C2E),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
