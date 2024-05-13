class TaskDetailsModel {
  int? statusCode;
  String? message;
  DataObj? dataObj;

  TaskDetailsModel({statusCode, message, dataObj});

  TaskDetailsModel.fromJson(Map<String, dynamic> json) {
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
  TaskDetailsData? data;
  DataObj({data});

  DataObj.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  TaskDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = this.data!.toJson();
      return data;
  }
}

class TaskDetailsData {
  int? taskId;
  String? taskName;
  String? taskDescription;
  String? taskDestination;
  String? taskDestinationAddress;
  String? taskJobTypeId;
  int? taskRelatedInvoiceId;
  String? taskRelatedInvoiceName;
  int? taskAssignedTo;
  String? employeeCode;
  String? empFirstName;
  String? empLastName;
  String? taskAssignTime;
  String? taskStartTime;
  String? taskEndTime;
  int? taskStatus;
  int? taskRelatedTaskId;
  String? jobTypeId;
  String? jobType;
  String? soSystemNo;
  int? taskAssignBy;
  int? taskChannelId;
  String? taskGroupId;
  int? taskOtpVerified;
  List<TaskChecklistsData>? taskChecklistsData;
  List<TaskTransportationData>? taskTransportationData;

  TaskDetailsData(
      {taskId,
      taskName,
      taskDescription,
      taskDestination,
      taskDestinationAddress,
      taskJobTypeId,
      taskRelatedInvoiceId,
      taskRelatedInvoiceName,
      taskAssignedTo,
      employeeCode,
      empFirstName,
      empLastName,
      taskAssignTime,
      taskStartTime,
      taskEndTime,
      taskStatus,
      taskRelatedTaskId,
      jobTypeId,
      jobType,
      soSystemNo,
      taskAssignBy,
      taskChannelId,
      taskGroupId,
      taskOtpVerified,
      taskChecklistsData,
      taskTransportationData});

