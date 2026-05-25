import '../models/product_model.dart';

class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts() async {
    return [
      ProductModel(
        id: 1,

        name: 'زعتر جاف',

        quantity: 5.5,

        unit: 'كجم',

        minimumStockQuantity: 10,

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

        minimumStockQuantity: 1,

        categoryId: 3,

        // ← زيوت
        categoryName: 'زيوت',

        buyPrice: 80,

        sellPrice: 120,
      ),

      ProductModel(
        id: 3,

        name: 'عطر مسك',

        quantity: 250,

        unit: 'مل',

        minimumStockQuantity: 100,

        categoryId: 4,

        // ← عطور
        categoryName: 'عطور',

        buyPrice: 100,

        sellPrice: 180,
      ),

      ProductModel(
        id: 4,

        name: 'هيل هندي',

        quantity: 500,

        unit: 'جرام',

        minimumStockQuantity: 200,

        categoryId: 2,

        // ← بهارات
        categoryName: 'بهارات',

        buyPrice: 55,

        sellPrice: 85,
      ),

      ProductModel(
        id: 5,

        name: 'تمر عجوة',

        quantity: 3,

        unit: 'كجم',

        minimumStockQuantity: 5,

        categoryId: 5,

        categoryName: 'تمور',

        buyPrice: 140,

        sellPrice: 180,
      ),
    ];
  }
}
