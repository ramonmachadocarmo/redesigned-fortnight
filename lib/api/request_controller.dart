import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:monarch/api/webclient.dart';

class RequestController {
  Dio dio = createDio();

  Future<Response> post(String path, Map<String, dynamic> body) async {
    try {
      final res = await dio.post(path, data: body);
      return res;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e.response?.data["message"]);
    }
  }

  Future<Response> patch(String path, Map<String, dynamic> body) async {
    try {
      final res = await dio.patch(path, data: body);
      return res;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e.response?.data["message"]);
    }
  }

  Future<Response> delete(String path, Map<String, dynamic> body) async {
    try {
      final res = await dio.delete(path, data: body);
      return res;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e.response?.data["message"]);
    }
  }

  Future<dynamic> get(String path) async {
    try {
      final res = await dio.get(path);
      return res.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e.response?.data["message"]);
    }
  }
}
