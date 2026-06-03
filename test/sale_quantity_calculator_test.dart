import 'package:aslattara/features/products/domain/entities/product_entity.dart';
import 'package:aslattara/features/sales/domain/services/sale_quantity_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = SaleQuantityCalculator();

  ProductEntity product({
    double quantity = 5,
    String unit = 'كجم',
    double sellPrice = 50,
  }) {
    return ProductEntity(
      id: 1,
      name: 'سبانخ',
      quantity: quantity,
      unit: unit,
      categoryId: 1,
      categoryName: 'خضار',
      buyPrice: 30,
      sellPrice: sellPrice,
      minimumStockQuantity: 1,
    );
  }

  test('calculates sold quantity from entered amount and sell price', () {
    expect(calculator.calculateQuantity(enteredAmount: 100, sellPrice: 50), 2);
  });

  test('formats kilograms below one as grams', () {
    expect(calculator.formatQuantity(0.250, 'كجم'), '250 جرام');
  });

  test('formats signed small stock movements in smaller units', () {
    expect(calculator.formatQuantity(-0.250, 'كجم'), '-250 جرام');
  });

  test('formats liters below one as milliliters', () {
    expect(calculator.formatQuantity(0.500, 'لتر'), '500 مل');
  });

  test('keeps original unit when quantity is at least one', () {
    expect(calculator.formatQuantity(2, 'كجم'), '2 كجم');
    expect(calculator.formatQuantity(3, 'لتر'), '3 لتر');
  });

  test('detects amount that exceeds available stock', () {
    final spinach = product(quantity: 5, sellPrice: 50);

    expect(calculator.maximumSaleAmount(spinach), 250);
    expect(
      calculator.exceedsStock(product: spinach, enteredAmount: 300),
      isTrue,
    );
    expect(
      calculator.exceedsStock(product: spinach, enteredAmount: 250),
      isFalse,
    );
  });
}
