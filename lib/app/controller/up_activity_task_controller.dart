import 'dart:async';
import 'dart:developer';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/model/check_list_model.dart';
import 'package:TradeZentrum/app/model/declear_task_start_model.dart';
import 'package:TradeZentrum/app/model/locations_model.dart';
import 'package:TradeZentrum/app/model/task_details_model.dart';
import 'package:TradeZentrum/app/model/vehicles_model.dart';
import 'package:TradeZentrum/app/repository/task_details_repository.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpActivityTaskController extends GetxController {
  TaskDetailsRepository taskDetailsRepository = TaskDetailsRepository();
  ApiUrl apiUrl = ApiUrl();
  var declareTaskStartData = Data().obs;
  var taskDetailsData = TaskDetailsData().obs;
  RxString taskId = "".obs;
  RxList<LocationDetails> formLocationDetailsList = <LocationDetails>[].obs;
  RxList<LocationDetails> toLocationDetailsList = <LocationDetails>[].obs;
  Rx<LocationDetails> initialFromValue = LocationDetails().obs;
  var selectedLocation = LocationDetails().obs;
  Rx<LocationDetails> initialToValue = LocationDetails().obs;
  RxList<VehicleData> vehiclesList = <VehicleData>[].obs;
  Rx<VehicleData> initialVechile = VehicleData().obs;
  RxList<LocationDetails> filteredFromLocationsList = <LocationDetails>[].obs;
  RxList<LocationDetails> filteredToLocationsList = <LocationDetails>[].obs;
  RxList<VehicleData> filteredVechileList = <VehicleData>[].obs;
  SearchController searchFromController = SearchController();
  SearchController searchToController = SearchController();
  SearchController searchVehicleController = SearchController();
  TextEditingController fareTextEditingController = TextEditingController();
  TextEditingController remarkTextEditingController = TextEditingController();
  RxInt selectedVehicleId = 0.obs;
  RxBool isFinished = false.obs;
  RxList<CheckList> checkListData = <CheckList>[].obs;
  var fareCloseIcon = false.obs;
  var remarkCloseIcon = false.obs;
  var showFareValidate = "".obs;
  var showRemarkValidate = "".obs;
  var showFromValidate = "".obs;
  var showToValidate = "".obs;
  var showVehicleValidate = "".obs;
  var showMobileNumbberFormField = false.obs;
  var mobileNumberTextFormField = TextEditingController();
  var warningCheckList = false.obs;
  RxList<TaskChecklistsData> checkList = <TaskChecklistsData>[].obs;

  @override
  void onInit() {
    super.onInit();
    var data = Get.arguments;
    if (data != null) {
      taskId.value = data;
      getTaskDetails(
        endPoint: apiUrl.getTaskDetails,
        taskId: taskId.value,
      );
    }

    getLocationList(
      endPoint: apiUrl.getLocations,
    );
    getVehiclesList(
      endPoint: apiUrl.getVehiclesList,
    );
  }

  void filterFromLocations(String query) {
    filteredFromLocationsList.value = formLocationDetailsList.where((location) {
      var result = location.locationName!
          .toLowerCase()
          .contains(query.trim().toLowerCase());
      return result;
    }).toList();
    log("${filteredFromLocationsList.length} and ${formLocationDetailsList.length}");
  }

  void filterToLocations(String query) {
    filteredToLocationsList.value = toLocationDetailsList
        .where((location) =>
            location.locationName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    log("${filteredToLocationsList.length} and ${toLocationDetailsList.length}");
  }

  void filterVehicles(String query) {
    filteredVechileList.value = vehiclesList
        .where((vehicle) =>
            vehicle.value!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    log("${filteredVechileList.length} and ${vehiclesList.length}");
  }

  declearTaskStart({String? endPoint, String? taskId}) async {
    startLoading();
    Map<String, dynamic> response =
        await taskDetailsRepository.declareTaskStart(
      endPoint: "${endPoint!}$taskId",
    );
    declareTaskStartData.value = Data.fromJson(response);
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId,
    );
    endLoading();
  }

  getTaskDetails({String? endPoint, String? taskId}) async {
    startLoading();

    var response = await taskDetailsRepository.getTaskDetails(
      endPoint: "${endPoint!}$taskId",
    );
    List<TaskTransportationData>? upActivityTaskList = [];
    for (int i = 0;
        i <
            response['data']
                .data['dataObj']['data']['taskTransportationData']
                .length;
        i++) {
      if (response['data'].data['dataObj']['data']['taskTransportationData'][i]
                  ['taskTransporationWayStatus'] !=
              null &&
          response['data'].data['dataObj']['data']['taskTransportationData'][i]
                  ['taskTransporationWayStatus'] ==
              0) {
        upActivityTaskList.add(TaskTransportationData.fromJson(response['data']
            .data['dataObj']['data']['taskTransportationData'][i]));
      }
    }
    taskDetailsData.value =
        TaskDetailsData.fromJson(response['data'].data['dataObj']['data']);
    taskDetailsData.value.taskTransportationData = upActivityTaskList;
    showReturnButton.value =
        taskDetailsData.value.taskStatus == 2 ? true : false;
    checkList.value = taskDetailsData.value.taskChecklistsData ?? [];
    verifyOtpStatus.value =
        taskDetailsData.value.taskOtpVerified == 1 ? true : false;
    convertStatusInController();
    endLoading();
  }

  getLocationList({String? endPoint}) async {
    startLoading();
    formLocationDetailsList.clear();
    var response = await taskDetailsRepository.getLocations(
      endPoint: endPoint!,
    );
    LocationsModel data = LocationsModel.fromJson(response['data'].data);
    formLocationDetailsList.value = data.dataObj ?? [];
    initialFromValue.value = formLocationDetailsList[0];
    toLocationDetailsList.value = data.dataObj ?? [];
    initialToValue.value = toLocationDetailsList[0];
    endLoading();
  }

  void updateToLocations() {
    // var newData =
    //     locations.where((location) => location != initialFromValue.value);
    // toLocationDetailsList.value = newData.toList();
  }

  void updateFromLocations() {
    // var newData =
    //     locations.where((location) => location != initialToValue.value);
    // formLocationDetailsList.value = newData.toList();
  }

  getVehiclesList({String? endPoint}) async {
    startLoading();
    var response = await taskDetailsRepository.getLocations(
      endPoint: endPoint!,
    );
    VehiclesModel vehiclesModel = VehiclesModel.fromJson(response['data'].data);
    vehiclesList.value = vehiclesModel.dataObj?.data ?? [];
    initialVechile.value = vehiclesList[0];
    endLoading();
  }

  addTransport() async {
    startLoading();
    var authController = Get.put(AuthController());
    Map<String, dynamic> request = {
      "taskId": taskId.value,
      "taskTransportationCost": fareTextEditingController.text,
      "taskTransportationEndLat": authController.latitude.value,
      "taskTransportationEndLocation": searchToController.text,
      "taskTransportationEndLong": authController.longitude.value,
      "taskTransportationRemarks": remarkTextEditingController.text,
      "taskTransportationStartLat": authController.latitude.value,
      "taskTransportationStartLocation": searchFromController.text,
      "taskTransportationStartLong": authController.longitude.value,
      "taskTransportationVehicleId": selectedVehicleId.value,
      "taskTransporationWayStatus": 0
    };
    log("Checkiing: $request");
    var response = await taskDetailsRepository.addTransport(
        endpoint: apiUrl.addTransportation + taskId.value, data: request);
    log("Response:  ${response["data"]}");
    fareTextEditingController.clear();
    searchToController.clear();
    searchFromController.clear();
    remarkTextEditingController.clear();
    searchVehicleController.clear();
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId.value,
    );
    endLoading();
  }

  deleteTransport(
      {String? endPoint,
      String? taskTransportationAutoId,
      String? taskId}) async {
    startLoading();
    var response = await taskDetailsRepository.deleteTransport(
        endpoint: "$endPoint$taskTransportationAutoId/$taskId");
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId,
    );
    endLoading();
  }

  reachedTransport({
    String? endPoint,
    String? taskId,
    String? taskTransportationAutoId,
    String? taskTransportationEndLocation,
  }) async {
    startLoading();
    var authController = Get.put(AuthController());
    Map<String, dynamic> request = {
      "taskId": taskId,
      "taskTransportationAutoId": taskTransportationAutoId,
      "taskTransportationCost": fareTextEditingController.text,
      "taskTransportationEndLat": authController.latitude.value,
      "taskTransportationEndLocation": taskTransportationEndLocation,
      "taskTransportationEndLong": authController.longitude.value,
    };
    log("5555: $taskTransportationEndLocation");
    var response = await taskDetailsRepository.reachedTransport(
        endpoint: "$endPoint$taskId", data: request);
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId,
    );
    endLoading();
  }

  editTransport({String? endPoint, Map<String, dynamic>? data}) async {
    startLoading();
    // log("Here: $data");
    var response = await taskDetailsRepository.updateTransport(
        endpoint: "$endPoint${taskId.value}", data: data);
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId.value,
    );
    endLoading();
  }

  declearCheckListCompletion({String? endPoint, String? title}) async {
    startLoading();
    var response = await taskDetailsRepository.declearCheckListCompletion(
      endpoint: endPoint,
    );
    var autoId =
        response['data'].data["dataObj"]["data"]["taskChecklistAutoId"];
    getTaskDetails(
      endPoint: apiUrl.getTaskDetails,
      taskId: taskId.value,
    );
    await Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      convertStatusInController();
    });
    endLoading();
  }

  convertStatusInController() {
    if (checkList.isNotEmpty) {
      checkListData.clear();
      for (int i = 0; i < checkList.length; i++) {
        if (checkList[i].checklistCompletionStatus == 0) {
          checkListData.add(
            CheckList(title: checkList[i].taskChecklistName, statusLsit: [
              StatusLsit(
                  title: "Pending",
                  id: checkList[i].taskChecklistAutoId.toString()),
              StatusLsit(
                  title: "Complete",
                  id: checkList[i].taskChecklistAutoId.toString()),
            ]),
          );
        } else if (checkList[i].checklistCompletionStatus == 1) {
          checkListData.add(
            CheckList(title: checkList[i].taskChecklistName, statusLsit: [
              StatusLsit(
                  title: "Completed",
                  id: checkList[i].taskChecklistAutoId.toString())
            ]),
          );
        }
      }
    }
  }

  var showPhoneNumberError = "".obs;
  var mobileOtpStatus = false.obs;
  var verifyOtpStatus = false.obs;
  var showVerifyOtpError = "".obs;

  var otpTimeDuration = 120.obs;
  RxString timeLeft = ''.obs;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (otpTimeDuration.value == 0) {
        mobileOtpStatus.value = false;
        otpTimeDuration.value = 120;
        timer.cancel();
        return;
      }

      otpTimeDuration.value--;
      updateTimeLeft();
    });
  }

  void updateTimeLeft() {
    String minutes = (otpTimeDuration.value ~/ 60).toString().padLeft(2, '0');
    String seconds = (otpTimeDuration.value % 60).toString().padLeft(2, '0');
    timeLeft.value = '$minutes:$seconds';
  }

  getOtp({String? endPoint, String? number}) async {
    startLoading();
    var authController = Get.put(AuthController());
    Map<String, dynamic> request = {
      "taskId": taskId.value,
      "deliveryReceiverContactNo": number,
      "otpFromLat" : authController.latitude.value,
      "otpFromLong" : authController.longitude.value,
    };

    Map<String, dynamic> response =
        await taskDetailsRepository.getOtp(endPoint: endPoint, data: request);
    log("$response");
    if (response['status'] == true) {
      mobileOtpStatus.value = true;
      startTimer();
    } else {
      mobileOtpStatus.value = false;
      showPhoneNumberError.value = response['data'];
    }

    endLoading();
  }

  var otpValue = "".obs;

  verifyOtp({String? endPoint, String? otp}) async {
    startLoading();

    var response = await taskDetailsRepository.verifyOtp(
        endPoint: "$endPoint?otp=$otp&taskId=${taskId.value}");
    if (response['status'] == true) {
      verifyOtpStatus.value = true;
      otpTimeDuration.value = 0;
      Get.back();
    } else {
      verifyOtpStatus.value = false;
      showVerifyOtpError.value = response['data'];
    }
    endLoading();
  }

  // RegExp regExp = RegExp(r'/^(01){1}[3456789]{1}\d{8}/');
  // validatePhoneNumber(String value) {}

  var showReturnButton = false.obs;
  var taskReturned = false.obs;

  TextEditingController instructedNameTextEditingController =
      TextEditingController();
  TextEditingController instructedReasonTextEditingController =
      TextEditingController();
  Future<Map<String, dynamic>> returnTask(
      {String? endPoint, var taskIdForReturn}) async {
    startLoading();
    var response = await taskDetailsRepository.returnTask(
        endPoint: "$endPoint/$taskIdForReturn/return");
    if (response['status'] == true) {
      taskReturned.value = true;

      Get.back();
      endLoading();
      return {"status": true, "data": response['data']};
    } else {
      taskReturned.value = false;
      showReturnButton.value = false;

      Get.back();
      endLoading();
      return {"status": false, "data": response['data']};
    }
  }

  void updateIsFinished() {
    isFinished.value = !isFinished.value;
    print(".............${isFinished.value}");
  }
}
