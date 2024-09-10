import 'dart:developer';
import 'dart:math';
import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/controller/up_activity_task_controller.dart';
import 'package:TradeZentrum/app/dialogs/empty_transport_dialog.dart';
import 'package:TradeZentrum/app/dialogs/missed_end_location_dialog.dart';
import 'package:TradeZentrum/app/dialogs/task_not_started_dialog.dart';
import 'package:TradeZentrum/app/dialogs/verify_mobile_number_waring_dialog.dart';
import 'package:TradeZentrum/app/model/check_list_model.dart';

import 'package:TradeZentrum/app/model/task_details_model.dart';
import 'package:TradeZentrum/app/screens/connectivity/internet_connectivity.dart';
import 'package:TradeZentrum/app/screens/down_activity_task_page.dart';
import 'package:TradeZentrum/app/screens/mobile_number_verify_page.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/widgets/task_detail_widget.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../dialogs/start_task_dialog.dart';
import 'home/home_page.dart';

class CheckListPage extends GetView<UpActivityTaskController> {
  final String pageTitle;

  const CheckListPage({
    super.key,
    required this.pageTitle,
  });

  bool _isReturnOptionVisible(
      UpActivityTaskController upActivityTaskController) {
    bool visibility = true;

    for (CheckList checkList in upActivityTaskController.checkListData) {
      if (checkList.statusLsit!.length == 1 &&
          checkList.statusLsit![0].title == 'Completed') {
        visibility = false;
        break;
      }
    }

    return visibility;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    final formKey1 = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final taskDetailsController = Get.put(UpActivityTaskController());




    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        Get.back();
      },
      child: InternetConnectivity(
        child: Scaffold(
          backgroundColor: ColorConstant.primaryBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: CustomAppBar(
              toPage: "CheckListPage",
              pageTitle: pageTitle,
              onBackTap: () {
                taskDetailsController.showReturnButton.value = false;
                Get.back();
              },
              actions: [
                InkWell(
                  onTap: () async {
                    AuthController authController = AuthController();
                    if (!await AuthController().checkLocationStatus()) {
                      authController.logout();
                    } else {
                      if (context.mounted) {
                        TaskDetailsData taskDetails = taskDetailsController.taskDetailsData.value;
                        List<TaskTransportationData>? taskTransportations =
                            taskDetailsController.taskDetailsData.value.taskTransportationData ??
                                [];
                        if (taskDetails.taskStartTime == null && taskDetails.taskEndTime == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TaskNotStartedDialog(onOkayButtonPressed: (){
                                Get.back();
                              }, warningText: "Start your task before going to down activity");
                            },
                          );
                        } else if (taskTransportations.isEmpty && taskDetails.taskGroupId == "P") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EmptyTransportDialog(onOkayButtonPressed: (){
                                Get.back();
                              });

                            },
                          );
                        } else if (taskTransportations.isNotEmpty
                            && taskTransportations[taskTransportations.length - 1].taskTransportationEndLat == null
                            && taskTransportations[taskTransportations.length - 1].taskTransportationEndLong == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MissedEndLocationDialog(onOkayButtonPressed: (){
                                Get.back();
                              });
                            },
                          );
                        } else if (_requiredVerifyMobileNumber() && !taskDetailsController.verifyOtpStatus.value) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return VerifyMobileNumberWaringDialog(
                                onOkayButtonPressed: () {
                                  Get.back();
                                },
                              );
                            },
                          );
                        } else {
                          List<CheckList> statusTitle = [];
                          for (var checkList in taskDetailsController.checkListData) {
                            for (var statusList in checkList.statusLsit!) {
                              if (statusList.title == "Pending") {
                                statusTitle.add(checkList);
                              }
                            }
                          }
                          if (statusTitle.isNotEmpty) {
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
                                        Icons.checklist,
                                        size: 60,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "MISSED A CHECKLIST!!!",
                                        style: theme.textTheme.titleLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "You have Pending a checkList list!!",
                                        style: theme.textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      for (int i = 0;
                                          i < statusTitle.length;
                                          i++)
                                        Obx(
                                          () => Row(
                                            children: [
                                              Checkbox(
                                                value: taskDetailsController
                                                    .warningCheckList.value,
                                                onChanged: (bool? value) {
                                                  taskDetailsController
                                                      .warningCheckList
                                                      .value = value!;
                                                },
                                              ),
                                              Text(
                                                statusTitle[i].title!,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Obx(() => ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                          Color>(
                                                      taskDetailsController
                                                              .warningCheckList
                                                              .value
                                                          ? ColorConstant
                                                              .primaryThemeColor
                                                          : ColorConstant
                                                              .primaryThemeColor
                                                              .withOpacity(
                                                                  0.5))),
                                          onPressed: () {
                                            if (taskDetailsController
                                                .warningCheckList.value) {
                                              Get.off(
                                                  () => DownActivityTaskPage(
                                                        pageTitle: pageTitle,
                                                      ),
                                                  arguments:
                                                      taskDetailsController
                                                          .taskDetailsData
                                                          .value
                                                          .taskId
                                                          .toString());
                                            }
                                          },
                                          child: const Text(
                                            "Continue",
                                          ),
                                        ))
                                  ],
                                );
                              },
                            );
                          } else {
                            Get.off(
                                () => DownActivityTaskPage(
                                      pageTitle: pageTitle,
                                    ),
                                arguments: taskDetailsController
                                    .taskDetailsData.value.taskId
                                    .toString());
                          }
                        }
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant().baseColor,
                    ),
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.chevron_right,
                      color: ColorConstant.secondaryThemeColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Task Details -->

                  TaskDetailWidget(
                    taskDetailsData:
                        taskDetailsController.taskDetailsData.value,
                    onPlayPauseButtonTap: () {
                      String? taskStartTime =
                          taskDetailsController.taskDetailsData.value.taskStartTime;
                      String? taskEndTime =
                          taskDetailsController.taskDetailsData.value.taskEndTime;
                      if (taskStartTime == null && taskEndTime == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StartTaskDialog(
                              onNoButtonPressed: () {
                                Get.back();
                              },
                              onYesButtonPressed: () {
                                taskDetailsController.declearTaskStart(
                                  endPoint: ApiUrl().declearTaskStart,
                                  taskId: taskDetailsController.taskId.value,
                                );
                                Get.back();
                              },
                            );
                          },
                        );
                      }
                    },
                  ),

                  /// Verify Mobile Number -->
                  if (_requiredVerifyMobileNumber())
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: taskDetailsController.verifyOtpStatus.value
                              ? ColorConstant.green
                              : ColorConstant().baseColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                List<TaskTransportationData>? taskTransportations =
                                    taskDetailsController.taskDetailsData.value.taskTransportationData ??
                                        [];
                                _verifyMobileNumber(taskTransportations,
                                    context, taskDetailsController);
                              },
                              title: RichText(
                                text: TextSpan(children: [
                                  WidgetSpan(
                                      child: Image.asset(
                                    "assets/ic_verify_mobile.png",
                                    height: 24,
                                    width: 24,
                                    color: ColorConstant.secondaryThemeColor,
                                  )),
                                  const WidgetSpan(
                                      child: SizedBox(
                                    width: 15,
                                  )),
                                  TextSpan(
                                      text: taskDetailsController
                                              .verifyOtpStatus.value
                                          ? "Mobile number verified"
                                          : "Verify mobile number",
                                      style: theme.textTheme.titleLarge!
                                          .copyWith(
                                              color: taskDetailsController
                                                      .verifyOtpStatus.value
                                                  ? Colors.white
                                                  : ColorConstant
                                                      .secondaryThemeColor)),
                                ]),
                              ),
                              trailing: taskDetailsController
                                      .verifyOtpStatus.value
                                  ? const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ColorConstant.secondaryThemeColor,
                                      size: 20,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Check List",
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 4,
                  ),

                  /// Check List -->
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskDetailsController.checkListData.length,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      itemBuilder: (BuildContext context, int index) {
                        CheckList data =
                            taskDetailsController.checkListData[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              data.title ?? "",
                              style: theme.textTheme.bodyMedium,
                            ),
                            trailing: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: data.statusLsit![0].title ==
                                            'Pending'
                                        ? ColorConstant().baseColor
                                        : ColorConstant
                                            .green), // Add border for better visibility
                              ),
                              child: DropdownButton<StatusList>(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                value: data.statusLsit![0],
                                onChanged:
                                    !taskDetailsController.taskReturned.value
                                        ? (StatusList? newValue) async {
                                            await _updateCheckListItemStatus(
                                                taskDetailsController,
                                                context,
                                                newValue);
                                          }
                                        : null,
                                underline: Container(),
                                items: data.statusLsit!
                                    .map<DropdownMenuItem<StatusList>>(
                                        (StatusList value) {
                                  return DropdownMenuItem<StatusList>(
                                    value: value,
                                    child: Text(
                                      value.title!,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              color: data.statusLsit![0]
                                                          .title ==
                                                      'Pending'
                                                  ? ColorConstant().baseColor
                                                  : ColorConstant.green),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            enabled: data.statusLsit![0].title != 'Completed',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateCheckListItemStatus(
      UpActivityTaskController taskDetailsController,
      BuildContext context,
      StatusList? newValue) async {
    if (!await AuthController().checkLocationStatus()) {
      AuthController().logout();
    } else {
      TaskDetailsData taskDetails = taskDetailsController.taskDetailsData.value;
      List<TaskTransportationData>? transports =
          taskDetails.taskTransportationData ?? [];
      if (context.mounted) {
        if (newValue!.title == 'Complete') {
          if (taskDetails.taskStartTime == null &&
              taskDetails.taskEndTime == null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return TaskNotStartedDialog(
                    onOkayButtonPressed: () {
                      Get.back();
                    },
                    warningText:
                        "Start your task first before going to checklist.");
              },
            );
          } else if (transports.isEmpty && taskDetails.taskGroupId == "P") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return EmptyTransportDialog(
                  onOkayButtonPressed: () {
                    Get.back();
                  },
                );
              },
            );
          } else if (transports.isNotEmpty &&
              transports[transports.length - 1].taskTransportationEndLat ==
                  null &&
              transports[transports.length - 1].taskTransportationEndLong ==
                  null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MissedEndLocationDialog(
                  onOkayButtonPressed: () {
                    Get.back();
                  },
                );
              },
            );
          } else if (_requiredVerifyMobileNumber() &&
              !taskDetailsController.verifyOtpStatus.value) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return VerifyMobileNumberWaringDialog(
                  onOkayButtonPressed: () {
                    Get.back();
                  },
                );
              },
            );
          } else {
            taskDetailsController.declearCheckListCompletion(
              endPoint: "${ApiUrl().declearCheckListCompletion}/${newValue.id}",
            );
          }
        }
      }
    }
  }

  void _verifyMobileNumber(List<TaskTransportationData> taskTransportations,
      BuildContext context, UpActivityTaskController taskDetailsController) {
    if (taskTransportations.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EmptyTransportDialog(
            onOkayButtonPressed: () {
              Get.back();
            },
          );
        },
      );
    } else if (taskTransportations.isNotEmpty &&
        taskTransportations[taskTransportations.length - 1]
                .taskTransportationEndLat ==
            null &&
        taskTransportations[taskTransportations.length - 1]
                .taskTransportationEndLong ==
            null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MissedEndLocationDialog(
            onOkayButtonPressed: () {
              Get.back();
            },
          );
        },
      );
    } else {
      if (!taskDetailsController.verifyOtpStatus.value) {
        Get.to(() => const MobileNumberVerifyPage());
      }
    }
  }

  convertStatus(UpActivityTaskController taskDetailsController,
      List<TaskChecklistsData>? checkList) {
    taskDetailsController.checkListData.clear();
    for (int i = 0; i < checkList!.length; i++) {
      if (checkList[i].checklistCompletionStatus == 0) {
        taskDetailsController.checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusList(
                title: "Pending",
                id: checkList[i].taskChecklistAutoId.toString()),
            StatusList(
                title: "Complete",
                id: checkList[i].taskChecklistAutoId.toString()),
          ]),
        );
      } else {
        taskDetailsController.checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusList(
                title: "Completed",
                id: checkList[i].taskChecklistAutoId.toString())
          ]),
        );
      }
    }
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

/*showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0.0))),
                                            content: SizedBox(
                                              height: 180,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFEF5350),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: const Icon(
                                                        Icons
                                                            .not_listed_location,
                                                        size: 80,
                                                        color: Color(0xFFC62828)
                                                        // Color(0xFF9c27b0),
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  const Text(
                                                    "Sure?",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Is this complete?",
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color(
                                                                    0xFF9c27b0))),
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
                                                      taskDetailsController
                                                          .declearCheckListCompletion(
                                                              endPoint:
                                                                  "${ApiUrl().declearCheckListCompletion}/${newValue.id}",
                                                              title:
                                                                  data.title!);
                                                      Get.back();
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0.0),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color(
                                                                    0xFFC62828))),
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
                                      ); */
