import '../models/category_model.dart';

class CategoryLocalDataSource {
  final List<CategoryModel> _categories = [
    CategoryModel(
      id: 1,
      title: 'أعشاب',
      itemCount: '32',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#D4F1E4',
    ),

    CategoryModel(
      id: 2,
      title: 'بهارات',
      itemCount: '28',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#FFF3E0',
    ),

    CategoryModel(
      id: 3,
      title: 'زيوت',
      itemCount: '18',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#E8EAF6',
    ),
  ];

  Future<List<CategoryModel>> getCategories() async {
    return _categories;
  }

  Future<void> addCategory(CategoryModel category) async {
    _categories.add(category);
  }
}
