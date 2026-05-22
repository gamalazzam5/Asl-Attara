import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.title,
    required super.itemCount,
    required super.imagePath,
    required super.backgroundColor,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      itemCount: json['itemCount'],
      imagePath: json['imagePath'],
      backgroundColor: json['backgroundColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'itemCount': itemCount,
      'imagePath': imagePath,
      'backgroundColor': backgroundColor,
    };
  }
}
