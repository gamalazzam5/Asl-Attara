import '../models/category_model.dart';

class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories() async {
    return [
      CategoryModel(
        id: 1,
        title: 'أعشاب',
        itemCount: '32',
        imagePath: 'assets/icons/herbs.png',
        backgroundColor: '#D4F1E4',
      ),

      CategoryModel(
        id: 2,
        title: 'بهارات',
        itemCount: '28',
        imagePath: 'assets/icons/spices.png',
        backgroundColor: '#FFF3E0',
      ),

      CategoryModel(
        id: 3,
        title: 'زيوت',
        itemCount: '18',
        imagePath: 'assets/icons/oils.png',
        backgroundColor: '#E8EAF6',
      ),

      CategoryModel(
        id: 4,
        title: 'عطور',
        itemCount: '22',
        imagePath: 'assets/icons/perfume.png',
        backgroundColor: '#FCE4EC',
      ),

      CategoryModel(
        id: 5,
        title: 'تمور',
        itemCount: '15',
        imagePath: 'assets/icons/dates.png',
        backgroundColor: '#F3E5F5',
      ),

      CategoryModel(
        id: 6,
        title: 'بقوليات',
        itemCount: '20',
        imagePath: 'assets/icons/legumes.png',
        backgroundColor: '#FFF9C4',
      ),

      CategoryModel(
        id: 7,
        title: 'حبوب',
        itemCount: '26',
        imagePath: 'assets/icons/grains.png',
        backgroundColor: '#E1F5FE',
      ),

      CategoryModel(
        id: 8,
        title: 'مكسرات',
        itemCount: '14',
        imagePath: 'assets/icons/nuts.png',
        backgroundColor: '#FBE9E7',
      ),
    ];
  }
}
