import 'dart:developer';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:dio/dio.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/services/storage_service.dart';
import 'package:TradeZentrum/app/utils/storage_key.dart';

class ApiService {
  final Dio _dio = Dio();

  final ApiUrl _apiUrl = ApiUrl();

  Future<Map<String, dynamic>> hearedConfigure() async {
    Map<String, dynamic> headers = {};
    var token = await StorageService().readData(StorageKey().token);
    bool authenticated = token != null ? true : false;
    if (authenticated) {
      headers = {
        'Content-Type': 'application/json',
        "Accpet": 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      headers = {
        'Content-Type': 'application/json',
      };
    }
    return headers;
  }

  getData({String? endpoint}) async {
    Map<String, dynamic> headers = await hearedConfigure();
    log("Api url: ${_apiUrl.baseUrl + endpoint!}, Method: Get,");

    try {
      final response = await _dio.get(_apiUrl.baseUrl + endpoint,
          options: Options(headers: headers));
      return ApiResponse(success: true, data: response);
    } on DioException catch (error) {
      log("Error: $error");
      return ApiResponse(success: false, error: error.response);
    }
  }

  postData({
    String? endpoint,
    Map<String, dynamic>? data,
  }) async {
    Map<String, dynamic> headers = await hearedConfigure();
    log("Api url: ${_apiUrl.baseUrl + endpoint!}, Method: Post, Api body: $data");
    try {
      final response = await _dio.post(
        _apiUrl.baseUrl + endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResponse(success: true, data: response);
    } on DioException catch (error) {
      log("Error: $error");
      endLoading();
      return ApiResponse(success: false, error: error.response);
    }
  }

  updateData({
    String? endpoint,
    Map<String, dynamic>? data,
  }) async {
    Map<String, dynamic> headers = await hearedConfigure();
    log("Api url: ${_apiUrl.baseUrl + endpoint!}, Method: Put, Api body: $data");
    try {
      final response = await _dio.put(
        _apiUrl.baseUrl + endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResponse(success: true, data: response);
    } on DioException catch (error) {
      log("Error: $error");
      return ApiResponse(success: false, error: error.response);
    }
  }

  deleteData({String? endpoint}) async {
    Map<String, dynamic> headers = await hearedConfigure();
    log("Api url: ${_apiUrl.baseUrl + endpoint!}, Method: Delete");
    try {
      final response = await _dio.delete(
        _apiUrl.baseUrl + endpoint,
        options: Options(headers: headers),
      );
      return ApiResponse(success: true, data: response);
    } on DioException catch (error) {
      return ApiResponse(success: true, data: error.response);
    }
  }
}

class ApiResponse {
  final bool success;
  final Response? data;
  final Response? error;

  ApiResponse({required this.success, this.data, this.error});
}
