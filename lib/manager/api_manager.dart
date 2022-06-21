import 'package:dio/dio.dart';
import 'package:inspiry_learning/globals/app_strings.dart';

class APIManager {
  static final APIManager _apiManager = APIManager._internal();

  factory APIManager() {
    return _apiManager;
  }

  APIManager._internal() {
    _dio = Dio(BaseOptions(baseUrl: AppStrings.baseUrl));
  }

  late Dio _dio;

  Future<dynamic> get(String endPoint) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(endPoint);
      responseJson = response.data;
    }  on DioError catch(_){}
    return responseJson;
  }

  Future<dynamic> post(String endPoint, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await _dio.post(endPoint, data: data);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }

  Future<dynamic> put(String endPoint, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await _dio.put(endPoint, data: data);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }

  Future<dynamic> delete(String endPoint) async {
    dynamic responseJson;
    try {
      final response = await _dio.delete(endPoint);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }
}
