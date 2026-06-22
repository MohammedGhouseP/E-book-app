import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book_model.dart';
import '../utils/app_theme.dart';
import 'dual_language_reader.dart'; // We need this for the LanguageMode enum

class MangaReader extends StatelessWidget {
  final Chapter chapter;
  final LanguageMode languageMode; 

  const MangaReader({
    super.key, 
    required this.chapter, 
    required this.languageMode,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which list of S3 URLs to load based on the floating action button
    final isUrdu = languageMode == LanguageMode.urduOnly;
    final activePages = isUrdu ? chapter.urduPageUrls : chapter.englishPageUrls;

    if (activePages.isEmpty) {
      return Center(
        child: Text(
          isUrdu ? 'No Urdu images found.' : 'No English images found.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return PageView.builder(
      reverse: true, // Swipes Right-to-Left (standard for Manga/Arabic scripts)
      itemCount: activePages.length,
      itemBuilder: (context, index) {
        return InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0, // Allows the user to pinch and zoom in 4x
          child: CachedNetworkImage(
            imageUrl: activePages[index],
            fit: BoxFit.contain, // Ensures the whole page fits on the screen
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: AppColors.deepGold, size: 48),
                  SizedBox(height: 16),
                  Text('Failed to load page. Check S3 URL.'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}