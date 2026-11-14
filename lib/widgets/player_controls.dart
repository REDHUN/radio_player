import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTogglePlay;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onTogglePlay,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        IconButton(
          onPressed: onPrevious,
          iconSize: 34,
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
          ),
          splashRadius: 28,
        ),
        const SizedBox(width: 28),

        // Big Gradient Play/Pause Button
        GestureDetector(
          onTap: onTogglePlay,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPink.withValues(alpha: 0.45),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 28),

        // Next Button
        IconButton(
          onPressed: onNext,
          iconSize: 34,
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
          ),
          splashRadius: 28,
        ),
      ],
    );
  }
}
