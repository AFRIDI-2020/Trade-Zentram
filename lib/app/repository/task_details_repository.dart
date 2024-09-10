import 'dart:developer';

import 'package:TradeZentrum/app/services/api_services.dart';

class TaskDetailsRepository {
  ApiService apiService = ApiService();

  declareTaskStart({
    String? endPoint,
  }) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint);
    if (response.success) {
      log("Task Start details: ${response.data?.data}");
      return {
        "data": response.data?.data['dataObj']['data'] ?? {},
        "status": true
      };
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  getTaskDetails({
    String? endPoint,
  }) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint);
    if (response.success) {
      log("Individual Task details: ${response.data}");
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  getLocations({String? endPoint}) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error?.data["errMsg"] ?? "", "status": false};
    }
  }

  getVehiclesList({String? endPoint}) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint);
    if (response.success) {
      log("Vehicles List: ${response.data}");
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  addTransport({String? endpoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.postData(endpoint: endpoint, data: data);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  deleteTransport({String? endpoint}) async {
    ApiResponse response = await apiService.deleteData(endpoint: endpoint);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  reachedTransport({String? endpoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.postData(endpoint: endpoint, data: data);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  updateTransport({String? endpoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.updateData(endpoint: endpoint, data: data);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  declearCheckListCompletion({String? endpoint}) async {
    ApiResponse response = await apiService.getData(
      endpoint: endpoint,
    );
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  getOtp({String? endPoint, Map<String, dynamic>? data}) async {
    ApiResponse response =
        await apiService.postData(endpoint: endPoint!, data: data);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  verifyOtp({String? endPoint}) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint!);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }

  returnTask({String? endPoint}) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint!);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }
  taskAccomplish({String? endPoint})async{
    ApiResponse response = await apiService.getData(endpoint: endPoint!);
    if (response.success) {
      return {"data": response.data ?? {}, "status": true};
    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }
}
