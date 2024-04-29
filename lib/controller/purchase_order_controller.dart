import 'package:flutter/foundation.dart';
import 'package:monarch/api/request_controller.dart';
import 'package:monarch/model/purchase_order.dart';

class PurchaseOrderController {
  RequestController controller = RequestController();
  String urlBase = '';
  save(PurchaseOrder purchaseOrder) async {
    try {
      await controller.post("$urlBase/post", purchaseOrder.toJson());
    } on Exception {
      rethrow;
    }
  }

  confirm(PurchaseOrder purchaseOrder) async {
    try {
      await controller.patch(
          "$urlBase/confirmPO/${purchaseOrder.number}", purchaseOrder.toJson());
    } on Exception {
      rethrow;
    }
  }

  edit(PurchaseOrder purchaseOrder) async {
    try {
      await controller.patch(
          "$urlBase/patch/${purchaseOrder.number}", purchaseOrder.toJson());
    } on Exception {
      rethrow;
    }
  }

  delete(PurchaseOrder purchaseOrder) async {
    try {
      await controller.delete(
          "$urlBase/delete/${purchaseOrder.number}", purchaseOrder.toJson());
    } on Exception {
      rethrow;
    }
  }

  Future<List<PurchaseOrder>> get() async {
    try {
      Map<String, dynamic> map = await controller.get("$urlBase/getAll");
      List<dynamic> json = map["pos"];
      List<dynamic> remove = [];
      for (var element in json) {
        if (element["supplier"] is String) {
          remove.add(element);
        }
      }
      for (var element in remove) {
        json.remove(element);
      }
      return json.map((e) => PurchaseOrder.fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<String> getNextCode() async {
    try {
      Map<String, dynamic> map = await controller.get("$urlBase/getNextCode");
      return map["nextCode"];
    } on Exception {
      rethrow;
    }
  }
}
