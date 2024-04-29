import 'package:flutter/foundation.dart';
import 'package:monarch/api/request_controller.dart';
import 'package:monarch/model/stock.dart';

class StockController {
  RequestController controller = RequestController();
  String urlBase = '';

  save(Stock stock) async {
    try {
      await controller.post("$urlBase/post", stock.toJson());
    } on Exception {
      rethrow;
    }
  }

  delete(Stock stock) async {
    try {
      await controller.delete(
          "$urlBase/delete/${stock.warehouse}", stock.toJson());
    } on Exception {
      rethrow;
    }
  }

  Future<String> getNextCode(String category) async {
    try {
      Map<String, dynamic> map =
          await controller.get("$urlBase/getNextCode/$category");
      return map["nextCode"];
    } on Exception {
      rethrow;
    }
  }

  Future<List<Stock>> get() async {
    try {
      Map<String, dynamic> map = await controller.get("$urlBase/getAll");
      List<dynamic> json = map["stocks"];
      List<dynamic> remove = [];
      for (var element in json) {
        if (element["product"] == null) {
          remove.add(element);
        }
      }
      for (var element in remove) {
        json.remove(element);
      }
      return json.map((e) => Stock.fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
