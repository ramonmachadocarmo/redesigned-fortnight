import 'package:monarch/model/product.dart';
import 'package:monarch/utils/converter.dart';

class Stock {
  String? id;
  String warehouse;
  Product product;
  double quantity;
  double blocked = 0;
  double reserved = 0;

  Stock(this.warehouse, this.product, this.quantity);

  void setBlocked(double qty) {
    if (qty <= 0) {
      throw Exception('Quantidade não pode ser negativa');
    }
    blocked = qty;
  }

  void setReserved(double qty) {
    if (qty <= 0) {
      throw Exception('Quantidade não pode ser negativa');
    }
    reserved = qty;
  }

  Map<String, dynamic> toJson() => {
        'warehouse': warehouse,
        'product': product.toJson(),
        'quantity': quantity,
        'blocked': blocked,
        'reserved': reserved,
      };

  Stock.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        warehouse = json['warehouse'] ?? '',
        product = Product.fromJson(json['product']),
        quantity = ConverterCustom.convertDouble(json['quantity']),
        blocked = ConverterCustom.convertDouble(json['blocked']),
        reserved = ConverterCustom.convertDouble(json['reserved']);
}
