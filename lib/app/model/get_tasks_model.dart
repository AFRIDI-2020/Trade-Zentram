class GetTasksModel {
  int? statusCode;
  String? message;
  DataObj? dataObj;

  GetTasksModel({statusCode, message, dataObj});

  GetTasksModel.fromJson(Map<String, dynamic> json) {
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
  List<TaskData>? data;

  DataObj({data});

  DataObj.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add( TaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskData {
  int? taskId;
  String? taskName;
  String? empFirstName;
  String? empLastName;
  int? taskRelatedInvoiceId;
  String? soSystemNo;
  String? taskDestination;
  String? taskDestinationAddress;
  String? taskAssignTime;
  String? taskStartTime;
  String? taskEndTime;
  int? taskStatus;
  int? taskAssignBy;
  int? taskChannelId;
  String? taskGroupId;

  TaskData(
      {taskId,
      taskName,
      empFirstName,
      empLastName,
      taskRelatedInvoiceId,
      soSystemNo,
      taskDestination,
      taskDestinationAddress,
      taskAssignTime,
      taskStartTime,
      taskEndTime,
      taskStatus,
      taskAssignBy,
      taskChannelId,
      taskGroupId});

  TaskData.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskName = json['taskName'];
    empFirstName = json['empFirstName'];
    empLastName = json['empLastName'];
    taskRelatedInvoiceId = json['taskRelatedInvoiceId'];
    soSystemNo = json['soSystemNo'];
    taskDestination = json['taskDestination'];
    taskDestinationAddress = json['taskDestinationAddress'];
    taskAssignTime = json['taskAssignTime'];
    taskStartTime = json['taskStartTime'];
    taskEndTime = json['taskEndTime'];
    taskStatus = json['taskStatus'];
    taskAssignBy = json['taskAssignBy'];
    taskChannelId = json['taskChannelId'];
    taskGroupId = json['taskGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['taskId'] = taskId;
    data['taskName'] = taskName;
    data['empFirstName'] = empFirstName;
    data['empLastName'] = empLastName;
    data['taskRelatedInvoiceId'] = taskRelatedInvoiceId;
    data['soSystemNo'] = soSystemNo;
    data['taskDestination'] = taskDestination;
    data['taskDestinationAddress'] = taskDestinationAddress;
    data['taskAssignTime'] = taskAssignTime;
    data['taskStartTime'] = taskStartTime;
    data['taskEndTime'] = taskEndTime;
    data['taskStatus'] = taskStatus;
    data['taskAssignBy'] = taskAssignBy;
    data['taskChannelId'] = taskChannelId;
    data['taskGroupId'] = taskGroupId;
    return data;
  }
}
