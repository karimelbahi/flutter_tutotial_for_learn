import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie DB'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Movie DB',
              style: AppTypography.detailTitle,
            ),
            const SizedBox(height: 12),
            Text(
              'Design tokens are ready.\nNext step: home screen + API.',
              textAlign: TextAlign.center,
              style: AppTypography.detailOverview,
            ),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.martinique,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: AppColors.divider),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.movie_outlined,
                color: AppColors.placeholder,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
