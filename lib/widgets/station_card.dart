import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/radio_station.dart';

class StationCard extends StatelessWidget {
  final RadioStation station;
  final bool isSelected;
  final bool isPlaying;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const StationCard({
    super.key,
    required this.station,
    required this.isSelected,
    required this.isPlaying,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryPink.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.05),
          width: isSelected ? 1.2 : 0.8,
        ),
      ),
      child: Material(
        color: isSelected ? const Color(0xFF231B36) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: onTap,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: isSelected
                  ? AppColors.primaryGradient
                  : const LinearGradient(
                      colors: [Color(0xFF2C2442), Color(0xFF1B172B)],
                    ),
            ),
            child: Icon(
              isSelected && isPlaying
                  ? Icons.pause_rounded
                  : (isSelected
                      ? Icons.play_arrow_rounded
                      : Icons.radio_rounded),
              color: Colors.white,
              size: 26,
            ),
          ),
          title: Text(
            station.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 6, top: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  station.frequencyBadge,
                  style: const TextStyle(
                    color: AppColors.primaryPink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${station.category} • ${station.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected && isPlaying)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.graphic_eq_rounded,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                ),
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite
                      ? AppColors.primaryPink
                      : AppColors.textMuted,
                  size: 22,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
