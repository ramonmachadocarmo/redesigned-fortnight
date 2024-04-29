import 'package:monarch/model/purchase_order_item.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/utils/converter.dart';

class PurchaseOrder {
  String? id;
  String number;
  Supplier supplier;
  DateTime purchaseDate;
  double value;
  double discount;
  String status;
  String? paymentCondition;
  List<PurchaseOrderItem> items;

  PurchaseOrder(
    this.number,
    this.supplier,
    this.purchaseDate,
    this.value,
    this.discount,
    this.status,
    this.items,
  );
  Map<String, dynamic> toJson() => {
        'numberPO': number,
        'supplier': supplier.toJson(),
        'purchaseDate': purchaseDate.toIso8601String(),
        'value': value,
        'discount': discount,
        'status': status,
        'paymentCondition': paymentCondition,
        'items': items.map((e) => e.toJson()).toList(),
      };
  PurchaseOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['numberPO'],
        supplier = Supplier.fromJson(json["supplier"]),
        purchaseDate = DateTime.parse(json['purchaseDate']),
        value = ConverterCustom.convertDouble(json['value']),
        discount = ConverterCustom.convertDouble(json['discount']),
        status = json['status'],
        items = PurchaseOrderItem.listFromJson(json),
        paymentCondition = json['paymentCondition'];
}
