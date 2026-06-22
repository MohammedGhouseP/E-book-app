class Chapter {
  final String title;
  final String englishText;
  final String urduText;
  final List<String> englishPageUrls; // Added for English S3 images
  final List<String> urduPageUrls;    // Added for Urdu S3 images

  const Chapter({
    required this.title,
    this.englishText = '',
    this.urduText = '',
    this.englishPageUrls = const [],
    this.urduPageUrls = const [],
  });
}

class Book {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final String shelfId;
  final bool isManga; // Added so the app knows which reader UI to open
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.shelfId,
    this.isManga = false, // Existing text books will default to false
    required this.chapters,
  });
}