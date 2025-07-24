import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final DateTime publishedAt;
  final bool isFavorite;

  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.publishedAt,
    this.isFavorite = false,
  });

  Article copyWith({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        imageUrl,
        publishedAt,
        isFavorite,
      ];
}