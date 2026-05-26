import 'package:aslattara/core/database/app_database.dart';
import 'package:aslattara/core/services/service_locator.dart';
import 'package:aslattara/features/categories/data/datasource/category_local_data_source.dart';
import 'package:aslattara/features/categories/data/models/category_model.dart';
import 'package:aslattara/features/products/data/datasource/product_local_data_source.dart';
import 'package:aslattara/features/products/data/models/product_model.dart';
import 'package:aslattara/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await getIt.reset();
  });

  testWidgets('App boots with the configured router', (tester) async {
    setupServiceLocator();

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.byType(MyApp), findsOneWidget);
  });

  test(
    'SQLite starts without seed products and stores category rows',
    () async {
      const databaseName = 'aslattara_test.db';
      final databasePath = join(await getDatabasesPath(), databaseName);
      await databaseFactory.deleteDatabase(databasePath);

      final appDatabase = AppDatabase(databaseName: databaseName);
      final productDataSource = ProductLocalDataSource(appDatabase);
      final categoryDataSource = CategoryLocalDataSource(appDatabase);

      addTearDown(() async {
        await appDatabase.close();
        await databaseFactory.deleteDatabase(databasePath);
      });

      expect(await categoryDataSource.getCategories(), isEmpty);
      expect(await productDataSource.getProducts(), isEmpty);

      await categoryDataSource.addCategory(
        CategoryModel(
          id: 1,
          title: 'أعشاب',
          itemCount: '0',
          imagePath: 'assets/images/greens.png',
          backgroundColor: '#D4F1E4',
        ),
      );

      var categories = await categoryDataSource.getCategories();
      expect(categories, hasLength(1));
      expect(categories.first.itemCount, '0');

      await productDataSource.addProduct(
        ProductModel(
          id: 1,
          name: 'نعناع',
          quantity: 3,
          minimumStockQuantity: 1,
          categoryId: 1,
          unit: 'كجم',
          categoryName: 'أعشاب',
          buyPrice: 10,
          sellPrice: 15,
        ),
      );

      categories = await categoryDataSource.getCategories();
      expect(categories.first.itemCount, '1');
    },
  );
}
