import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../utils/app_theme.dart';
import '../utils/library_storage.dart';

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

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color
                      ?.withOpacity(0.7),
                ),
              ),
            ),
            if (progress > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  '${(progress * 100).toInt()}% read',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.deepGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String path;
  const _CoverImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => Container(
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
      ),
    );
  }
}