  TaskDetailsData.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    taskDestination = json['taskDestination'];
    taskDestinationAddress = json['taskDestinationAddress'];
    taskJobTypeId = json['taskJobTypeId'];
    taskRelatedInvoiceId = json['taskRelatedInvoiceId'];
    taskRelatedInvoiceName = json['taskRelatedInvoiceName'];
    taskAssignedTo = json['taskAssignedTo'];
    employeeCode = json['employeeCode'];
    empFirstName = json['empFirstName'];
    empLastName = json['empLastName'];
    taskAssignTime = json['taskAssignTime'];
    taskStartTime = json['taskStartTime'];
    taskEndTime = json['taskEndTime'];
    taskStatus = json['taskStatus'];
    taskRelatedTaskId = json['taskRelatedTaskId'];
    jobTypeId = json['jobTypeId'];
    jobType = json['jobType'];
    soSystemNo = json['soSystemNo'];
    taskAssignBy = json['taskAssignBy'];
    taskChannelId = json['taskChannelId'];
    taskGroupId = json['taskGroupId'];
    taskOtpVerified = json['taskOtpVerified'];
    if (json['taskChecklistsData'] != null) {
      taskChecklistsData = <TaskChecklistsData>[];
      json['taskChecklistsData'].forEach((v) {
        taskChecklistsData!.add( TaskChecklistsData.fromJson(v));
      });
    }
    if (json['taskTransportationData'] != null) {
      taskTransportationData = <TaskTransportationData>[];
      json['taskTransportationData'].forEach((v) {
        taskTransportationData!.add( TaskTransportationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['taskId'] = taskId;
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['taskDestination'] = taskDestination;
    data['taskDestinationAddress'] = taskDestinationAddress;
    data['taskJobTypeId'] = taskJobTypeId;
    data['taskRelatedInvoiceId'] = taskRelatedInvoiceId;
    data['taskRelatedInvoiceName'] = taskRelatedInvoiceName;
    data['taskAssignedTo'] = taskAssignedTo;
    data['employeeCode'] = employeeCode;
    data['empFirstName'] = empFirstName;
    data['empLastName'] = empLastName;
    data['taskAssignTime'] = taskAssignTime;
    data['taskStartTime'] = taskStartTime;
    data['taskEndTime'] = taskEndTime;
    data['taskStatus'] = taskStatus;
    data['taskRelatedTaskId'] = taskRelatedTaskId;
    data['jobTypeId'] = jobTypeId;
    data['jobType'] = jobType;
    data['soSystemNo'] = soSystemNo;
    data['taskAssignBy'] = taskAssignBy;
    data['taskChannelId'] = taskChannelId;
    data['taskGroupId'] = taskGroupId;
    data['taskOtpVerified'] = taskOtpVerified;
    if (taskChecklistsData != null) {
      data['taskChecklistsData'] =
          taskChecklistsData!.map((v) => v.toJson()).toList();
    }
    if (taskTransportationData != null) {
      data['taskTransportationData'] =
          taskTransportationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskChecklistsData {
  int? taskChecklistAutoId;
  int? taskChecklistId;
  String? taskChecklistName;
  int? checklistCompletionStatus;
  String? checklistCompletionTime;

  TaskChecklistsData(
      {taskChecklistAutoId,
      taskChecklistId,
      taskChecklistName,
      checklistCompletionStatus,
      checklistCompletionTime});

  TaskChecklistsData.fromJson(Map<String, dynamic> json) {
    taskChecklistAutoId = json['taskChecklistAutoId'];
    taskChecklistId = json['taskChecklistId'];
    taskChecklistName = json['taskChecklistName'];
    checklistCompletionStatus = json['checklistCompletionStatus'];
    checklistCompletionTime = json['checklistCompletionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['taskChecklistAutoId'] = taskChecklistAutoId;
    data['taskChecklistId'] = taskChecklistId;
    data['taskChecklistName'] = taskChecklistName;
    data['checklistCompletionStatus'] = checklistCompletionStatus;
    data['checklistCompletionTime'] = checklistCompletionTime;
    return data;
  }
}

class TaskTransportationData {
  int? taskTransportationAutoId;
  int? vehicleId;
  String? vehicleName;
  int? taskTransportationCost;
  dynamic taskTransportationStartLat;
  dynamic taskTransportationStartLong;
  String? taskTransportationStartLocation;
  dynamic taskTransportationEndLat;
  dynamic taskTransportationEndLong;
  String? taskTransportationEndLocation;
  String? taskTransportationRemarks;
  int? taskTransporationWayStatus;
  String? insertedAt;

  TaskTransportationData(
      {taskTransportationAutoId,
      vehicleId,
      vehicleName,
      taskTransportationCost,
      taskTransportationStartLat,
      taskTransportationStartLong,
      taskTransportationStartLocation,
      taskTransportationEndLat,
      taskTransportationEndLong,
      taskTransportationEndLocation,
      taskTransportationRemarks,
      taskTransporationWayStatus,
      insertedAt});

  TaskTransportationData.fromJson(Map<String, dynamic> json) {
    taskTransportationAutoId = json['taskTransportationAutoId'];
    vehicleId = json['vehicleId'];
    vehicleName = json['vehicleName'];
    taskTransportationCost = json['taskTransportationCost'];
    taskTransportationStartLat = json['taskTransportationStartLat'];
    taskTransportationStartLong = json['taskTransportationStartLong'];
    taskTransportationStartLocation = json['taskTransportationStartLocation'];
    taskTransportationEndLat = json['taskTransportationEndLat'];
    taskTransportationEndLong = json['taskTransportationEndLong'];
    taskTransportationEndLocation = json['taskTransportationEndLocation'];
    taskTransportationRemarks = json['taskTransportationRemarks'];
    taskTransporationWayStatus = json['taskTransporationWayStatus'];
    insertedAt = json['insertedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['taskTransportationAutoId'] = taskTransportationAutoId;
    data['vehicleId'] = vehicleId;
    data['vehicleName'] = vehicleName;
    data['taskTransportationCost'] = taskTransportationCost;
    data['taskTransportationStartLat'] = taskTransportationStartLat;
    data['taskTransportationStartLong'] = taskTransportationStartLong;
    data['taskTransportationStartLocation'] =
        taskTransportationStartLocation;
    data['taskTransportationEndLat'] = taskTransportationEndLat;
    data['taskTransportationEndLong'] = taskTransportationEndLong;
    data['taskTransportationEndLocation'] = taskTransportationEndLocation;
    data['taskTransportationRemarks'] = taskTransportationRemarks;
    data['taskTransporationWayStatus'] = taskTransporationWayStatus;
    data['insertedAt'] = insertedAt;
    return data;
  }
}
