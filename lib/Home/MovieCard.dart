import 'package:flutter/material.dart';
import 'package:git_example/utils/Colors.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String duration;
  final String imageUrl;

  const MovieCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsForApp.blackPrimaryWithOpacity(0.54), // Replaces Colors.black54
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageUrl,
                    height: 98,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (duration.isNotEmpty)
                Icon(
                  Icons.play_circle_filled,
                  color: AppColorsForApp.textPrimary, // Replaces Colors.white
                  size: 40,
                  shadows: [
                    Shadow(
                      color: AppColorsForApp.blackPrimaryWithOpacity(0.54), // Replaces Colors.black54
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColorsForApp.textPrimary, // Replaces Colors.white
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (duration.isNotEmpty) ...[
            Text(
              duration,
              style: const TextStyle(
                color: AppColorsForApp.textSecondary, // Replaces Color(0xFFB0B0B0)
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: AppColorsForApp.textDisabled, // Replaces Color(0xFF666666)
              valueColor: const AlwaysStoppedAnimation<Color>(AppColorsForApp.errorRed), // Replaces Colors.red
              minHeight: 2,
            ),
          ],
        ],
      ),
    );
  }
}