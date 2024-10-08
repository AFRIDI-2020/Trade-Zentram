import 'dart:developer';

import 'package:TradeZentrum/app/model/get_tasks_model.dart';

import 'package:TradeZentrum/app/services/api_services.dart';

class HomeRepository {
  ApiService apiService = ApiService();

  getTasks({
    String? endPoint,
  }) async {
    ApiResponse response = await apiService.getData(endpoint: endPoint);
     if (response.success) {
      if(response.data!.statusCode == 200) {
        var res = GetTasksModel.fromJson(response.data!.data);
        return {"data": res.dataObj!.data ?? {}, "status": true};
      }
      return {"data": response.error!.data["errMsg"], "status": false};

    } else {
      return {"data": response.error!.data["errMsg"], "status": false};
    }
  }
}
