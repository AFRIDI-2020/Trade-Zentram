import 'package:TradeZentrum/app/model/auth_model.dart';
import 'package:TradeZentrum/app/services/api_services.dart';

class AuthRepository {
  ApiService apiService = ApiService();

  Future<Map<String, dynamic>> signIn(
      {String? endPoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.postData(endpoint: endPoint, data: data);
    if (response.success) {
      var auth = AuthModel.fromJson(response.data!.data);
      return {"data": auth.dataObj?.token ?? "", "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  Future<Map<String, dynamic>> sendDeviceToken(
      {String? endPoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
    await apiService.postData(endpoint: endPoint, data: data);
    return {"data": response, "status": true};
  }

  Future<Map<String, dynamic>> updatePassword(
      {String? endPoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.updateData(endpoint: endPoint, data: data);
    if (response.success) {
      return {"data": response.data, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }
}
