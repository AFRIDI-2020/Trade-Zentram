class DeclearTaskStartModel {
  int? statusCode;
  String? message;
  DataObj? dataObj;

  DeclearTaskStartModel({statusCode, message, dataObj});

  DeclearTaskStartModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    dataObj =
        json['dataObj'] != null ?  DataObj.fromJson(json['dataObj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (dataObj != null) {
      data['dataObj'] = dataObj!.toJson();
    }
    return data;
  }
}

class DataObj {
  Data? data;

  DataObj({data});

  DataObj.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['data'] = this.data!.toJson();
      return data;
  }
}

class Data {
  int? taskId;
  String? taskName;
  String? taskDescription;
  String? taskDestination;
  String? taskDestinationAddress;
  String? taskJobTypeId;
  int? taskRelatedInvoiceId;
  int? taskAssignedTo;
  String? taskAssignTime;
  String? taskStartTime;
  String? taskEndTime;
  int? taskStatus;
  int? taskRelatedTaskId;
  int? taskAssignBy;
  int? taskChannelId;
  String? taskGroupId;
  String? taskOtpVerified;

  Data(
      {taskId,
      taskName,
      taskDescription,
      taskDestination,
      taskDestinationAddress,
      taskJobTypeId,
      taskRelatedInvoiceId,
      taskAssignedTo,
      taskAssignTime,
      taskStartTime,
      taskEndTime,
      taskStatus,
      taskRelatedTaskId,
      taskAssignBy,
      taskChannelId,
      taskGroupId,
      taskOtpVerified});

  Data.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    taskDestination = json['taskDestination'];
    taskDestinationAddress = json['taskDestinationAddress'];
    taskJobTypeId = json['taskJobTypeId'];
    taskRelatedInvoiceId = json['taskRelatedInvoiceId'];
    taskAssignedTo = json['taskAssignedTo'];
    taskAssignTime = json['taskAssignTime'];
    taskStartTime = json['taskStartTime'];
    taskEndTime = json['taskEndTime'];
    taskStatus = json['taskStatus'];
    taskRelatedTaskId = json['taskRelatedTaskId'];
    taskAssignBy = json['taskAssignBy'];
    taskChannelId = json['taskChannelId'];
    taskGroupId = json['taskGroupId'];
    taskOtpVerified = json['taskOtpVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['taskId'] = taskId;
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['taskDestination'] = taskDestination;
    data['taskDestinationAddress'] = taskDestinationAddress;
    data['taskJobTypeId'] = taskJobTypeId;
    data['taskRelatedInvoiceId'] = taskRelatedInvoiceId;
    data['taskAssignedTo'] = taskAssignedTo;
    data['taskAssignTime'] = taskAssignTime;
    data['taskStartTime'] = taskStartTime;
    data['taskEndTime'] = taskEndTime;
    data['taskStatus'] = taskStatus;
    data['taskRelatedTaskId'] = taskRelatedTaskId;
    data['taskAssignBy'] = taskAssignBy;
    data['taskChannelId'] = taskChannelId;
    data['taskGroupId'] = taskGroupId;
    data['taskOtpVerified'] = taskOtpVerified;
    return data;
  }
}
