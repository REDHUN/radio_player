import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/navigation_provider.dart';
import '../providers/radio_player_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();
    final station = player.currentStation;

    return GestureDetector(
      onTap: () {
        context.read<NavigationProvider>().setIndex(0);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF221D35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primaryPink.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Icon(
                  player.isPlaying
                      ? Icons.graphic_eq_rounded
                      : Icons.radio_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Station Name & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    station.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player.isLoading
                        ? 'Connecting...'
                        : (player.isPlaying ? 'Playing • ${station.frequencyBadge}' : 'Paused'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: player.isPlaying
                          ? AppColors.primaryPink
                          : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Play / Pause Button
            IconButton(
              iconSize: 32,
              onPressed: player.togglePlayPause,
              icon: Icon(
                player.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                color: AppColors.primaryPink,
              ),
            ),

            // Next Button
            IconButton(
              iconSize: 26,
              onPressed: player.nextStation,
              icon: const Icon(
                Icons.skip_next_rounded,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
