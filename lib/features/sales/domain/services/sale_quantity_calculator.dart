import '../../../../core/utils/quantity_formatter.dart';
import '../../../products/domain/entities/product_entity.dart';

class SaleQuantityCalculator {
  const SaleQuantityCalculator();

  double calculateQuantity({
    required double enteredAmount,
    required double sellPrice,
  }) {
    if (enteredAmount <= 0 || sellPrice <= 0) return 0;

    return enteredAmount / sellPrice;
  }

  double maximumSaleAmount(ProductEntity product) {
    return product.quantity * product.sellPrice;
  }

  bool exceedsStock({
    required ProductEntity product,
    required double enteredAmount,
  }) {
    final calculatedQuantity = calculateQuantity(
      enteredAmount: enteredAmount,
      sellPrice: product.sellPrice,
    );

    return calculatedQuantity > product.quantity;
  }

  String formatQuantity(double quantity, String unit) {
    return QuantityFormatter.format(quantity, unit);
  }
}
