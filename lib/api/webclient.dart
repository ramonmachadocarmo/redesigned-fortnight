import 'package:dio/dio.dart';
import 'package:monarch/api/interceptors/dio_interceptors.dart';

Dio createDio() {
  Dio dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      // baseUrl: MySharedPreferences.getString(MySharedPreferences.baseUrl),
    ),
  );
  dio = addInterceptors(dio);
  return dio;
}

Dio addInterceptors(Dio dio) {
  return dio..interceptors.add(CustomInterceptors());
}
