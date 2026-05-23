import '../models/product_model.dart';

class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts() async {
    return [
      ProductModel(
        id: 1,

        name: 'زعتر جاف',

        quantity: 5.5,

        unit: 'كجم',

        lowStock: true,

        categoryId: 1,

        categoryName: 'أعشاب',

        buyPrice: 45,

        sellPrice: 65,
      ),

      ProductModel(
        id: 2,

        name: 'زيت زيتون',

        quantity: 2,

        unit: 'لتر',

        lowStock: false,

        categoryId: 2,

        categoryName: 'زيوت',

        buyPrice: 80,

        sellPrice: 120,
      ),

      ProductModel(
        id: 3,

        name: 'عطر مسك',

        quantity: 250,

        unit: 'مل',

        lowStock: false,

        categoryId: 3,

        categoryName: 'عطور',

        buyPrice: 100,

        sellPrice: 180,
      ),
    ];
  }
}
