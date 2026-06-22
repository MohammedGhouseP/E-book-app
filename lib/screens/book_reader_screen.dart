import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../utils/app_theme.dart';
import '../utils/library_storage.dart';
import '../widgets/dual_language_reader.dart';
import '../widgets/manga_reader.dart'; // Imorted our new widget!

class BookReaderScreen extends StatefulWidget {
  final Book book;
  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late int _chapterIndex;
  ReaderLayout _layout = ReaderLayout.sideBySide;
  late LanguageMode _langMode;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _chapterIndex = 0;
    // If it's an image book, default to English Only instead of "Both"
    _langMode = widget.book.isManga ? LanguageMode.englishOnly : LanguageMode.both;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final storage = context.read<LibraryStorage>();
      final saved = storage.bookmarkChapter(widget.book.id);
      if (saved >= 0 && saved < widget.book.chapters.length) {
        _chapterIndex = saved;
      }
      _initialized = true;
    }
  }

  void _setChapter(int i) {
    setState(() => _chapterIndex = i);
    final storage = context.read<LibraryStorage>();
    storage.setBookmark(widget.book.id, i);
    final progress = (i + 1) / widget.book.chapters.length;
    storage.setProgress(widget.book.id, progress);
  }

  void _showSettings() {
    if (widget.book.isManga) return; // Hide text settings if it's an image book
    
    final storage = context.read<LibraryStorage>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            double size = storage.fontSize;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reader Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.text_fields),
                      const SizedBox(width: 8),
                      Text('Font size: ${size.toInt()}'),
                    ],
                  ),
                  Slider(
                    min: 12,
                    max: 28,
                    divisions: 16,
                    value: size,
                    label: size.toInt().toString(),
                    activeColor: AppColors.gold,
                    onChanged: (v) {
                      setSheetState(() => size = v);
                      storage.setFontSize(v);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Layout',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SegmentedButton<ReaderLayout>(
                    segments: const [
                      ButtonSegment(
                        value: ReaderLayout.sideBySide,
                        icon: Icon(Icons.view_column),
                        label: Text('Side by side'),
                      ),
                      ButtonSegment(
                        value: ReaderLayout.tabbed,
                        icon: Icon(Icons.tab),
                        label: Text('Tabbed'),
                      ),
                    ],
                    selected: {_layout},
                    onSelectionChanged: (set) {
                      setState(() => _layout = set.first);
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _cycleLanguageMode() {
    setState(() {
      if (widget.book.isManga) {
        // Image books only toggle between English Image and Urdu Image
        _langMode = _langMode == LanguageMode.urduOnly
            ? LanguageMode.englishOnly
            : LanguageMode.urduOnly;
      } else {
        // Text books keep the original 3-way toggle
        _langMode = switch (_langMode) {
          LanguageMode.both => LanguageMode.englishOnly,
          LanguageMode.englishOnly => LanguageMode.urduOnly,
          LanguageMode.urduOnly => LanguageMode.both,
        };
      }
    });
  }

  IconData _langIcon() => switch (_langMode) {
        LanguageMode.both => Icons.translate,
        LanguageMode.englishOnly => Icons.text_fields,
        LanguageMode.urduOnly => Icons.language,
      };

  String _langTooltip() {
    if (widget.book.isManga) {
      return _langMode == LanguageMode.englishOnly 
          ? 'Showing English — Tap for Urdu' 
          : 'Showing Urdu — Tap for English';
    }
    return switch (_langMode) {
      LanguageMode.both => 'Showing both — tap for English only',
      LanguageMode.englishOnly => 'English only — tap for Urdu only',
      LanguageMode.urduOnly => 'Urdu only — tap for both',
    };
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Table of Contents',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.deepGold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: widget.book.chapters.length,
                itemBuilder: (context, i) {
                  final ch = widget.book.chapters[i];
                  final selected = i == _chapterIndex;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: selected ? AppColors.gold : AppColors.wood,
                      foregroundColor: AppColors.cream,
                      child: Text('${i + 1}'),
                    ),
                    title: Text(
                      ch.title,
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    selected: selected,
                    onTap: () {
                      Navigator.pop(context);
                      _setChapter(i);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<LibraryStorage>();
    final book = widget.book;
    final chapter = book.chapters[_chapterIndex];
    final isFav = storage.isFavorite(book.id);

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(book.title, overflow: TextOverflow.ellipsis),
        actions: [
          if (!book.isManga) ...[
            IconButton(
              tooltip: 'Decrease font',
              icon: const Icon(Icons.text_decrease),
              onPressed: () => storage.setFontSize(storage.fontSize - 1),
            ),
            IconButton(
              tooltip: 'Increase font',
              icon: const Icon(Icons.text_increase),
              onPressed: () => storage.setFontSize(storage.fontSize + 1),
            ),
          ],
          IconButton(
            tooltip: isFav ? 'Remove bookmark' : 'Bookmark',
            icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => storage.toggleFavorite(book.id),
          ),
          if (!book.isManga)
            PopupMenuButton<ReaderLayout>(
              tooltip: 'Layout',
              icon: const Icon(Icons.view_compact_alt),
              onSelected: (v) => setState(() => _layout = v),
              itemBuilder: (_) => [
                CheckedPopupMenuItem(
                  value: ReaderLayout.sideBySide,
                  checked: _layout == ReaderLayout.sideBySide,
                  child: const Text('Side by Side'),
                ),
                CheckedPopupMenuItem(
                  value: ReaderLayout.tabbed,
                  checked: _layout == ReaderLayout.tabbed,
                  child: const Text('Tabbed'),
                ),
              ],
            ),
          if (!book.isManga)
            IconButton(
              tooltip: 'Reader settings',
              icon: const Icon(Icons.tune),
              onPressed: _showSettings,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: book.isManga
                ? MangaReader(
                    key: ValueKey('${book.id}_${_chapterIndex}_${_langMode.name}'),
                    chapter: chapter,
                    languageMode: _langMode,
                  )
                : DualLanguageReader(
                    key: ValueKey('${book.id}_${_chapterIndex}_${_layout.name}'),
                    chapter: chapter,
                    layout: _layout,
                    languageMode: _langMode,
                    fontSize: storage.fontSize,
                  ),
          ),
          _ChapterNavBar(
            chapter: _chapterIndex,
            total: book.chapters.length,
            onPrev: _chapterIndex > 0 ? () => _setChapter(_chapterIndex - 1) : null,
            onNext: _chapterIndex < book.chapters.length - 1
                ? () => _setChapter(_chapterIndex + 1)
                : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _langTooltip(),
        onPressed: _cycleLanguageMode,
        child: Icon(_langIcon()),
      ),
    );
  }
}

class _ChapterNavBar extends StatelessWidget {
  final int chapter;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _ChapterNavBar({
    required this.chapter,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkMahogany : AppColors.mahogany,
        border: const Border(
          top: BorderSide(color: AppColors.gold, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Previous chapter',
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left, color: AppColors.cream),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Chapter ${chapter + 1} of $total',
                    style: const TextStyle(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : (chapter + 1) / total,
                      minHeight: 4,
                      backgroundColor: AppColors.cream.withOpacity(0.18),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Next chapter',
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right, color: AppColors.cream),
            ),
          ],
        ),
      ),
    );
  }
}