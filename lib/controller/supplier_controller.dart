import 'package:flutter/foundation.dart';
import 'package:monarch/api/request_controller.dart';
import 'package:monarch/model/supplier.dart';

class SupplierController {
  RequestController controller = RequestController();
  String urlBase = '';

  save(Supplier sup) async {
    try {
      await controller.post("$urlBase/post", sup.toJson());
    } on Exception {
      rethrow;
    }
  }

  edit(Supplier sup) async {
    try {
      await controller.patch("$urlBase/patch/${sup.cnpj}", sup.toJson());
    } on Exception {
      rethrow;
    }
  }

  delete(Supplier sup) async {
    try {
      await controller.delete("$urlBase/delete/${sup.cnpj}", sup.toJson());
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

  Future<List<Supplier>> get() async {
    try {
      Map<String, dynamic> map = await controller.get("$urlBase/getAll");
      List<dynamic> json = map["suppliers"];
      return json.map((e) => Supplier.fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
