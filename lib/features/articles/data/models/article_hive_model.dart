import 'package:hive/hive.dart';
import '../../domain/entities/article.dart';
import 'article_model.dart';

part 'article_hive_model.g.dart';

@HiveType(typeId: 0)
class ArticleHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String summary;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final DateTime publishedAt;

  @HiveField(5)
  final bool isFavorite;

  ArticleHiveModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.publishedAt,
    required this.isFavorite,
  });

  // Convert from Article entity
  factory ArticleHiveModel.fromEntity(Article article) {
    return ArticleHiveModel(
      id: article.id,
      title: article.title,
      summary: article.summary,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      isFavorite: article.isFavorite,
    );
  }

  // Convert from ArticleModel
  factory ArticleHiveModel.fromModel(ArticleModel model) {
    return ArticleHiveModel(
      id: model.id,
      title: model.title,
      summary: model.summary,
      imageUrl: model.imageUrl,
      publishedAt: model.publishedAt,
      isFavorite: model.isFavorite,
    );
  }

  // Convert to Article entity
  Article toEntity() {
    return Article(
      id: id,
      title: title,
      summary: summary,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      isFavorite: isFavorite,
    );
  }

  // Convert to ArticleModel
  ArticleModel toModel() {
    return ArticleModel(
      id: id,
      title: title,
      summary: summary,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      isFavorite: isFavorite,
    );
  }

  ArticleHiveModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return ArticleHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleHiveModel &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.imageUrl == imageUrl &&
        other.publishedAt == publishedAt &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        imageUrl.hashCode ^
        publishedAt.hashCode ^
        isFavorite.hashCode;
  }
}