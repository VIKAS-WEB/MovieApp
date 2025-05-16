import 'package:flutter/material.dart';
import 'package:git_example/utils/Colors.dart';

class TrendingMovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const TrendingMovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 220, // Matches the image width
      margin: const EdgeInsets.only(right: 30), // Matches the gap between cards
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
                      color: AppColorsForApp.blackPrimaryWithOpacity(0.54),
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
                    height: 98, // Matches the image height
                    width: 120, // Adjusted to match the container width
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Icon(
                Icons.play_circle_filled,
                color: AppColorsForApp.textPrimary,
                size: 40,
                shadows: [
                  Shadow(
                    color: AppColorsForApp.blackPrimaryWithOpacity(0.54),
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8), // Gap between image and title
          Text(
            title,
            style: const TextStyle(
              color: AppColorsForApp.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}