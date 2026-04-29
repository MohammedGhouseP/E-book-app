import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryStorage extends ChangeNotifier {
  static const _kFavoritesKey = 'fav_books';
  static const _kBookmarkPrefix = 'bookmark_';
  static const _kProgressPrefix = 'progress_';
  static const _kFontSizeKey = 'reader_font_size';

  Set<String> _favorites = {};
  final Map<String, int> _bookmarks = {};
  final Map<String, double> _progress = {};
  double _fontSize = 16;

  bool get loaded => _loaded;
  bool _loaded = false;

  double get fontSize => _fontSize;

  LibraryStorage() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = (prefs.getStringList(_kFavoritesKey) ?? const []).toSet();
    _fontSize = prefs.getDouble(_kFontSizeKey) ?? 16;
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_kBookmarkPrefix)) {
        final id = key.substring(_kBookmarkPrefix.length);
        _bookmarks[id] = prefs.getInt(key) ?? 0;
      } else if (key.startsWith(_kProgressPrefix)) {
        final id = key.substring(_kProgressPrefix.length);
        _progress[id] = prefs.getDouble(key) ?? 0;
      }
    }
    _loaded = true;
    notifyListeners();
  }

  bool isFavorite(String bookId) => _favorites.contains(bookId);

  Future<void> toggleFavorite(String bookId) async {
    if (_favorites.contains(bookId)) {
      _favorites.remove(bookId);
    } else {
      _favorites.add(bookId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, _favorites.toList());
  }

  int bookmarkChapter(String bookId) => _bookmarks[bookId] ?? 0;

  Future<void> setBookmark(String bookId, int chapterIndex) async {
    _bookmarks[bookId] = chapterIndex;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_kBookmarkPrefix$bookId', chapterIndex);
  }

  double progressOf(String bookId) => _progress[bookId] ?? 0;

  Future<void> setProgress(String bookId, double percent) async {
    _progress[bookId] = percent.clamp(0, 1);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_kProgressPrefix$bookId', _progress[bookId]!);
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(12, 28);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kFontSizeKey, _fontSize);
  }
}
