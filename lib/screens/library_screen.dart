import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../providers/radio_player_provider.dart';
import '../widgets/station_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();
    final favorites = context.watch<FavoritesProvider>();

    final favStations = player.stations
        .where((s) => favorites.isFavorite(s))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Your Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: favStations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.textMuted,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the heart icon on any station to add it here.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favStations.length,
              itemBuilder: (context, index) {
                final station = favStations[index];
                final isSelected = station.id == player.currentStation.id;

                return StationCard(
                  station: station,
                  isSelected: isSelected,
                  isPlaying: player.isPlaying,
                  isFavorite: true,
                  onTap: () => player.playStation(station),
                  onToggleFavorite: () => favorites.toggleFavorite(station),
                );
              },
            ),
    );
  }
}

