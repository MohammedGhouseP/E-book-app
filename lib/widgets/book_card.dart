import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../utils/app_theme.dart';
import '../utils/library_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<LibraryStorage>();
    final isFav = storage.isFavorite(book.id);
    final progress = storage.progressOf(book.id);

    // 1. Listen DIRECTLY to your ThemeProvider instead of the generic Theme context
    // This forces the card to rebuild the second the toggle button is pressed.
    final themeProvider = context.watch<ThemeProvider>();
    final isLight = !themeProvider.isDark;
    
    // 2. Explicitly define high-contrast colors based on the provider's state
    final textColor = isLight ? AppColors.darkMahogany : AppColors.cream;
    final subtitleColor = isLight 
        ? AppColors.inkBrown.withOpacity(0.8) 
        : AppColors.parchment.withOpacity(0.8);
    final bottomSectionColor = isLight ? AppColors.ivory : AppColors.nightSurface;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: bottomSectionColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CoverImage(path: book.coverImage),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black38,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => storage.toggleFavorite(book.id),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : AppColors.cream,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (progress > 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: Colors.black26,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 3. Wrap text in a Container to ensure the background never bleeds
            Container(
              color: bottomSectionColor,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% read',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.deepGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ensure this helper class remains at the bottom of the file!
class _CoverImage extends StatelessWidget {
  final String path;
  const _CoverImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => _buildErrorFallback(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _buildErrorFallback(),
    );
  }

  Widget _buildErrorFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.wood, AppColors.darkMahogany],
        ),
      ),
      child: const Center(
        child: Icon(Icons.menu_book, color: AppColors.gold, size: 48),
      ),
    );
  }
}