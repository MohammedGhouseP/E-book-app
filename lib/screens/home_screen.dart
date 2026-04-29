import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/books_data.dart';
import '../utils/app_theme.dart';
import '../utils/library_storage.dart';
import 'shelf_screen.dart';
import 'book_list_screen.dart';
import 'book_reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookshelf'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onPressed: themeProvider.toggle,
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            _Greeting(),
            const SizedBox(height: 24),
            _BrowseShelvesCta(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ShelfScreen(),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SectionHeader(
              title: 'Continue Reading',
              icon: Icons.bookmark,
            ),
            const SizedBox(height: 12),
            _ContinueReading(),
            const SizedBox(height: 28),
            const _SectionHeader(
              title: 'Featured Books',
              icon: Icons.star_rounded,
            ),
            const SizedBox(height: 12),
            _FeaturedBooks(),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color
                ?.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Reader',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.darkMahogany
                : AppColors.gold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A quiet place to discover stories in two languages.',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color
                ?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _BrowseShelvesCta extends StatelessWidget {
  final VoidCallback onTap;
  const _BrowseShelvesCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.mahogany, AppColors.darkMahogany],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold),
              ),
              child: const Icon(
                Icons.menu_book,
                size: 32,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse Shelves',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fiction · Islamic · Children · Poetry',
                    style: TextStyle(
                      color: AppColors.parchment,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.gold, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.deepGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.darkMahogany
                : AppColors.cream,
          ),
        ),
      ],
    );
  }
}

class _ContinueReading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = context.watch<LibraryStorage>();
    final inProgress = BooksData.allBooks
        .where((b) {
          final progress = storage.progressOf(b.id);
          return progress > 0 && progress < 1;
        })
        .toList(growable: false);

    if (inProgress.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.deepGold.withOpacity(0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.menu_book, color: AppColors.deepGold),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Pick a book from the shelves to start reading.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: inProgress.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final book = inProgress[i];
          final progress = storage.progressOf(book.id);
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BookReaderScreen(book: book),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.deepGold.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [AppColors.wood, AppColors.darkMahogany],
                      ),
                    ),
                    child: const Icon(Icons.menu_book,
                        color: AppColors.gold, size: 28),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: AppColors.deepGold.withOpacity(0.2),
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.gold),
                          ),
                        ),
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
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featured = BooksData.allBooks.take(6).toList(growable: false);
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: featured.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final book = featured[i];
          final shelf = BooksData.shelfById(book.shelfId);
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => shelf != null
                    ? BookListScreen(shelf: shelf)
                    : BookReaderScreen(book: book),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardTheme.color,
                border: Border.all(color: AppColors.deepGold.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10)),
                      child: Image.asset(
                        book.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.wood, AppColors.darkMahogany],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.menu_book,
                                color: AppColors.gold, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                    child: Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
