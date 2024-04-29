import 'package:monarch/model/product.dart';
import 'package:monarch/utils/converter.dart';

class PurchaseOrderItem {
  String? id;
  Product product;
  double quantity;
  double price;
  double discount;

  PurchaseOrderItem(
    this.product,
    this.quantity,
    this.price,
    this.discount,
  );

  Map<String, dynamic> toJson() => {
        'product': product,
        'quantity': quantity,
        'price': price,
        'discount': discount,
      };
  PurchaseOrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        product = Product.fromJson(json["product"]),
        quantity = ConverterCustom.convertDouble(json['quantity']),
        price = ConverterCustom.convertDouble(json['price']),
        discount = ConverterCustom.convertDouble(json['discount']);

  static List<PurchaseOrderItem> listFromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['items'];
    dynamic ret = list.map((e) => PurchaseOrderItem.fromJson(e)).toList();
    return ret;
  }
}
