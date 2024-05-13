class VehiclesModel {
  int? statusCode;
  String? message;
  DataObj? dataObj;

  VehiclesModel({statusCode, message, dataObj});

  VehiclesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    dataObj =
        json['dataObj'] != null ?  DataObj.fromJson(json['dataObj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (dataObj != null) {
      data['dataObj'] = dataObj!.toJson();
    }
    return data;
  }
}

class DataObj {
  List<VehicleData>? data;

  DataObj({data});

  DataObj.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add( VehicleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = this.data!.map((v) => v.toJson()).toList();
      return data;
  }
}

class VehicleData {
  int? key;
  String? value;

  VehicleData({key, value});

  VehicleData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
