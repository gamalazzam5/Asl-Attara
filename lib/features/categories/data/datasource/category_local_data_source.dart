import '../../../products/data/datasource/product_local_data_source.dart';

import '../models/category_model.dart';

class CategoryLocalDataSource {
  final ProductLocalDataSource productDataSource;

  CategoryLocalDataSource(this.productDataSource);

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: 1,
      title: 'أعشاب',
      itemCount: '0',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#D4F1E4',
    ),

    CategoryModel(
      id: 2,
      title: 'بهارات',
      itemCount: '0',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#FFF3E0',
    ),

    CategoryModel(
      id: 3,
      title: 'زيوت',
      itemCount: '0',
      imagePath: 'assets/images/greens.png',
      backgroundColor: '#E8EAF6',
    ),
  ];

  Future<List<CategoryModel>> getCategories() async {
    final products = await productDataSource.getProducts();

    return _categories.map((category) {
      final count = products
          .where((product) => product.categoryId == category.id)
          .length;

      return CategoryModel(
        id: category.id,

        title: category.title,

        itemCount: count.toString(),

        imagePath: category.imagePath,

        backgroundColor: category.backgroundColor,
      );
    }).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    _categories.add(category);
  }
}
