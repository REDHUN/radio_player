import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/radio_station.dart';

class PopularStationsList extends StatelessWidget {
  final List<RadioStation> stations;
  final RadioStation currentStation;
  final bool isPlaying;
  final ValueChanged<RadioStation> onSelectStation;
  final VoidCallback onSeeAll;

  const PopularStationsList({
    super.key,
    required this.stations,
    required this.currentStation,
    required this.isPlaying,
    required this.onSelectStation,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'KEEP LISTENING',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular stations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: onSeeAll,
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal List
        SizedBox(
          height: 118,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: stations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final station = stations[index];
              final isCurrent = station.id == currentStation.id;

              return GestureDetector(
                onTap: () => onSelectStation(station),
                child: Container(
                  width: 190,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF261D3A)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCurrent
                          ? AppColors.primaryPink.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.06),
                      width: isCurrent ? 1.2 : 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isCurrent
                                ? [
                                    const Color(0xFFFF3B7A),
                                    const Color(0xFFA63BFF),
                                  ]
                                : [
                                    const Color(0xFF2E2648),
                                    const Color(0xFF1E1930),
                                  ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            isCurrent && isPlaying
                                ? Icons.graphic_eq_rounded
                                : Icons.radio_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              station.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              station.frequencyBadge,
                              style: const TextStyle(
                                color: AppColors.primaryPink,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              station.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
