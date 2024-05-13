class AuthModel {
  int? statusCode;
  String? message;
  DataObj? dataObj;

  AuthModel({statusCode, message, dataObj});

  AuthModel.fromJson(Map<String, dynamic> json) {
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
  String? errMsg;
  String? token;
  String? menuToken;
  String? menuInPlainListToken;

  DataObj({errMsg, token, menuToken, menuInPlainListToken});

  DataObj.fromJson(Map<String, dynamic> json) {
    errMsg = json['errMsg'];
    token = json['token'];
    menuToken = json['menuToken'];
    menuInPlainListToken = json['menuInPlainListToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['errMsg'] = errMsg;
    data['token'] = token;
    data['menuToken'] = menuToken;
    data['menuInPlainListToken'] = menuInPlainListToken;
    return data;
  }
}
