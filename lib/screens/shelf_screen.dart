import 'package:flutter/material.dart';
import '../data/books_data.dart';
import '../utils/app_theme.dart';
import '../widgets/shelf_card.dart';
import 'book_list_screen.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shelves = BooksData.shelves;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Shelves')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.nightBg, AppColors.nightSurface]
                : [AppColors.cream, AppColors.parchment],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick a shelf to explore',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: shelves.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, i) {
                      final shelf = shelves[i];
                      return ShelfCard(
                        shelf: shelf,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookListScreen(shelf: shelf),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
