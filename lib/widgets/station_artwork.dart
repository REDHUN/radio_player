import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/radio_station.dart';
import 'live_badge.dart';

class StationArtwork extends StatelessWidget {
  final RadioStation station;
  final bool isPlaying;

  const StationArtwork({
    super.key,
    required this.station,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF261D40),
              Color(0xFF161324),
              Color(0xFF0F0D1A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: isPlaying
                  ? AppColors.primaryPurple.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 12),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Atmospheric Glow & Gradients
              CustomPaint(
                painter: _ArtworkBackgroundPainter(
                  isPlaying: isPlaying,
                ),
              ),

              // Studio Artwork Icon / Motif
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryPink.withValues(alpha: 0.25),
                        AppColors.primaryPurple.withValues(alpha: 0.15),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.mic_external_on_rounded,
                    size: 52,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),

              // Top-left LIVE badge
              Positioned(
                top: 16,
                left: 16,
                child: LiveBadge(isPlaying: isPlaying),
              ),

              // Bottom-right Frequency / Station badge
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    station.frequencyBadge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkBackgroundPainter extends CustomPainter {
  final bool isPlaying;

  _ArtworkBackgroundPainter({required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.3),
        radius: 0.8,
        colors: [
          const Color(0xFF6B21A8).withValues(alpha: isPlaying ? 0.45 : 0.25),
          const Color(0xFFBE185D).withValues(alpha: isPlaying ? 0.25 : 0.10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Subtle ambient studio grid lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 32) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double j = 0; j < size.height; j += 32) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArtworkBackgroundPainter oldDelegate) =>
      oldDelegate.isPlaying != isPlaying;
}
