import 'package:flutter/foundation.dart';
import 'package:monarch/api/request_controller.dart';
import 'package:monarch/model/product.dart';

class ProductController {
  RequestController controller = RequestController();
  String urlBase = "";

  save(Product prod) async {
    try {
      await controller.post("$urlBase/post", prod.toJson());
    } on Exception {
      rethrow;
    }
  }

  edit(Product prod) async {
    try {
      await controller.patch("$urlBase/patch/${prod.code}", prod.toJson());
    } on Exception {
      rethrow;
    }
  }

  delete(Product prod) async {
    try {
      await controller.delete("$urlBase/delete/${prod.code}", prod.toJson());
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

  Future<List<Product>> get() async {
    try {
      Map<String, dynamic> map = await controller.get("$urlBase/getAll");
      List<dynamic> json = map["products"];
      return json.map((e) => Product.fromJson(e)).toList();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
