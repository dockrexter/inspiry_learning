import 'package:dio/dio.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_strings.dart';

class APIManager {
  static final APIManager _apiManager = APIManager._internal();

  factory APIManager() {
    return _apiManager;
  }

  APIManager._internal() {
    _dio = Dio(
      BaseOptions(baseUrl: AppStrings.baseUrl),
    );
  }

  late Dio _dio;

  void _addTokenToHeader() {
    var user = ActiveUser.instance.user;
    if (user != null) {
      if (user.token != null) {
        _dio.options.headers['token'] = user.token;
      }
    }
  }

  Future<dynamic> get(String endPoint, {Map<String, dynamic>? params}) async {
    dynamic responseJson;
    try {
      _addTokenToHeader();
      final response = await _dio.get(endPoint, queryParameters: params);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }

  Future<dynamic> post(String endPoint, {dynamic data}) async {
    dynamic responseJson;
    try {
      _addTokenToHeader();
      final response = await _dio.post(endPoint, data: data);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }

  Future<dynamic> put(String endPoint, {dynamic data}) async {
    dynamic responseJson;
    try {
      _addTokenToHeader();
      final response = await _dio.put(endPoint, data: data);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }

  Future<dynamic> delete(String endPoint) async {
    dynamic responseJson;
    try {
      _addTokenToHeader();
      final response = await _dio.delete(endPoint);
      responseJson = response.data;
    } on DioError catch (_) {}
    return responseJson;
  }
}
