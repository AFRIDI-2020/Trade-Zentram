import 'dart:developer';

import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/controller/down_Activity_controller.dart';
import 'package:TradeZentrum/app/model/locations_model.dart';
import 'package:TradeZentrum/app/model/vehicles_model.dart';
import 'package:TradeZentrum/app/screens/connectivity/internet_connectivity.dart';
import 'package:TradeZentrum/app/screens/home/home_page.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/widgets/task_detail_widget.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/widgets/transport_list_item.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../controller/up_activity_task_controller.dart';
import '../model/check_list_model.dart';

class DownActivityTaskPage extends GetView<DownActivityTaskController> {
  final String pageTitle;

  const DownActivityTaskPage({
    super.key,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    final theme = Theme.of(context);
    final taskDetailsController = Get.put(DownActivityTaskController());
    final upActivityTaskDetailsController = Get.put(UpActivityTaskController());
    final GlobalKey<SlideActionState> key = GlobalKey();
    final formKey1 = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        AuthController authController = AuthController();
        if (didPop) {
          return;
        }
        taskDetailsController.searchFromController.clear();
        taskDetailsController.searchToController.clear();
        taskDetailsController.searchVehicleController.clear();
        taskDetailsController.fareTextEditingController.clear();
        taskDetailsController.remarkTextEditingController.clear();
        taskDetailsController.fareCloseIcon.value = false;
        taskDetailsController.remarkCloseIcon.value = false;
        if (!await authController.checkLocationStatus()) {
          authController.logout();
        } else {
          Get.back();
        }
      },
      child: InternetConnectivity(
        child: Scaffold(
            backgroundColor: ColorConstant.primaryBackground,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: CustomAppBar(
                toPage: "UpActivityTaskPage",
                pageTitle: pageTitle,
              ),
            ),
            body: Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TaskDetailWidget(
                      taskDetailsData: taskDetailsController.taskDetailsData.value,
                      onPlayPauseButtonTap: () {
                        taskDetailsController.taskDetailsData.value.taskStartTime == null &&
                                taskDetailsController.taskDetailsData.value.taskEndTime == null
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                    content: const SizedBox(
                                      height: 180,
                                      child: Column(
                                        children: [
                                          Icon(Icons.not_listed_location,
                                              size: 80, color: Color(0xFFC62828)
                                              // Color(0xFF9c27b0),
                                              ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            "WANNA START?",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Are you sure that you want to start Task - Task # 3647?",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(0.0),
                                                  ),
                                                ),
                                                backgroundColor: const MaterialStatePropertyAll(
                                                    Color(0xFF9c27b0))),
                                            child: const Text(
                                              "NO",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              taskDetailsController.declearTaskStart(
                                                endPoint: ApiUrl().declearTaskStart,
                                                taskId: taskDetailsController.taskId.value,
                                              );
                                              Get.back();
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(0.0),
                                                  ),
                                                ),
                                                backgroundColor: const MaterialStatePropertyAll(
                                                    Color(0xFFC62828))),
                                            child: const Text(
                                              "YES",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                },
                              )
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _isReturnOptionVisible(upActivityTaskDetailsController)
                        ? SizedBox(
                            height: 60,
                            child: Obx(
                              () => !upActivityTaskDetailsController.taskReturned.value
                                  ? SlideAction(
                                      key: key,
                                      height: 42,
                                      text: "Slide to Return",
                                      textStyle: theme.textTheme.titleMedium
                                          ?.copyWith(color: ColorConstant.secondaryThemeColor),
                                      outerColor: ColorConstant().baseColor,
                                      innerColor: ColorConstant.secondaryThemeColor,
                                      sliderButtonIcon: const Icon(Icons.arrow_forward),
                                      sliderButtonIconSize: 24,
                                      sliderButtonIconPadding: 4,
                                      animationDuration: const Duration(milliseconds: 500),
                                      onSubmit: () async {
                                        if (!await AuthController().checkLocationStatus()) {
                                          AuthController().logout();
                                        } else {
                                          if (context.mounted) {
                                            if (upActivityTaskDetailsController
                                                        .taskDetailsData.value.taskStartTime ==
                                                    null &&
                                                upActivityTaskDetailsController
                                                        .taskDetailsData.value.taskEndTime ==
                                                    null) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 20),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(8))),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.play_circle_outline, size: 80,
                                                          // Color(0xFF9c27b0),
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          "Task isn't start yes!",
                                                          style: theme.textTheme.titleLarge,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Start your task first before going to checklist.",
                                                          style: theme.textTheme.bodySmall,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                              "Ok",
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (upActivityTaskDetailsController.taskDetailsData.value
                                                .taskTransportationData!.isEmpty) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(8))),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          "assets/ic_empty_transport.png",
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text("Empty Transport",
                                                            style: theme.textTheme.titleLarge),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          "You have not added any transport yet",
                                                          style: theme.textTheme.bodyMedium,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            "Okay",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (upActivityTaskDetailsController
                                                        .taskDetailsData
                                                        .value
                                                        .taskTransportationData![
                                            upActivityTaskDetailsController
                                                                    .taskDetailsData
                                                                    .value
                                                                    .taskTransportationData!
                                                                    .length -
                                                                1]
                                                        .taskTransportationEndLat ==
                                                    null &&
                                                upActivityTaskDetailsController
                                                        .taskDetailsData
                                                        .value
                                                        .taskTransportationData![
                                                upActivityTaskDetailsController
                                                                    .taskDetailsData
                                                                    .value
                                                                    .taskTransportationData!
                                                                    .length -
                                                                1]
                                                        .taskTransportationEndLat ==
                                                    null) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(8.0))),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.location_off,
                                                          size: 60,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text("Missed End Location",
                                                            style: theme.textTheme.titleLarge),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          "You have not clicked the reach button",
                                                          style: theme.textTheme.bodyMedium,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                          "Ok",
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (_requiredVerifyMobileNumber()) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(8))),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 15),
                                                          child: Image.asset(
                                                            "assets/ic_verify_mobile.png",
                                                            height: 60,
                                                            width: 60,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Verify mobile number!!",
                                                          style: theme.textTheme.titleLarge,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        Text(
                                                          "You haven't verify mobile number yet",
                                                          style: theme.textTheme.bodyMedium,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            "Okay",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  upActivityTaskDetailsController
                                                      .instructedNameTextEditingController
                                                      .clear();
                                                  upActivityTaskDetailsController
                                                      .instructedReasonTextEditingController
                                                      .clear();
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(8))),
                                                    content: Form(
                                                      key: formKey1,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/ic_return_product.png",
                                                            height: 80,
                                                            width: 80,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text("Return Product",
                                                              style: theme.textTheme.titleLarge),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            "Who instructed to return product?",
                                                            style: theme.textTheme.bodyMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            readOnly: false,
                                                            onTap: () {},
                                                            controller: upActivityTaskDetailsController
                                                                .instructedNameTextEditingController,
                                                            decoration: const InputDecoration(
                                                              labelText: "Name",
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.symmetric(
                                                                  vertical: 8, horizontal: 8),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(4)),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(4)),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(4)),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return "Enter the instructor name";
                                                              }

                                                              return null;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (formKey1.currentState!.validate()) {
                                                            Get.back();
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  backgroundColor: Colors.white,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                                  Radius.circular(
                                                                                      8))),
                                                                  content: Form(
                                                                    key: formKey2,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize.min,
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/ic_return_product.png",
                                                                          height: 80,
                                                                          width: 80,
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 4,
                                                                        ),
                                                                        Text("Return Product",
                                                                            style: theme.textTheme
                                                                                .titleLarge),
                                                                        const SizedBox(
                                                                          height: 16,
                                                                        ),
                                                                        Text(
                                                                          "Reason of returning",
                                                                          style: theme
                                                                              .textTheme.bodyMedium,
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                          upActivityTaskDetailsController
                                                                                  .instructedReasonTextEditingController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText: "Reason",
                                                                            isDense: true,
                                                                            contentPadding:
                                                                                EdgeInsets
                                                                                    .symmetric(
                                                                                        horizontal:
                                                                                            8,
                                                                                        vertical:
                                                                                            8),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius
                                                                                          .circular(
                                                                                              4)),
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius
                                                                                          .circular(
                                                                                              4)),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius
                                                                                          .circular(
                                                                                              4)),
                                                                            ),
                                                                          ),
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Write the reason of returning product";
                                                                            }

                                                                            return null;
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        if (formKey2.currentState!
                                                                            .validate()) {
                                                                          Map<String, dynamic>?
                                                                              response =
                                                                              await upActivityTaskDetailsController.returnTask(
                                                                                  endPoint: ApiUrl()
                                                                                      .returnTask,
                                                                                  taskIdForReturn:
                                                                                  upActivityTaskDetailsController
                                                                                          .taskDetailsData
                                                                                          .value
                                                                                          .taskId
                                                                                          .toString());
                                                                          // await taskDetailsController
                                                                          //     .getTaskDetails(
                                                                          //   endPoint: ApiUrl().getTaskDetails,
                                                                          //   taskId: taskDetailsController
                                                                          //       .taskDetailsData.value.taskId
                                                                          //       .toString(),
                                                                          // );

                                                                          if (response != {}) {
                                                                            showDialog(
                                                                              context: context,
                                                                              barrierDismissible:
                                                                                  false,
                                                                              builder: (context) {
                                                                                return PopScope(
                                                                                  canPop: false,
                                                                                  child:
                                                                                      AlertDialog(
                                                                                    shape:
                                                                                        const RoundedRectangleBorder(
                                                                                      borderRadius:
                                                                                          BorderRadius
                                                                                              .all(
                                                                                        Radius
                                                                                            .circular(
                                                                                                8),
                                                                                      ),
                                                                                    ),
                                                                                    title: Icon(
                                                                                      response['status'] ==
                                                                                              true
                                                                                          ? Icons
                                                                                              .check_circle_outline
                                                                                          : Icons
                                                                                              .error_outline_outlined,
                                                                                      color: response[
                                                                                                  'status'] ==
                                                                                              true
                                                                                          ? Colors
                                                                                              .green
                                                                                          : Colors
                                                                                              .black,
                                                                                      size: 44,
                                                                                    ),
                                                                                    content: Column(
                                                                                      mainAxisSize:
                                                                                          MainAxisSize
                                                                                              .min,
                                                                                      children: [
                                                                                        Text(
                                                                                          response['status'] ==
                                                                                                  true
                                                                                              ? "Product Successfully returned."
                                                                                              : "Product return failed. Try again later.",
                                                                                          style: const TextStyle(
                                                                                              color: Colors
                                                                                                  .black,
                                                                                              fontWeight: FontWeight
                                                                                                  .bold,
                                                                                              fontSize:
                                                                                                  16),
                                                                                          textAlign:
                                                                                              TextAlign
                                                                                                  .center,
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          onPressed:
                                                                                              () {
                                                                                            if (response['status'] ==
                                                                                                true) {
                                                                                              Get.offAll(() =>
                                                                                                  const HomePage());
                                                                                            } else {
                                                                                              Get.back();
                                                                                            }
                                                                                          },
                                                                                          child: const Text(
                                                                                              "OK"),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                        "Confirm",
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Next",
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        }
                                      },
                                    )
                                  : const Text(
                                      "Returned",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Down Activity",
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            taskDetailsController.taskDetailsData.value.taskEndTime == null &&
                                    taskDetailsController.taskDetailsData.value.taskStartTime ==
                                        null
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                        content: const SizedBox(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                size: 80,
                                                color: Color(0xFFed6c02),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                "TASK NOT STARTED",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "You must have to click the start button and then you can click ADD TRANSPORT!",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(0.0),
                                                  ),
                                                ),
                                                backgroundColor: const MaterialStatePropertyAll(
                                                    Color(0xFFed6c02))),
                                            child: const Text(
                                              "Ok",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  )
                                : taskDetailsController
                                        .taskDetailsData.value.taskTransportationData!.isEmpty
                                    ? showModal(context, taskDetailsController, false)
                                    : taskDetailsController
                                                    .taskDetailsData
                                                    .value
                                                    .taskTransportationData![taskDetailsController
                                                            .taskDetailsData
                                                            .value
                                                            .taskTransportationData!
                                                            .length -
                                                        1]
                                                    .taskTransportationEndLat !=
                                                null &&
                                            taskDetailsController
                                                    .taskDetailsData
                                                    .value
                                                    .taskTransportationData![taskDetailsController
                                                            .taskDetailsData
                                                            .value
                                                            .taskTransportationData!
                                                            .length -
                                                        1]
                                                    .taskTransportationEndLat !=
                                                null
                                        ? showModal(context, taskDetailsController, false)
                                        : showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(0.0))),
                                                content: const SizedBox(
                                                  height: 180,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.error_outline,
                                                        size: 80,
                                                        color: Color(0xFFed6c02),
                                                      ),
                                                      SizedBox(
                                                        height: 16,
                                                      ),
                                                      Text(
                                                        "MISSED END LOCATION",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text(
                                                        "You have not clicked the reach button above!!",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(0.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color(0xFFed6c02))),
                                                    child: const Text(
                                                      "Ok",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/ic_add_transport.png",
                                height: 20,
                                width: 20,
                                color: ColorConstant.secondaryThemeColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "ADD",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    taskDetailsController.taskDetailsData.value.taskTransportationData != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: taskDetailsController
                                .taskDetailsData.value.taskTransportationData?.length,
                            itemBuilder: (context, index) {
                              /*  return Card(
                          elevation: 0,
                          color: taskDetailsController
                              .taskDetailsData
                              .value
                              .taskTransportationData![index]
                              .taskTransportationEndLat !=
                              null &&
                              taskDetailsController
                                  .taskDetailsData
                                  .value
                                  .taskTransportationData![index]
                                  .taskTransportationEndLong !=
                                  null
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.transparent,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'From: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![index]
                                          .taskTransportationEndLat ==
                                          null &&
                                          taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLong ==
                                              null
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                        "${taskDetailsController.taskDetailsData.value.taskTransportationData![index].taskTransportationStartLocation}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLat ==
                                              null &&
                                              taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationEndLong ==
                                                  null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'To: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![index]
                                          .taskTransportationEndLat ==
                                          null &&
                                          taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLong ==
                                              null
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                        "${taskDetailsController.taskDetailsData.value.taskTransportationData![index].taskTransportationEndLocation}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLat ==
                                              null &&
                                              taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationEndLong ==
                                                  null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Cost: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![index]
                                          .taskTransportationEndLat ==
                                          null &&
                                          taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLong ==
                                              null
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                        "${taskDetailsController.taskDetailsData.value.taskTransportationData![index].taskTransportationCost}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLat ==
                                              null &&
                                              taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationEndLong ==
                                                  null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Remarks: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![index]
                                          .taskTransportationEndLat ==
                                          null &&
                                          taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLong ==
                                              null
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                        "${taskDetailsController.taskDetailsData.value.taskTransportationData![index].taskTransportationRemarks}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: taskDetailsController
                                              .taskDetailsData
                                              .value
                                              .taskTransportationData![index]
                                              .taskTransportationEndLat ==
                                              null &&
                                              taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationEndLong ==
                                                  null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              enabled: taskDetailsController
                                  .taskDetailsData
                                  .value
                                  .taskTransportationData![index]
                                  .taskTransportationEndLat ==
                                  null &&
                                  taskDetailsController
                                      .taskDetailsData
                                      .value
                                      .taskTransportationData![index]
                                      .taskTransportationEndLong ==
                                      null
                                  ? true
                                  : false,
                              icon: Icon(
                                Icons.settings,
                                color: taskDetailsController
                                    .taskDetailsData
                                    .value
                                    .taskTransportationData![index]
                                    .taskTransportationEndLat ==
                                    null &&
                                    taskDetailsController
                                        .taskDetailsData
                                        .value
                                        .taskTransportationData![index]
                                        .taskTransportationEndLong ==
                                        null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Edit'),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'reached',
                                  child: ListTile(
                                    leading: Icon(Icons.location_on),
                                    title: Text('Reached'),
                                  ),
                                ),
                              ],
                              onSelected: (String value) async {
                                switch (value) {
                                  case 'edit':
                                    if (!await AuthController()
                                        .handleLocationPermission()) {
                                      AuthController().logout();
                                    } else {
                                      if (context.mounted) {
                                        showModal(context, taskDetailsController, true,
                                            from: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationStartLocation,
                                            to: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationEndLocation,
                                            vehicle: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .vehicleName,
                                            vehicleId: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .vehicleId
                                                .toString(),
                                            autoId: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationAutoId
                                                .toString(),
                                            fare: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationCost
                                                .toString(),
                                            remark: taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationRemarks);
                                      }
                                    }
                                    break;
                                  case 'delete':
                                    if (!await AuthController()
                                        .handleLocationPermission()) {
                                      AuthController().logout();
                                    } else {
                                      if (context.mounted) {
                                        taskDetailsController.deleteTransport(
                                            endPoint: ApiUrl().deleteTransportation,
                                            taskTransportationAutoId:
                                            taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![index]
                                                .taskTransportationAutoId
                                                .toString(),
                                            taskId: taskDetailsController.taskId.value);
                                      }
                                    }

                                    break;
                                  case 'reached':
                                    if (!await AuthController()
                                        .handleLocationPermission()) {
                                      AuthController().logout();
                                    } else {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0.0))),
                                              content: const SizedBox(
                                                height: 180,
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.not_listed_location,
                                                        size: 80, color: Color(0xFFC62828)
                                                      // Color(0xFF9c27b0),
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      "Are you sure that you have reached?",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Text(
                                                      "Once it is updated, you can't change!",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      style: ButtonStyle(
                                                          shape:
                                                          MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  0.0),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                              Color(0xFF9c27b0))),
                                                      child: const Text(
                                                        "NO",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        taskDetailsController.reachedTransport(
                                                            endPoint:
                                                            ApiUrl().reachLocation,
                                                            taskId: taskDetailsController
                                                                .taskId.value,
                                                            taskTransportationAutoId:
                                                            taskDetailsController
                                                                .taskDetailsData
                                                                .value
                                                                .taskTransportationData![
                                                            index]
                                                                .taskTransportationAutoId
                                                                .toString(),
                                                            taskTransportationEndLocation:
                                                            taskDetailsController
                                                                .taskDetailsData
                                                                .value
                                                                .taskTransportationData![
                                                            index]
                                                                .taskTransportationEndLocation);
                                                        Get.back();
                                                      },
                                                      style: ButtonStyle(
                                                          shape:
                                                          MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  0.0),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                              Color(0xFFC62828))),
                                                      child: const Text(
                                                        "YES",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }

                                    break;
                                }
                              },
                            ),
                          ),
                        );*/
                              return TransportListItem(
                                onSelected: (String value) async {
                                  switch (value) {
                                    case 'Edit':
                                      if (!await AuthController().checkLocationStatus()) {
                                        AuthController().logout();
                                      } else {
                                        if (context.mounted) {
                                          showModal(context, taskDetailsController, true,
                                              from: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationStartLocation,
                                              to: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationEndLocation,
                                              vehicle: taskDetailsController.taskDetailsData.value
                                                  .taskTransportationData![index].vehicleName,
                                              vehicleId: taskDetailsController.taskDetailsData.value
                                                  .taskTransportationData![index].vehicleId
                                                  .toString(),
                                              autoId: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationAutoId
                                                  .toString(),
                                              fare: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationCost
                                                  .toString(),
                                              remark: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationRemarks);
                                        }
                                      }
                                      break;
                                    case 'Delete':
                                      if (!await AuthController().checkLocationStatus()) {
                                        AuthController().logout();
                                      } else {
                                        if (context.mounted) {
                                          taskDetailsController.deleteTransport(
                                              endPoint: ApiUrl().deleteTransportation,
                                              taskTransportationAutoId: taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData![index]
                                                  .taskTransportationAutoId
                                                  .toString(),
                                              taskId: taskDetailsController.taskId.value);
                                        }
                                      }

                                      break;
                                    case 'Reached':
                                      if (!await AuthController().checkLocationStatus()) {
                                        AuthController().logout();
                                      } else {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(8))),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.not_listed_location,
                                                      size: 60,
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "Are you sure that you have reached?",
                                                      style: theme.textTheme.titleLarge,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      "Once it is updated, you can't change!",
                                                      style: theme.textTheme.bodyMedium,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors.red.shade900)),
                                                        child: const Text(
                                                          "NO",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          taskDetailsController.reachedTransport(
                                                              endPoint: ApiUrl().reachLocation,
                                                              taskId: taskDetailsController
                                                                  .taskId.value,
                                                              taskTransportationAutoId:
                                                                  taskDetailsController
                                                                      .taskDetailsData
                                                                      .value
                                                                      .taskTransportationData![
                                                                          index]
                                                                      .taskTransportationAutoId
                                                                      .toString(),
                                                              taskTransportationEndLocation:
                                                                  taskDetailsController
                                                                      .taskDetailsData
                                                                      .value
                                                                      .taskTransportationData![
                                                                          index]
                                                                      .taskTransportationEndLocation);
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                          "YES",
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }

                                      break;
                                  }
                                },
                                taskTransportationData: taskDetailsController
                                    .taskDetailsData.value.taskTransportationData![index],
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 30,
                    ),
                    const Spacer(),
                    /*Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ]),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              AuthController authController = AuthController();
                              if (!await AuthController().handleLocationPermission()) {
                                authController.logout();
                              } else {
                                if (context.mounted) {
                                  if (taskDetailsController.taskDetailsData.value.taskStartTime ==
                                          null &&
                                      taskDetailsController.taskDetailsData.value.taskEndTime ==
                                          null) {
                                    popUpStatus(
                                      context,
                                      leadingIcon: Icons.error_outline,
                                      title: "Task isn't start yes!",
                                      subtitle: "Start your task first before going to checklist.",
                                      firstActionButtonTitle: "OK",
                                      firstActionButtonColor: const Color(0xFFed6c02),
                                    );
                                  } else if (taskDetailsController
                                      .taskDetailsData.value.taskTransportationData!.isEmpty) {
                                    popUpStatus(context,
                                        leadingIcon: Icons.not_listed_location,
                                        title: "Are you sure",
                                        subtitle: "This will end your task",
                                        twoButton: true,
                                        firstActionButtonTitle: "No",
                                        firstActionButtonColor: const Color(0xFFed6c02),
                                        secondActionButtonTitle: "Yes",
                                        secondActionButtonOnTap: () async {
                                      Map<String, dynamic>? response =
                                          await taskDetailsController.taskAccomplish(
                                              endPoint: ApiUrl().taskAccomplish,
                                              taskId: taskDetailsController
                                                  .taskDetailsData.value.taskId
                                                  .toString());

                                      if (response != {}) {
                                        popUpStatus(context,
                                            barrierDismissible: false,
                                            twoButton: false,
                                            leadingIcon: Icons.check_circle_outline,
                                            leadingIconColor: Colors.green,
                                            title: "${response!['data']}",
                                            subtitle: "Your task is complete",
                                            firstActionButtonTitle: "Goto Home Page",
                                            firstActionButtonOnTap: () {
                                          log("PRESSED");
                                          Get.offAll(() => const HomePage());
                                        });
                                      }
                                    });
                                  } else if (taskDetailsController
                                      .taskDetailsData.value.taskTransportationData!.isNotEmpty) {
                                    if (taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![taskDetailsController
                                                        .taskDetailsData
                                                        .value
                                                        .taskTransportationData!
                                                        .length -
                                                    1]
                                                .taskTransportationEndLat ==
                                            null &&
                                        taskDetailsController
                                                .taskDetailsData
                                                .value
                                                .taskTransportationData![taskDetailsController
                                                        .taskDetailsData
                                                        .value
                                                        .taskTransportationData!
                                                        .length -
                                                    1]
                                                .taskTransportationEndLong ==
                                            null) {
                                      popUpStatus(
                                        context,
                                        leadingIcon: Icons.error_outline,
                                        title: "MISSED END LOCATION",
                                        subtitle: "You have not clicked the reach button above!!",
                                        firstActionButtonTitle: "OK",
                                        firstActionButtonColor: const Color(0xFFed6c02),
                                      );
                                    }
                                    // else if (!taskDetailsController
                                    //     .mobileOtpStatus.value) {
                                    //   popUpStatus(
                                    //     context,
                                    //     leadingIcon: Icons.not_listed_location,
                                    //     title: "Verify mobile number!!",
                                    //     subtitle:
                                    //         "You havn't verify mobile number yet",
                                    //     firstActionButtonTitle: "OK",
                                    //     firstActionButtonColor:
                                    //         const Color(0xFFed6c02),
                                    //   );
                                    // }
                                    else {
                                      popUpStatus(context,
                                          leadingIcon: Icons.not_listed_location,
                                          title: "Are you sure",
                                          subtitle: "This will end your task",
                                          twoButton: true,
                                          firstActionButtonTitle: "No",
                                          firstActionButtonColor: const Color(0xFFed6c02),
                                          secondActionButtonTitle: "Yes",
                                          secondActionButtonOnTap: () async {
                                        Map<String, dynamic>? response =
                                            await taskDetailsController.taskAccomplish(
                                                endPoint: ApiUrl().taskAccomplish,
                                                taskId: taskDetailsController
                                                    .taskDetailsData.value.taskId
                                                    .toString());

                                        if (response != {}) {
                                          popUpStatus(context,
                                              barrierDismissible: false,
                                              twoButton: false,
                                              leadingIcon: Icons.check_circle_outline,
                                              title: "${response!['data']}",
                                              subtitle: "Your task is complete",
                                              firstActionButtonTitle: "Goto Home Page",
                                              firstActionButtonOnTap: () {
                                            log("PRESSED");
                                            Get.offAll(() => const HomePage());
                                          });
                                        }
                                      });
                                    }
                                  } else {
                                    popUpStatus(context,
                                        leadingIcon: Icons.not_listed_location,
                                        title: "Are you sure",
                                        subtitle: "This will end your task",
                                        twoButton: true,
                                        firstActionButtonTitle: "No",
                                        firstActionButtonColor: const Color(0xFFed6c02),
                                        secondActionButtonTitle: "Yes",
                                        secondActionButtonOnTap: () async {
                                      Map<String, dynamic>? response =
                                          await taskDetailsController.taskAccomplish(
                                              endPoint: ApiUrl().taskAccomplish,
                                              taskId: taskDetailsController
                                                  .taskDetailsData.value.taskId
                                                  .toString());

                                      if (response != {}) {
                                        popUpStatus(context,
                                            barrierDismissible: false,
                                            twoButton: false,
                                            leadingIcon: Icons.check_circle_outline,
                                            title: "${response!['data']}",
                                            subtitle: "Your task is complete",
                                            firstActionButtonTitle: "Goto Home Page",
                                            firstActionButtonOnTap: () {
                                          log("PRESSED");
                                          Get.offAll(() => const HomePage());
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            child: const Text("ACCOMPLISH"))),*/
                    if(!_isReturnOptionVisible(upActivityTaskDetailsController))
                    SlideAction(
                      key: _key,
                      height: 42,
                      text: "Accomplish",
                      textStyle: theme.textTheme.titleMedium
                          ?.copyWith(color: ColorConstant.secondaryThemeColor),
                      outerColor: ColorConstant().baseColor,
                      innerColor: ColorConstant.secondaryThemeColor,
                      sliderButtonIcon: const Icon(Icons.arrow_forward),
                      sliderButtonIconSize: 24,
                      sliderButtonIconPadding: 4,
                      animationDuration: const Duration(milliseconds: 500),
                      onSubmit: () async {
                        AuthController authController = AuthController();
                        if (!await AuthController().checkLocationStatus()) {
                          authController.logout();
                        } else {
                          if (context.mounted) {
                            if (taskDetailsController.taskDetailsData.value.taskStartTime == null &&
                                taskDetailsController.taskDetailsData.value.taskEndTime == null) {
                              popUpStatus(
                                context,
                                leadingIcon: Icons.error_outline,
                                title: "Task isn't start yes!",
                                subtitle: "Start your task first before going to checklist.",
                                firstActionButtonTitle: "OK",
                                firstActionButtonColor: const Color(0xFFed6c02),
                              );
                            } else if (taskDetailsController
                                .taskDetailsData.value.taskTransportationData!.isEmpty) {
                              popUpStatus(context,
                                  leadingIcon: Icons.not_listed_location,
                                  title: "Are you sure",
                                  subtitle: "This will end your task",
                                  twoButton: true,
                                  firstActionButtonTitle: "No",
                                  firstActionButtonColor: const Color(0xFFed6c02),
                                  secondActionButtonTitle: "Yes",
                                  secondActionButtonOnTap: () async {
                                Map<String, dynamic>? response =
                                    await taskDetailsController.taskAccomplish(
                                        endPoint: ApiUrl().taskAccomplish,
                                        taskId: taskDetailsController.taskDetailsData.value.taskId
                                            .toString());

                                if (response != {}) {
                                  popUpStatus(context,
                                      barrierDismissible: false,
                                      twoButton: false,
                                      leadingIcon: Icons.check_circle_outline,
                                      leadingIconColor: Colors.green,
                                      title: "${response!['data']}",
                                      subtitle: "Your task is complete",
                                      firstActionButtonTitle: "Goto Home Page",
                                      firstActionButtonOnTap: () {
                                    log("PRESSED");
                                    Get.offAll(() => const HomePage());
                                  });
                                }
                              });
                            } else if (taskDetailsController
                                .taskDetailsData.value.taskTransportationData!.isNotEmpty) {
                              if (taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData!
                                                  .length -
                                              1]
                                          .taskTransportationEndLat ==
                                      null &&
                                  taskDetailsController
                                          .taskDetailsData
                                          .value
                                          .taskTransportationData![taskDetailsController
                                                  .taskDetailsData
                                                  .value
                                                  .taskTransportationData!
                                                  .length -
                                              1]
                                          .taskTransportationEndLong ==
                                      null) {
                                popUpStatus(
                                  context,
                                  leadingIcon: Icons.location_off,
                                  title: "MISSED END LOCATION",
                                  subtitle: "You have not clicked the reach button above!!",
                                  firstActionButtonTitle: "OK",
                                  firstActionButtonColor: const Color(0xFFed6c02),
                                );
                              }
                              // else if (!taskDetailsController
                              //     .mobileOtpStatus.value) {
                              //   popUpStatus(
                              //     context,
                              //     leadingIcon: Icons.not_listed_location,
                              //     title: "Verify mobile number!!",
                              //     subtitle:
                              //         "You havn't verify mobile number yet",
                              //     firstActionButtonTitle: "OK",
                              //     firstActionButtonColor:
                              //         const Color(0xFFed6c02),
                              //   );
                              // }
                              else {
                                popUpStatus(context,
                                    leadingIcon: Icons.not_listed_location,
                                    title: "Are you sure",
                                    subtitle: "This will end your task",
                                    twoButton: true,
                                    firstActionButtonTitle: "No",
                                    firstActionButtonColor: const Color(0xFFed6c02),
                                    secondActionButtonTitle: "Yes",
                                    secondActionButtonOnTap: () async {
                                  Map<String, dynamic>? response =
                                      await taskDetailsController.taskAccomplish(
                                          endPoint: ApiUrl().taskAccomplish,
                                          taskId: taskDetailsController.taskDetailsData.value.taskId
                                              .toString());

                                  if (response != {}) {
                                    popUpStatus(context,
                                        barrierDismissible: false,
                                        twoButton: false,
                                        leadingIcon: Icons.check_circle_outline,
                                        title: "${response!['data']}",
                                        subtitle: "Your task is complete",
                                        firstActionButtonTitle: "Goto Home Page",
                                        firstActionButtonOnTap: () {
                                      log("PRESSED");
                                      Get.offAll(() => const HomePage());
                                    });
                                  }
                                });
                              }
                            } else {
                              popUpStatus(context,
                                  leadingIcon: Icons.not_listed_location,
                                  title: "Are you sure",
                                  subtitle: "This will end your task",
                                  twoButton: true,
                                  firstActionButtonTitle: "No",
                                  firstActionButtonColor: const Color(0xFFed6c02),
                                  secondActionButtonTitle: "Yes",
                                  secondActionButtonOnTap: () async {
                                Map<String, dynamic>? response =
                                    await taskDetailsController.taskAccomplish(
                                        endPoint: ApiUrl().taskAccomplish,
                                        taskId: taskDetailsController.taskDetailsData.value.taskId
                                            .toString());

                                if (response != {}) {
                                  popUpStatus(context,
                                      barrierDismissible: false,
                                      twoButton: false,
                                      leadingIcon: Icons.check_circle_outline,
                                      title: "${response!['data']}",
                                      subtitle: "Your task is complete",
                                      firstActionButtonTitle: "Goto Home Page",
                                      firstActionButtonColor: ColorConstant().baseColor,
                                      firstActionButtonOnTap: () {
                                    log("PRESSED");
                                    Get.offAll(() => const HomePage());
                                  });
                                }
                              });
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  bool _isReturnOptionVisible(UpActivityTaskController upActivityTaskController) {
    bool visibility = true;

    for (CheckList checkList in upActivityTaskController.checkListData) {
      if (checkList.statusLsit!.length == 1 && checkList.statusLsit![0].title == 'Completed') {
        visibility = false;
        break;
      }
    }

    return visibility;
  }

  showModal(BuildContext context, DownActivityTaskController taskDetailsController, bool edit,
      {String? from,
      String? to,
      String? vehicle,
      String? vehicleId,
      String? fare,
      String? remark,
      String? autoId}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        taskDetailsController.searchFromController.clear();
        taskDetailsController.searchToController.clear();
        taskDetailsController.searchVehicleController.clear();
        taskDetailsController.fareTextEditingController.clear();
        taskDetailsController.remarkTextEditingController.clear();
        taskDetailsController.fareCloseIcon.value = false;
        taskDetailsController.remarkCloseIcon.value = false;
        taskDetailsController.showFromValidate.value = "false";
        taskDetailsController.showToValidate.value = "false";
        taskDetailsController.showVehicleValidate.value = "false";
        taskDetailsController.showFareValidate.value = "false";
        !edit
            ? taskDetailsController.searchFromController.text = ""
            : taskDetailsController.searchFromController.text = from!;
        !edit
            ? taskDetailsController.searchToController.text = ""
            : taskDetailsController.searchToController.text = to!;
        !edit
            ? taskDetailsController.searchVehicleController.text = ""
            : taskDetailsController.searchVehicleController.text = vehicle!;
        !edit
            ? taskDetailsController.fareTextEditingController.text = ""
            : taskDetailsController.fareTextEditingController.text = fare!;
        !edit
            ? taskDetailsController.remarkTextEditingController.text = ""
            : taskDetailsController.remarkTextEditingController.text = remark!;

        return StatefulBuilder(builder: (context, StateSetter mystate) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 16,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Add Transport',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              taskDetailsController.searchFromController.clear();
                              taskDetailsController.searchToController.clear();
                              taskDetailsController.searchVehicleController.clear();
                              taskDetailsController.fareTextEditingController.clear();
                              taskDetailsController.remarkTextEditingController.clear();
                              taskDetailsController.fareCloseIcon.value = false;
                              taskDetailsController.remarkCloseIcon.value = false;
                              taskDetailsController.showFromValidate.value = "false";
                              taskDetailsController.showToValidate.value = "false";
                              taskDetailsController.showVehicleValidate.value = "false";
                              taskDetailsController.showFareValidate.value = "false";
                              Get.back();
                            },
                            child: const Icon(Icons.cancel_outlined))
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    SearchAnchor(
                        isFullScreen: false,
                        viewBackgroundColor: const Color(0xFFE8F0FE),
                        searchController: taskDetailsController.searchFromController,
                        viewHintText: taskDetailsController.searchFromController.text,
                        viewOnChanged: (value) {
                          taskDetailsController.filterFromLocations(value);
                          mystate(() {
                            taskDetailsController.showFromValidate.value = "false";
                          });
                        },
                        viewTrailing: [
                          IconButton(
                              onPressed: () {
                                mystate(() {
                                  taskDetailsController.searchFromController.clear();
                                  taskDetailsController.filteredFromLocationsList.value = [];
                                  taskDetailsController.searchFromController.closeView("");
                                });
                              },
                              icon: const Icon(Icons.clear))
                        ],
                        builder: (context, controller) {
                          return TextFormField(
                            readOnly: true,
                            onTap: () {
                              controller.openView();
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "From",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: ColorConstant().baseColor),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.purple, width: 0.5),
                              ),
                            ),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          //log("CHECKING: ${taskDetailsController.formLocationDetailsList.length}");
                          return [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Scrollbar(
                                thickness: 10,
                                child: ListView.builder(
                                    itemCount: taskDetailsController
                                            .filteredFromLocationsList.isEmpty
                                        ? taskDetailsController.formLocationDetailsList.length
                                        : taskDetailsController.filteredFromLocationsList.length,
                                    itemBuilder: (context, index) {
                                      LocationDetails location = taskDetailsController
                                              .filteredFromLocationsList.isEmpty
                                          ? taskDetailsController.formLocationDetailsList[index]
                                          : taskDetailsController.filteredFromLocationsList[index];

                                      return InkWell(
                                        onTap: () {
                                          // taskDetailsController
                                          //         .filteredFromLocationsList =
                                          //     taskDetailsController.locations;
                                          taskDetailsController.searchFromController
                                              .closeView(location.locationName);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                          color: index == 0
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors.transparent,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16, top: 16),
                                            child: Text(
                                              "${location.locationName}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ];
                        }),
                    Visibility(
                      visible: taskDetailsController.showFromValidate.value == "true" &&
                              taskDetailsController.searchFromController.text == ""
                          ? true
                          : false,
                      child: const Text(
                        "Please fill required field",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SearchAnchor(
                        viewBackgroundColor: const Color(0xFFE8F0FE),
                        isFullScreen: false,
                        searchController: taskDetailsController.searchToController,
                        viewHintText: taskDetailsController.searchToController.text,
                        viewOnChanged: (value) {
                          taskDetailsController.filterToLocations(value);
                          mystate(() {
                            taskDetailsController.showToValidate.value = "false";
                          });
                        },
                        viewTrailing: [
                          IconButton(
                              onPressed: () {
                                mystate(() {
                                  taskDetailsController.searchToController.clear();
                                  // taskDetailsController
                                  //         .filteredToLocationsList =
                                  //     taskDetailsController.locations;
                                  taskDetailsController.searchToController.closeView("");
                                });
                              },
                              icon: const Icon(Icons.clear))
                        ],
                        builder: (context, controller) {
                          return TextFormField(
                            readOnly: true,
                            onTap: () {
                              controller.openView();
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: edit ? to : "To",
                              labelText: "To",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color:
                                        ColorConstant().baseColor), // Change underline color here
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.purple, width: 0.5),
                              ),
                            ),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          return [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Scrollbar(
                                thickness: 10,
                                child: ListView.builder(
                                    itemCount: taskDetailsController.filteredToLocationsList.isEmpty
                                        ? taskDetailsController.toLocationDetailsList.length
                                        : taskDetailsController.filteredToLocationsList.length,
                                    itemBuilder: (context, index) {
                                      LocationDetails location = taskDetailsController
                                              .filteredToLocationsList.isEmpty
                                          ? taskDetailsController.toLocationDetailsList[index]
                                          : taskDetailsController.filteredToLocationsList[index];
                                      return SizedBox(
                                        height: 50,
                                        child: InkWell(
                                          onTap: () {
                                            // taskDetailsController
                                            //         .filteredToLocationsList =
                                            //     taskDetailsController.locations;

                                            taskDetailsController.searchToController
                                                .closeView(location.locationName);
                                          },
                                          child: Container(
                                            color: index == 0
                                                ? Colors.blue.withOpacity(0.1)
                                                : Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16, top: 16),
                                              child: Text(
                                                "${location.locationName}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ];
                        }),
                    Visibility(
                      visible: taskDetailsController.showToValidate.value == "true" &&
                              taskDetailsController.searchToController.text == ""
                          ? true
                          : false,
                      child: const Text(
                        "Please fill required field",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SearchAnchor(
                        viewBackgroundColor: const Color(0xFFE8F0FE),
                        isFullScreen: false,
                        searchController: taskDetailsController.searchVehicleController,
                        viewHintText: taskDetailsController.searchVehicleController.text,
                        viewOnChanged: (value) {
                          taskDetailsController.filterVehicles(value);
                          mystate(() {
                            taskDetailsController.showVehicleValidate.value = "false";
                          });
                        },
                        viewTrailing: [
                          IconButton(
                              onPressed: () {
                                mystate(() {
                                  taskDetailsController.searchVehicleController.clear();

                                  taskDetailsController.searchVehicleController.closeView("");
                                });
                              },
                              icon: const Icon(Icons.clear))
                        ],
                        builder: (context, controller) {
                          return TextFormField(
                            readOnly: true,
                            onTap: () {
                              controller.openView();
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: edit ? vehicle : "Vehicle",
                              labelText: "Vehicle",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color:
                                        ColorConstant().baseColor), // Change underline color here
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.purple, width: 0.5),
                              ),
                            ),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          return [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Scrollbar(
                                thickness: 10,
                                child: ListView.builder(
                                    itemCount: taskDetailsController.filteredVechileList.isEmpty
                                        ? taskDetailsController.vehiclesList.length
                                        : taskDetailsController.filteredVechileList.length,
                                    itemBuilder: (context, index) {
                                      VehicleData vehicle =
                                          taskDetailsController.filteredVechileList.isEmpty
                                              ? taskDetailsController.vehiclesList[index]
                                              : taskDetailsController.filteredVechileList[index];
                                      return InkWell(
                                        onTap: () {
                                          taskDetailsController.selectedVehicleId.value =
                                              vehicle.key ?? 0;
                                          taskDetailsController.searchVehicleController
                                              .closeView(vehicle.value);
                                        },
                                        child: Container(
                                          color: index == 0
                                              ? Colors.blue.withOpacity(0.1)
                                              : Colors.transparent,
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16, top: 16),
                                            child: Text(
                                              "${vehicle.value}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ];
                        }),
                    Visibility(
                      visible: taskDetailsController.showVehicleValidate.value == "true" &&
                              taskDetailsController.searchVehicleController.text == ""
                          ? true
                          : false,
                      child: const Text(
                        "Please fill required field",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: taskDetailsController.fareTextEditingController,
                      onTap: () {
                        taskDetailsController.fareCloseIcon.value = true;
                      },
                      onChanged: (value) {
                        if (taskDetailsController.fareTextEditingController.text != "") {
                          taskDetailsController.fareCloseIcon.value = true;
                          taskDetailsController.showFareValidate.value = "false";
                        } else {
                          taskDetailsController.fareCloseIcon.value = false;
                        }

                        mystate(() {
                          taskDetailsController.showFareValidate.value = "false";
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: taskDetailsController.fareCloseIcon.value
                            ? InkWell(
                                onTap: () {
                                  mystate(() {
                                    taskDetailsController.fareTextEditingController.clear();
                                    taskDetailsController.fareCloseIcon.value = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 18.0),
                                  child: Icon(Icons.close),
                                ),
                              )
                            : const SizedBox.shrink(),
                        hintText: edit ? fare : "Fare",
                        labelText: 'Fare',
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: ColorConstant().baseColor), // Change underline color here
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.purple, width: 0.5),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: taskDetailsController.showFareValidate.value == "true" &&
                              taskDetailsController.fareTextEditingController.text == ""
                          ? true
                          : false,
                      child: const Text(
                        "Please fill required field",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: taskDetailsController.remarkTextEditingController,
                      onTap: () {
                        taskDetailsController.remarkCloseIcon.value = true;
                      },
                      onChanged: (value) {
                        if (taskDetailsController.remarkTextEditingController.text != "") {
                          taskDetailsController.remarkCloseIcon.value = true;
                        } else {
                          taskDetailsController.remarkCloseIcon.value = false;
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: taskDetailsController.remarkCloseIcon.value
                            ? InkWell(
                                onTap: () {
                                  mystate(() {
                                    taskDetailsController.remarkTextEditingController.clear();
                                    taskDetailsController.remarkCloseIcon.value = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 18.0),
                                  child: Icon(Icons.close),
                                ),
                              )
                            : const SizedBox.shrink(),
                        hintText: edit ? remark : "Remark",
                        labelText: 'Remark',
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: ColorConstant().baseColor), // Change underline color here
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.purple, width: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: !edit
                            ? () async {
                                AuthController authController = Get.put(AuthController());
                                var taskId = taskDetailsController.taskDetailsData.value.taskId;
                                if (taskDetailsController.searchFromController.text != "" &&
                                    taskDetailsController.searchToController.text != "" &&
                                    taskDetailsController.searchVehicleController.text != "" &&
                                    taskDetailsController.fareTextEditingController.text != "") {
                                  if (!await authController.checkLocationStatus()) {
                                    authController.logout();
                                  } else {
                                    taskDetailsController.addTransport();
                                    Get.back();
                                  }
                                } else {
                                  mystate(() {
                                    taskDetailsController.showFromValidate.value = "true";
                                    taskDetailsController.showToValidate.value = "true";
                                    taskDetailsController.showVehicleValidate.value = "true";
                                    taskDetailsController.showFareValidate.value = "true";
                                  });
                                }
                              }
                            : () async {
                                AuthController authController = Get.put(AuthController());

                                var request = {
                                  // "taskId": taskDetailsController.taskId.value,
                                  "taskTransportationAutoId": autoId ?? "",
                                  "taskTransportationCost":
                                      taskDetailsController.fareTextEditingController.text == ""
                                          ? fare
                                          : taskDetailsController.fareTextEditingController.text,
                                  "taskTransportationEndLat": null,
                                  "taskTransportationEndLocation":
                                      taskDetailsController.searchToController.text == ""
                                          ? to
                                          : taskDetailsController.searchToController.text,
                                  "taskTransportationEndLong": null,
                                  "taskTransportationRemarks":
                                      taskDetailsController.remarkTextEditingController.text == ""
                                          ? remark
                                          : taskDetailsController.remarkTextEditingController.text,
                                  "taskTransportationStartLat": authController.latitude.value,
                                  "taskTransportationStartLocation":
                                      taskDetailsController.searchFromController.text == ""
                                          ? from
                                          : taskDetailsController.searchFromController.text,
                                  "taskTransportationStartLong": authController.longitude.value,
                                  "taskTransportationVehicleId":
                                      taskDetailsController.selectedVehicleId.value == 0
                                          ? vehicleId
                                          : taskDetailsController.selectedVehicleId.value,
                                  "taskTransporationWayStatus": 0
                                };
                                if (!await authController.checkLocationStatus()) {
                                  authController.logout();
                                } else {
                                  taskDetailsController.editTransport(
                                      endPoint: ApiUrl().updateTransportation, data: request);
                                  Get.back();
                                }
                              },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          backgroundColor: const MaterialStatePropertyAll(Colors.green),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              !edit ? "Add" : "Update",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 500,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  double listHeightChanging(DownActivityTaskController taskDetailsController) {
    double intHeight = 85;
    double totalHeight = 0;
    if (taskDetailsController.taskDetailsData.value.taskTransportationData!.isNotEmpty) {
      for (int i = 1;
          i <= taskDetailsController.taskDetailsData.value.taskTransportationData!.length;
          i++) {
        totalHeight = intHeight * (i);
        if (totalHeight > 340) {
          totalHeight = 340;
        }
      }
      return totalHeight;
    }

    return totalHeight;
  }

  bool _requiredVerifyMobileNumber() {
    final UpActivityTaskController taskDetailsController = Get.find();
    bool value = false;
    for (CheckList data in taskDetailsController.checkListData) {
      if (data.title == "Product_Delivery") {
        value = true;
        break;
      }
    }
    if (value) {
      if (taskDetailsController.taskDetailsData.value.taskGroupId != "C") {
        value = true;
      } else {
        value = false;
      }
    }
    return value;
  }
}
