class Chapter {
  final String title;
  final String englishText;
  final String urduText;

  const Chapter({
    required this.title,
    required this.englishText,
    required this.urduText,
  });
}

class Book {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final String shelfId;
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.shelfId,
    required this.chapters,
  });
}
