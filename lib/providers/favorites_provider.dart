import 'package:flutter/foundation.dart';
import '../models/radio_station.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {'club_fm_kochi', 'radio_suno', 'air_malayalam'};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(RadioStation station) => _favoriteIds.contains(station.id);

  void toggleFavorite(RadioStation station) {
    if (_favoriteIds.contains(station.id)) {
      _favoriteIds.remove(station.id);
    } else {
      _favoriteIds.add(station.id);
    }
    notifyListeners();
  }
}

