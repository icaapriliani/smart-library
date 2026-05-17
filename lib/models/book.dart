class Book {
  final String title;
  final String author;
  final double rating;
  final int progress;
  final String status;
  final String image;
  final String category;
  final int year;
  final int pages;
  final String language;
  final String description;
  bool isFavorite;
  final DateTime? dateAdded;
  final DateTime? dateCompleted;

  Book({
    required this.title,
    required this.author,
    required this.rating,
    required this.progress,
    required this.status,
    required this.image,
    required this.category,
    required this.year,
    required this.pages,
    required this.language,
    required this.description,
    this.isFavorite = false,
    this.dateAdded,
    this.dateCompleted,
  });

  Book copyWith({
    String? title,
    String? author,
    double? rating,
    int? progress,
    String? status,
    String? image,
    String? category,
    int? year,
    int? pages,
    String? language,
    String? description,
    bool? isFavorite,
    DateTime? dateAdded,
    DateTime? dateCompleted,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      image: image ?? this.image,
      category: category ?? this.category,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      dateAdded: dateAdded ?? this.dateAdded,
      dateCompleted: dateCompleted ?? this.dateCompleted,
    );
  }
}
