
import 'dart:async';
import 'dart:developer';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/model/check_list_model.dart';
import 'package:TradeZentrum/app/model/declear_task_start_model.dart';
import 'package:TradeZentrum/app/model/locations_model.dart';
import 'package:TradeZentrum/app/model/task_details_model.dart';
import 'package:TradeZentrum/app/model/vehicles_model.dart';
import 'package:TradeZentrum/app/repository/task_details_repository.dart';
import 'package:TradeZentrum/app/screens/home/home_page.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DownActivityTaskController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    var data = Get.arguments;
    log("data: $data");
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
    AuthController authController = Get.find<AuthController>();
    Position? position = await authController.myLocation();

    Map<String, dynamic> response =
        await taskDetailsRepository.declareTaskStart(
      endPoint: position != null? "${endPoint!}$taskId/?startLat=${position.latitude}&startLong=${position.longitude}" : "${endPoint!}$taskId",
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
              1) {
        upActivityTaskList.add(TaskTransportationData.fromJson(response['data']
            .data['dataObj']['data']['taskTransportationData'][i]));
      }
    }
    taskDetailsData.value =
        TaskDetailsData.fromJson(response['data'].data['dataObj']['data']);
    taskDetailsData.value.taskTransportationData = upActivityTaskList;
    log("222: ${taskDetailsData.value.taskTransportationData}");
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
      "taskTransporationWayStatus": 1,
    };
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
        log("0000: $response");
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
    convertStatusInController(taskDetailsData.value.taskChecklistsData);

    endLoading();
  }

  convertStatusInController(List<TaskChecklistsData>? checkList) {
    checkListData.clear();
    for (int i = 0; i < checkList!.length; i++) {
      if (checkList[i].checklistCompletionStatus == 0) {
        checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusList(
                title: "Pending",
                id: checkList[i].taskChecklistAutoId.toString()),
            StatusList(
                title: "Complete",
                id: checkList[i].taskChecklistAutoId.toString()),
            StatusList(
                title: "Return",
                id: checkList[i].taskChecklistAutoId.toString())
          ]),
        );
      } else if (checkList[i].checklistCompletionStatus == 1) {
        checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusList(
                title: "Completed",
                id: checkList[i].taskChecklistAutoId.toString())
          ]),
        );
      }
    }
  }

  var showPhoneNumberError = "".obs;
  var mobileOtpStatus = false.obs;
  var verifyOtpStatus = false.obs;
  var showVerifyOtpError = "".obs;
  getOtp({String? endPoint, String? number}) async {
    startLoading();
    Map<String, dynamic> request = {
      "taskId": taskId.value,
      "deliveryReceiverContactNo": number
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

  // OtpFieldController otpFieldController = OtpFieldController();
  var otpValue = "".obs;

  verifyOtp({String? endPoint, String? otp}) async {
    startLoading();

    var response = await taskDetailsRepository.verifyOtp(
        endPoint: "$endPoint?otp=$otp&taskId=${taskId.value}");
    log("OTP::: ${response}");
    if (response['status'] == true) {
      verifyOtpStatus.value = true;
      Get.back();
    } else {
      verifyOtpStatus.value = false;
      showVerifyOtpError.value = response['data'];
    }
    endLoading();
  }

  validatePhoneNumber(String value) {
    if (value.isEmpty) {
      showPhoneNumberError.value = 'Phone number is required';
    } else {
      showPhoneNumberError.value = "";
    }
  }

  var secondsLeft = 120.obs;
  RxString timeLeft = ''.obs;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
        return;
      }

      secondsLeft.value--;
      updateTimeLeft();
    });
  }

  void updateTimeLeft() {
    String minutes = (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    String seconds = (secondsLeft.value % 60).toString().padLeft(2, '0');
    timeLeft.value = '$minutes:$seconds';
  }

  var showReturnButton = false.obs;
  var taskReturned = false.obs;
  var showReturnStatus = "".obs;
  TextEditingController instructedNameTextEditingController =
      TextEditingController();
  TextEditingController instructedReasonTextEditingController =
      TextEditingController();
  void returnTask({String? endPoint, var taskIdForReturn}) async {
    startLoading();
    var response = await taskDetailsRepository.returnTask(
        endPoint: "$endPoint/$taskIdForReturn/return");
    if (response['status'] == true) {
      taskReturned.value = true;
      showReturnStatus.value = response['data'];
      Get.back();
    } else {
      taskReturned.value = false;
      showReturnButton.value = false;
      showReturnStatus.value = response['data'];
    }
    endLoading();
  }

  Future<Map<String,dynamic>>? taskAccomplish({String? endPoint,String? taskId}) async{
    startLoading();
      var response = await taskDetailsRepository.taskAccomplish(
        endPoint: "$endPoint$taskId");
        log("dasdasdasdasdasafdsa: ${response['data']}");
         if (response['status'] == true) {
          endLoading();
      Get.back();
      return {
        "status": true,
        "data": response['data'].data['message'],
      };
    } else {
      endLoading();
      return {
        "status": true,
        "data": response['data'],
      };
    }
  }
}
