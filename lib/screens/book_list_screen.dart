import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/shelf_model.dart';
import '../utils/app_theme.dart';
import '../widgets/book_card.dart';
import 'book_reader_screen.dart';

class BookListScreen extends StatefulWidget {
  final Shelf shelf;
  const BookListScreen({super.key, required this.shelf});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  String _query = '';

  List<Book> get _filtered {
    if (_query.trim().isEmpty) return widget.shelf.books;
    final q = _query.toLowerCase();
    return widget.shelf.books.where((b) {
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
    }).toList(growable: false);
  }

  void _showDescription(Book book) {
    final parentNavigator = Navigator.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.deepGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'by ${book.author}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            Text(book.description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mahogany,
                  foregroundColor: AppColors.cream,
                ),
                onPressed: () {
                  Navigator.pop(sheetContext);
                  parentNavigator.push(
                    MaterialPageRoute(
                      builder: (_) => BookReaderScreen(book: book),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: const Text('Open Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shelf.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search by title or author…',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardTheme.color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.deepGold.withOpacity(0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.deepGold.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'No books match your search.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, i) {
                        final book = results[i];
                        return BookCard(
                          book: book,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookReaderScreen(book: book),
                            ),
                          ),
                          onLongPress: () => _showDescription(book),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
