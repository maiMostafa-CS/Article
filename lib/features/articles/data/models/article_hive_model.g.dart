// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleHiveModelAdapter extends TypeAdapter<ArticleHiveModel> {
  @override
  final int typeId = 0;

  @override
  ArticleHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      summary: fields[2] as String,
      imageUrl: fields[3] as String,
      publishedAt: fields[4] as DateTime,
      isFavorite: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.publishedAt)
      ..writeByte(5)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
