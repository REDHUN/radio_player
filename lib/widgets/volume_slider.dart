import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class VolumeSlider extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const VolumeSlider({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (volume * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(
            volume == 0
                ? Icons.volume_off_rounded
                : (volume < 0.5
                    ? Icons.volume_down_rounded
                    : Icons.volume_up_rounded),
            size: 18,
            color: AppColors.textMuted,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3.5,
                activeTrackColor: AppColors.primaryPink,
                inactiveTrackColor: const Color(0xFF2C283F),
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6.0,
                  elevation: 2.0,
                ),
                overlayColor: AppColors.primaryPink.withValues(alpha: 0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: volume,
                min: 0.0,
                max: 1.0,
                onChanged: onVolumeChanged,
              ),
            ),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
