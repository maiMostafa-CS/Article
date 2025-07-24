import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/article.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.imageUrl,
    required super.publishedAt,
    super.isFavorite = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      summary: article.summary,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      isFavorite: article.isFavorite,
    );
  }

  @override
  ArticleModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}