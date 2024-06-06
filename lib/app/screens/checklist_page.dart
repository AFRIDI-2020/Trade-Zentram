import 'dart:developer';
import 'dart:math';
import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/controller/up_activity_task_controller.dart';
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

import 'home/home_page.dart';

class CheckListPage extends GetView<UpActivityTaskController> {
  final String pageTitle;

  const CheckListPage({
    super.key,
    required this.pageTitle,
  });

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
                    if (!await AuthController().handleLocationPermission()) {
                      authController.logout();
                    } else {
                      if (context.mounted) {
                        if (taskDetailsController.taskDetailsData.value.taskStartTime == null &&
                            taskDetailsController.taskDetailsData.value.taskEndTime == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8))),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_circle_outline, size: 80,
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                        } else if (taskDetailsController
                            .taskDetailsData.value.taskTransportationData!.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                    Text("Empty Transport", style: theme.textTheme.titleLarge),
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
                        } else if (taskDetailsController
                                    .taskDetailsData
                                    .value
                                    .taskTransportationData![taskDetailsController
                                            .taskDetailsData.value.taskTransportationData!.length -
                                        1]
                                    .taskTransportationEndLat ==
                                null &&
                            taskDetailsController
                                    .taskDetailsData
                                    .value
                                    .taskTransportationData![taskDetailsController
                                            .taskDetailsData.value.taskTransportationData!.length -
                                        1]
                                    .taskTransportationEndLat ==
                                null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                    Text("Missed End Location", style: theme.textTheme.titleLarge),
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
                        } else if (!taskDetailsController.verifyOtpStatus.value) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
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
                        }

                        // else if (!taskDetailsController.mobileOtpStatus.value) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(0.0))),
                        //         content: const SizedBox(
                        //           height: 180,
                        //           child: Column(
                        //             children: [
                        //               Icon(Icons.not_listed_location,
                        //                   size: 80, color: Color(0xFFC62828)
                        //                   // Color(0xFF9c27b0),
                        //                   ),
                        //               SizedBox(
                        //                 height: 16,
                        //               ),
                        //               Text(
                        //                 "Verify mobile number!!",
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 "You havn't verify mobile number yet",
                        //                 style: TextStyle(fontSize: 12),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         actions: <Widget>[
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               ElevatedButton(
                        //                 onPressed: () {
                        //                   Get.back();
                        //                 },
                        //                 style: ButtonStyle(
                        //                     shape: MaterialStateProperty.all<
                        //                         RoundedRectangleBorder>(
                        //                       RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(0.0),
                        //                       ),
                        //                     ),
                        //                     backgroundColor:
                        //                         const MaterialStatePropertyAll(
                        //                             Color(0xFF9c27b0))),
                        //                 child: const Text(
                        //                   "Okay",
                        //                   style: TextStyle(color: Colors.white),
                        //                 ),
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                        else {
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
                                      borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                      for (int i = 0; i < statusTitle.length; i++)
                                        Obx(
                                          () => Row(
                                            children: [
                                              Checkbox(
                                                value: taskDetailsController.warningCheckList.value,
                                                onChanged: (bool? value) {
                                                  taskDetailsController.warningCheckList.value =
                                                      value!;
                                                },
                                              ),
                                              Text(
                                                statusTitle[i].title!,
                                                style: theme.textTheme.bodyMedium,
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
                                          backgroundColor: MaterialStateProperty.all<Color>(taskDetailsController.warningCheckList.value? ColorConstant.primaryThemeColor : ColorConstant.primaryThemeColor.withOpacity(0.5))
                                      ),
                                      onPressed: () {
                                        if(taskDetailsController.warningCheckList.value) {
                                          Get.off(
                                                  () => DownActivityTaskPage(
                                                pageTitle: pageTitle,
                                              ),
                                              arguments: taskDetailsController
                                                  .taskDetailsData.value.taskId
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
                                arguments:
                                    taskDetailsController.taskDetailsData.value.taskId.toString());
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
          /* bottomNavigationBar: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                AuthController authController = AuthController();
                if (!await AuthController().handleLocationPermission()) {
                  authController.logout();
                } else {
                  if (context.mounted) {
                    if (taskDetailsController.taskDetailsData.value.taskStartTime == null &&
                        taskDetailsController.taskDetailsData.value.taskEndTime == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            content: const SizedBox(
                              height: 180,
                              child: Column(
                                children: [
                                  Icon(Icons.not_listed_location, size: 80, color: Color(0xFFed6c02)
                                      // Color(0xFF9c27b0),
                                      ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Task isn't start yes!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Start your task first before going to checklist.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
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
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(Color(0xFFed6c02))),
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    } else if (taskDetailsController
                        .taskDetailsData.value.taskTransportationData!.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            content: const SizedBox(
                              height: 180,
                              child: Column(
                                children: [
                                  Icon(Icons.not_listed_location, size: 80, color: Color(0xFFC62828)
                                      // Color(0xFF9c27b0),
                                      ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Empty Transport!!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "You havn't add any transport yet",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
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
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(Color(0xFF9c27b0))),
                                    child: const Text(
                                      "Okay",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    } else if (taskDetailsController
                                .taskDetailsData
                                .value
                                .taskTransportationData![taskDetailsController
                                        .taskDetailsData.value.taskTransportationData!.length -
                                    1]
                                .taskTransportationEndLat ==
                            null &&
                        taskDetailsController
                                .taskDetailsData
                                .value
                                .taskTransportationData![taskDetailsController
                                        .taskDetailsData.value.taskTransportationData!.length -
                                    1]
                                .taskTransportationEndLat ==
                            null) {
                      showDialog(
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
                                    "MISSED END LOCATION!!!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "You have not clicked the reach button above!!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
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
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(Color(0xFFed6c02))),
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }

                    // else if (!taskDetailsController.mobileOtpStatus.value) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         shape: const RoundedRectangleBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(0.0))),
                    //         content: const SizedBox(
                    //           height: 180,
                    //           child: Column(
                    //             children: [
                    //               Icon(Icons.not_listed_location,
                    //                   size: 80, color: Color(0xFFC62828)
                    //                   // Color(0xFF9c27b0),
                    //                   ),
                    //               SizedBox(
                    //                 height: 16,
                    //               ),
                    //               Text(
                    //                 "Verify mobile number!!",
                    //                 style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 "You havn't verify mobile number yet",
                    //                 style: TextStyle(fontSize: 12),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         actions: <Widget>[
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               ElevatedButton(
                    //                 onPressed: () {
                    //                   Get.back();
                    //                 },
                    //                 style: ButtonStyle(
                    //                     shape: MaterialStateProperty.all<
                    //                         RoundedRectangleBorder>(
                    //                       RoundedRectangleBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(0.0),
                    //                       ),
                    //                     ),
                    //                     backgroundColor:
                    //                         const MaterialStatePropertyAll(
                    //                             Color(0xFF9c27b0))),
                    //                 child: const Text(
                    //                   "Okay",
                    //                   style: TextStyle(color: Colors.white),
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //         ],
                    //       );
                    //     },
                    //   );
                    // }
                    else {
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
                                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
                              content: SizedBox(
                                height: 250,
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 80,
                                      color: Color(0xFFed6c02),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "MISSED A CHECKLIST!!!",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      "You have Pending a checkList list!!",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                    for (int i = 0; i < statusTitle.length; i++)
                                      Obx(
                                        () => Row(
                                          children: [
                                            Checkbox(
                                              value: taskDetailsController.warningCheckList.value,
                                              onChanged: (bool? value) {
                                                taskDetailsController.warningCheckList.value = value!;
                                              },
                                            ),
                                            Text(
                                              statusTitle[i].title!,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Get.off(() => const DownActivityTaskPage(),
                                        arguments: taskDetailsController.taskDetailsData.value.taskId
                                            .toString());
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(Color(0xFFed6c02))),
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        Get.off(() => const DownActivityTaskPage(),
                            arguments: taskDetailsController.taskDetailsData.value.taskId.toString());
                      }
                    }
                  }
                }
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Down Activity"),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),*/
          // bottomNavigationBar: _isReturnOptionVisible(taskDetailsController)
          //     ? Container(
          //         height: 60,
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: Obx(
          //           () => !taskDetailsController.taskReturned.value
          //               ? SlideAction(
          //                   key: _key,
          //                   height: 42,
          //                   text: "Slide to Return",
          //                   textStyle: theme.textTheme.titleMedium
          //                       ?.copyWith(color: ColorConstant.secondaryThemeColor),
          //                   outerColor: ColorConstant().baseColor,
          //                   innerColor: ColorConstant.secondaryThemeColor,
          //                   sliderButtonIcon: const Icon(Icons.arrow_forward),
          //                   sliderButtonIconSize: 24,
          //                   sliderButtonIconPadding: 4,
          //                   animationDuration: const Duration(milliseconds: 500),
          //                   onSubmit: () async {
          //                     if (!await AuthController().handleLocationPermission()) {
          //                       AuthController().logout();
          //                     } else {
          //                       if (context.mounted) {
          //                         if (taskDetailsController.taskDetailsData.value.taskStartTime ==
          //                                 null &&
          //                             taskDetailsController.taskDetailsData.value.taskEndTime ==
          //                                 null) {
          //                           showDialog(
          //                             context: context,
          //                             builder: (BuildContext context) {
          //                               return AlertDialog(
          //                                 backgroundColor: Colors.white,
          //                                 contentPadding:
          //                                 const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          //                                 shape: const RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.all(
          //                                         Radius.circular(8))),
          //                                 content: Column(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   children: [
          //                                     const Icon(Icons.play_circle_outline, size: 80,
          //                                       // Color(0xFF9c27b0),
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 16,
          //                                     ),
          //                                     Text(
          //                                       "Task isn't start yes!",
          //                                       style: theme.textTheme.titleLarge,
          //                                       textAlign: TextAlign.center,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 4,
          //                                     ),
          //                                     Text(
          //                                       "Start your task first before going to checklist.",
          //                                       style: theme.textTheme.bodySmall,
          //                                       textAlign: TextAlign.center,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 actions: <Widget>[
          //                                   Row(
          //                                     mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                     children: [
          //                                       ElevatedButton(
          //                                         onPressed: () {
          //                                           Get.back();
          //                                         },
          //
          //                                         child: const Text(
          //                                           "Ok",
          //
          //                                         ),
          //                                       ),
          //
          //                                     ],
          //                                   )
          //                                 ],
          //                               );
          //                             },
          //                           );
          //                         } else if (taskDetailsController
          //                             .taskDetailsData.value.taskTransportationData!.isEmpty) {
          //                           showDialog(
          //                             context: context,
          //                             builder: (BuildContext context) {
          //                               return AlertDialog(
          //                                 backgroundColor: Colors.white,
          //                                 shape: const RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.all(Radius.circular(8))),
          //                                 content: Column(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   children: [
          //                                     Image.asset(
          //                                       "assets/ic_empty_transport.png",
          //                                       width: 80,
          //                                       height: 80,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 4,
          //                                     ),
          //                                     Text("Empty Transport",
          //                                         style: theme.textTheme.titleLarge),
          //                                     const SizedBox(
          //                                       height: 16,
          //                                     ),
          //                                     Text(
          //                                       "You have not added any transport yet",
          //                                       style: theme.textTheme.bodyMedium,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 10,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 actions: <Widget>[
          //                                   Align(
          //                                     alignment: Alignment.center,
          //                                     child: ElevatedButton(
          //                                       onPressed: () {
          //                                         Get.back();
          //                                       },
          //                                       child: const Text(
          //                                         "Okay",
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               );
          //                             },
          //                           );
          //                         } else if (taskDetailsController
          //                                     .taskDetailsData
          //                                     .value
          //                                     .taskTransportationData![taskDetailsController
          //                                             .taskDetailsData
          //                                             .value
          //                                             .taskTransportationData!
          //                                             .length -
          //                                         1]
          //                                     .taskTransportationEndLat ==
          //                                 null &&
          //                             taskDetailsController
          //                                     .taskDetailsData
          //                                     .value
          //                                     .taskTransportationData![taskDetailsController
          //                                             .taskDetailsData
          //                                             .value
          //                                             .taskTransportationData!
          //                                             .length -
          //                                         1]
          //                                     .taskTransportationEndLat ==
          //                                 null) {
          //                           showDialog(
          //                             context: context,
          //                             builder: (BuildContext context) {
          //                               return AlertDialog(
          //                                 shape: const RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          //                                 content: Column(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   children: [
          //                                     const Icon(
          //                                       Icons.location_off,
          //                                       size: 60,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 4,
          //                                     ),
          //                                     Text("Missed End Location",
          //                                         style: theme.textTheme.titleLarge),
          //                                     const SizedBox(
          //                                       height: 16,
          //                                     ),
          //                                     Text(
          //                                       "You have not clicked the reach button",
          //                                       style: theme.textTheme.bodyMedium,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 10,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 actions: <Widget>[
          //                                   ElevatedButton(
          //                                     onPressed: () {
          //                                       Get.back();
          //                                     },
          //                                     child: const Text(
          //                                       "Ok",
          //                                     ),
          //                                   )
          //                                 ],
          //                               );
          //                             },
          //                           );
          //                         } else if (!taskDetailsController.verifyOtpStatus.value) {
          //                           showDialog(
          //                             context: context,
          //                             builder: (BuildContext context) {
          //                               return AlertDialog(
          //                                 shape: const RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.all(Radius.circular(8))),
          //                                 content: Column(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   children: [
          //                                     Padding(
          //                                       padding: const EdgeInsets.only(left: 15),
          //                                       child: Image.asset(
          //                                         "assets/ic_verify_mobile.png",
          //                                         height: 60,
          //                                         width: 60,
          //                                       ),
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 4,
          //                                     ),
          //                                     Text(
          //                                       "Verify mobile number!!",
          //                                       style: theme.textTheme.titleLarge,
          //                                       textAlign: TextAlign.center,
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 16,
          //                                     ),
          //                                     Text(
          //                                       "You haven't verify mobile number yet",
          //                                       style: theme.textTheme.bodyMedium,
          //                                       textAlign: TextAlign.center,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 actions: <Widget>[
          //                                   Align(
          //                                     alignment: Alignment.center,
          //                                     child: ElevatedButton(
          //                                       onPressed: () {
          //                                         Get.back();
          //                                       },
          //                                       child: const Text(
          //                                         "Okay",
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               );
          //                             },
          //                           );
          //                         } else {
          //                           showDialog(
          //                             context: context,
          //                             builder: (BuildContext context) {
          //                               taskDetailsController.instructedNameTextEditingController
          //                                   .clear();
          //                               taskDetailsController.instructedReasonTextEditingController
          //                                   .clear();
          //                               return AlertDialog(
          //                                 backgroundColor: Colors.white,
          //                                 shape: const RoundedRectangleBorder(
          //                                     borderRadius: BorderRadius.all(Radius.circular(8))),
          //                                 content: Form(
          //                                   key: formKey1,
          //                                   child: Column(
          //                                     mainAxisSize: MainAxisSize.min,
          //                                     children: [
          //                                       Image.asset(
          //                                         "assets/ic_return_product.png",
          //                                         height: 80,
          //                                         width: 80,
          //                                       ),
          //                                       const SizedBox(
          //                                         height: 4,
          //                                       ),
          //                                       Text("Return Product",
          //                                           style: theme.textTheme.titleLarge),
          //                                       const SizedBox(
          //                                         height: 16,
          //                                       ),
          //                                       Text(
          //                                         "Who instructed to return product?",
          //                                         style: theme.textTheme.bodyMedium,
          //                                       ),
          //                                       const SizedBox(
          //                                         height: 10,
          //                                       ),
          //                                       TextFormField(
          //                                         readOnly: false,
          //                                         onTap: () {},
          //                                         controller: taskDetailsController
          //                                             .instructedNameTextEditingController,
          //                                         decoration: const InputDecoration(
          //                                           labelText: "Name",
          //                                           isDense: true,
          //                                           contentPadding: EdgeInsets.symmetric(
          //                                               vertical: 8, horizontal: 8),
          //                                           enabledBorder: OutlineInputBorder(
          //                                             borderRadius:
          //                                                 BorderRadius.all(Radius.circular(4)),
          //                                           ),
          //                                           border: OutlineInputBorder(
          //                                             borderRadius:
          //                                                 BorderRadius.all(Radius.circular(4)),
          //                                           ),
          //                                           focusedBorder: OutlineInputBorder(
          //                                             borderRadius:
          //                                                 BorderRadius.all(Radius.circular(4)),
          //                                           ),
          //                                         ),
          //                                         validator: (value) {
          //                                           if (value == null || value.isEmpty) {
          //                                             return "Enter the instructor name";
          //                                           }
          //
          //                                           return null;
          //                                         },
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                                 actions: <Widget>[
          //                                   ElevatedButton(
          //                                     onPressed: () async {
          //                                       if (formKey1.currentState!.validate()) {
          //                                         Get.back();
          //                                         showDialog(
          //                                           context: context,
          //                                           builder: (BuildContext context) {
          //                                             return AlertDialog(
          //                                               backgroundColor: Colors.white,
          //                                               shape: const RoundedRectangleBorder(
          //                                                   borderRadius: BorderRadius.all(
          //                                                       Radius.circular(8))),
          //                                               content: Form(
          //                                                 key: formKey2,
          //                                                 child: Column(
          //                                                   mainAxisSize: MainAxisSize.min,
          //                                                   children: [
          //                                                     Image.asset(
          //                                                       "assets/ic_return_product.png",
          //                                                       height: 80,
          //                                                       width: 80,
          //                                                     ),
          //                                                     const SizedBox(
          //                                                       height: 4,
          //                                                     ),
          //                                                     Text("Return Product",
          //                                                         style:
          //                                                             theme.textTheme.titleLarge),
          //                                                     const SizedBox(
          //                                                       height: 16,
          //                                                     ),
          //                                                     Text(
          //                                                       "Reason of returning",
          //                                                       style: theme.textTheme.bodyMedium,
          //                                                     ),
          //                                                     const SizedBox(
          //                                                       height: 10,
          //                                                     ),
          //                                                     TextFormField(
          //                                                       controller: taskDetailsController
          //                                                           .instructedReasonTextEditingController,
          //                                                       decoration: const InputDecoration(
          //                                                         labelText: "Reason",
          //                                                         isDense: true,
          //                                                         contentPadding:
          //                                                             EdgeInsets.symmetric(
          //                                                                 horizontal: 8,
          //                                                                 vertical: 8),
          //                                                         enabledBorder: OutlineInputBorder(
          //                                                           borderRadius: BorderRadius.all(
          //                                                               Radius.circular(4)),
          //                                                         ),
          //                                                         border: OutlineInputBorder(
          //                                                           borderRadius: BorderRadius.all(
          //                                                               Radius.circular(4)),
          //                                                         ),
          //                                                         focusedBorder: OutlineInputBorder(
          //                                                           borderRadius: BorderRadius.all(
          //                                                               Radius.circular(4)),
          //                                                         ),
          //                                                       ),
          //                                                       validator: (value) {
          //                                                         if (value == null ||
          //                                                             value.isEmpty) {
          //                                                           return "Write the reason of returning product";
          //                                                         }
          //
          //                                                         return null;
          //                                                       },
          //                                                     ),
          //                                                   ],
          //                                                 ),
          //                                               ),
          //                                               actions: <Widget>[
          //                                                 ElevatedButton(
          //                                                   onPressed: () async {
          //                                                     if (formKey2.currentState!
          //                                                         .validate()) {
          //                                                       Map<String, dynamic>? response =
          //                                                           await taskDetailsController
          //                                                               .returnTask(
          //                                                                   endPoint:
          //                                                                       ApiUrl().returnTask,
          //                                                                   taskIdForReturn:
          //                                                                       taskDetailsController
          //                                                                           .taskDetailsData
          //                                                                           .value
          //                                                                           .taskId
          //                                                                           .toString());
          //                                                       // await taskDetailsController
          //                                                       //     .getTaskDetails(
          //                                                       //   endPoint: ApiUrl().getTaskDetails,
          //                                                       //   taskId: taskDetailsController
          //                                                       //       .taskDetailsData.value.taskId
          //                                                       //       .toString(),
          //                                                       // );
          //
          //                                                       if (response != {}) {
          //                                                         showDialog(
          //                                                           context: context,
          //                                                           barrierDismissible: false,
          //                                                           builder: (context) {
          //                                                             return PopScope(
          //                                                               canPop: false,
          //                                                               child: AlertDialog(
          //                                                                 shape:
          //                                                                     const RoundedRectangleBorder(
          //                                                                   borderRadius:
          //                                                                       BorderRadius.all(
          //                                                                     Radius.circular(8),
          //                                                                   ),
          //                                                                 ),
          //                                                                 title: Icon(
          //                                                                   response['status'] ==
          //                                                                           true
          //                                                                       ? Icons
          //                                                                           .check_circle_outline
          //                                                                       : Icons
          //                                                                           .error_outline_outlined,
          //                                                                   color: response[
          //                                                                               'status'] ==
          //                                                                           true
          //                                                                       ? Colors.green
          //                                                                       : Colors.black,
          //                                                                   size: 44,
          //                                                                 ),
          //                                                                 content: Column(
          //                                                                   mainAxisSize:
          //                                                                       MainAxisSize.min,
          //                                                                   children: [
          //                                                                     Text(
          //                                                                       response['status'] ==
          //                                                                               true
          //                                                                           ? "Product Successfully returned."
          //                                                                           : "Product return failed. Try again later.",
          //                                                                       style: const TextStyle(
          //                                                                           color: Colors
          //                                                                               .black,
          //                                                                           fontWeight:
          //                                                                               FontWeight
          //                                                                                   .bold,
          //                                                                           fontSize: 16),
          //                                                                       textAlign: TextAlign
          //                                                                           .center,
          //                                                                     ),
          //                                                                     ElevatedButton(
          //                                                                       onPressed: () {
          //                                                                         if (response[
          //                                                                                 'status'] ==
          //                                                                             true) {
          //                                                                           Get.offAll(() =>
          //                                                                               const HomePage());
          //                                                                         } else {
          //                                                                           Get.back();
          //                                                                         }
          //                                                                       },
          //                                                                       child: const Text(
          //                                                                           "OK"),
          //                                                                     ),
          //                                                                   ],
          //                                                                 ),
          //                                                               ),
          //                                                             );
          //                                                           },
          //                                                         );
          //                                                       }
          //                                                     }
          //                                                   },
          //                                                   child: const Text(
          //                                                     "Confirm",
          //                                                   ),
          //                                                 )
          //                                               ],
          //                                             );
          //                                           },
          //                                         );
          //                                       }
          //                                     },
          //                                     child: const Text(
          //                                       "Next",
          //                                     ),
          //                                   )
          //                                 ],
          //                               );
          //                             },
          //                           );
          //                         }
          //                       }
          //                     }
          //                   },
          //                 )
          //               : const Text(
          //                   "Returned",
          //                   style: TextStyle(
          //                       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          //                   textAlign: TextAlign.center,
          //                 ),
          //         ),
          //       )
          //     : const SizedBox(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*   Container(
                    padding: const EdgeInsets.fromLTRB(
                      44.0,
                      44.0,
                      44.0,
                      0,
                    ),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstant().baseColor.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'TaskId: ',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: taskDetailsController.taskDetailsData.value.taskId.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 12.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Invoice: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: taskDetailsController.taskDetailsData.value.soSystemNo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Destination: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: taskDetailsController.taskDetailsData.value.taskDestination,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Address: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: taskDetailsController
                                          .taskDetailsData.value.taskDestinationAddress ??
                                      "N/A",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
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
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "Are you sure that you want to start Task - Task # 3647?",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 12),
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
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStatePropertyAll(taskDetailsController
                                                  .taskDetailsData.value.taskStartTime ==
                                              null &&
                                          taskDetailsController.taskDetailsData.value.taskEndTime == null
                                      ? ColorConstant().baseColor
                                      : taskDetailsController.taskDetailsData.value.taskStartTime !=
                                                  null &&
                                              taskDetailsController.taskDetailsData.value.taskEndTime ==
                                                  null
                                          ? ColorConstant().baseColor.withOpacity(0.3)
                                          : ColorConstant().baseColor)),
                              child: Text(
                                taskDetailsController.taskDetailsData.value.taskStartTime == null &&
                                        taskDetailsController.taskDetailsData.value.taskEndTime == null
                                    ? "Start"
                                    : taskDetailsController.taskDetailsData.value.taskStartTime != null &&
                                            taskDetailsController.taskDetailsData.value.taskEndTime ==
                                                null
                                        ? "Started"
                                        : "",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/

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
                                              shape:
                                                  MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                              shape:
                                                  MaterialStateProperty.all<RoundedRectangleBorder>(
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
                              if (taskDetailsController
                                  .taskDetailsData.value.taskTransportationData!.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8))),
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
                              } else if (taskDetailsController
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
                                          .taskTransportationEndLat ==
                                      null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                              } else {
                                if (!taskDetailsController.verifyOtpStatus.value) {
                                  Get.to(() => const MobileNumberVerifyPage());
                                }
                              }
                            }
                            /*() async {
                              if (!await AuthController()
                                  .handleLocationPermission()) {
                                AuthController().logout();
                              } else {
                                if (taskDetailsController
                                            .taskDetailsData.value.taskStartTime ==
                                        null &&
                                    taskDetailsController
                                            .taskDetailsData.value.taskEndTime ==
                                        null) {
                                  popUpStatus(
                                    context,
                                    leadingIcon: Icons.error_outline,
                                    title: "Task isn't start yes!",
                                    subtitle:
                                        "Start your task first before going to checklist.",
                                    firstActionButtonTitle: "OK",
                                    firstActionButtonColor: const Color(0xFFed6c02),
                                  );
                                } else if (taskDetailsController.taskDetailsData.value
                                    .taskTransportationData!.isEmpty) {
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
                                                "Empty Transport!!",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "You havn't add any transport yet",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12),
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
                                                    shape: MaterialStateProperty.all<
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
                                                  "Okay",
                                                  style:
                                                      TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else if (taskDetailsController
                                            .taskDetailsData
                                            .value
                                            .taskTransportationData![
                                                taskDetailsController
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
                                            .taskTransportationData![
                                                taskDetailsController
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0.0))),
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "You have not clicked the reach button above!!",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
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
                                } else {
                                  taskDetailsController.otpTimeDuration.value == 120 && !taskDetailsController.verifyOtpStatus.value?
                                  Get.to(() => const MobileNumberVerifyPage()) : null;
                                }
                              }
                            }*/
                            ,
                            /*title: Row(
                              children: [
                                Text(
                                  taskDetailsController.verifyOtpStatus.value
                                      ? "Mobile number verified"
                                      : "Verify mobile number",
                                  style: TextStyle(
                                      color: taskDetailsController.verifyOtpStatus.value
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(Icons.error_outline)
                              ],
                            ),*/

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
                                    text: taskDetailsController.verifyOtpStatus.value
                                        ? "Mobile number verified"
                                        : "Verify mobile number",
                                    style: theme.textTheme.titleLarge!.copyWith(
                                        color: taskDetailsController.verifyOtpStatus.value
                                            ? Colors.white
                                            : ColorConstant.secondaryThemeColor)),
                                /*  if (!taskDetailsController.verifyOtpStatus.value)
                                  const WidgetSpan(child: SizedBox()),
                                if (taskDetailsController.verifyOtpStatus.value)
                                  const WidgetSpan(child: Icon(Icons.error_outline, color: ColorConstant.secondaryThemeColor,))*/
                              ]),
                            ),
                            trailing: taskDetailsController.verifyOtpStatus.value
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
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskDetailsController.checkListData.length,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      itemBuilder: (BuildContext context, int index) {
                        CheckList data = taskDetailsController.checkListData[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              data.title!,
                              style: theme.textTheme.bodyMedium,
                            ),
                            trailing: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: data.statusLsit![0].title == 'Pending'
                                        ? ColorConstant().baseColor
                                        : ColorConstant.green), // Add border for better visibility
                              ),
                              child: DropdownButton<StatusLsit>(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                value: data.statusLsit![0],
                                // Initial value
                                onChanged: !taskDetailsController.taskReturned.value
                                    ? (StatusLsit? newValue) async {
                                        if (!await AuthController().handleLocationPermission()) {
                                          AuthController().logout();
                                        } else {
                                          if (context.mounted) {
                                            if (newValue!.title == 'Complete') {
                                              if (taskDetailsController
                                                          .taskDetailsData.value.taskStartTime ==
                                                      null &&
                                                  taskDetailsController
                                                          .taskDetailsData.value.taskEndTime ==
                                                      null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      contentPadding:
                                                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(8))),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Icon(Icons.play_circle_outline, size: 80,
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
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
                                              } else if (taskDetailsController.taskDetailsData.value
                                                  .taskTransportationData!.isEmpty) {
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
                                                              "Empty Transport!!",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            Text(
                                                              "Ypu havn't add any transport yet",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 12),
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
                                                                  shape: MaterialStateProperty.all<
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
                                                                "Okay",
                                                                style:
                                                                    TextStyle(color: Colors.white),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else if (taskDetailsController
                                                          .taskDetailsData
                                                          .value
                                                          .taskTransportationData![
                                                              taskDetailsController
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
                                                          .taskTransportationData![
                                                              taskDetailsController
                                                                      .taskDetailsData
                                                                      .value
                                                                      .taskTransportationData!
                                                                      .length -
                                                                  1]
                                                          .taskTransportationEndLong ==
                                                      null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(8.0))),
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
                                              } else if (!taskDetailsController
                                                  .verifyOtpStatus.value) {
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
                                                            padding:
                                                                const EdgeInsets.only(left: 15),
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
                                                taskDetailsController.declearCheckListCompletion(
                                                  endPoint:
                                                      "${ApiUrl().declearCheckListCompletion}/${newValue.id}",
                                                );
                                              }
                                            }
                                          }
                                        }
                                      }
                                    : null,
                                underline: Container(),
                                items: data.statusLsit!
                                    .map<DropdownMenuItem<StatusLsit>>((StatusLsit value) {
                                  return DropdownMenuItem<StatusLsit>(
                                    value: value,
                                    child: Text(
                                      value.title!,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                          color: data.statusLsit![0].title == 'Pending'
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
                  /*if (_isReturnOptionVisible(taskDetailsController))
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Obx(
                          () => !taskDetailsController.taskReturned.value
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 64),
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: taskDetailsController.showReturnButton.value,
                                    onChanged: (value) {
                                      taskDetailsController.showReturnButton.value = value!;
                                    },
                                    title: taskDetailsController.showReturnButton.value
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              if (!await AuthController().handleLocationPermission()) {
                                                AuthController().logout();
                                              } else {
                                                if (context.mounted) {
                                                  if (taskDetailsController
                                                              .taskDetailsData.value.taskStartTime ==
                                                          null &&
                                                      taskDetailsController
                                                              .taskDetailsData.value.taskEndTime ==
                                                          null) {
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
                                                                    size: 80, color: Color(0xFFed6c02)
                                                                    // Color(0xFF9c27b0),
                                                                    ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                Text(
                                                                  "Task isn't start yes!",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                Text(
                                                                  "Start your task first before going to checklist.",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 12),
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
                                                                      shape: MaterialStateProperty.all<
                                                                          RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  0.0),
                                                                        ),
                                                                      ),
                                                                      backgroundColor:
                                                                          const MaterialStatePropertyAll(
                                                                              Color(0xFFed6c02))),
                                                                  child: const Text(
                                                                    "Ok",
                                                                    style:
                                                                        TextStyle(color: Colors.white),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (taskDetailsController.taskDetailsData.value
                                                      .taskTransportationData!.isEmpty) {
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
                                                                  "Empty Transport!!",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                Text(
                                                                  "You havn't add any transport yet",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 12),
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
                                                                      shape: MaterialStateProperty.all<
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
                                                                    "Okay",
                                                                    style:
                                                                        TextStyle(color: Colors.white),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (taskDetailsController
                                                              .taskDetailsData
                                                              .value
                                                              .taskTransportationData![
                                                                  taskDetailsController
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
                                                              .taskTransportationData![
                                                                  taskDetailsController
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
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(0.0))),
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
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                Text(
                                                                  "You have not clicked the reach button above!!",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 12),
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
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        taskDetailsController
                                                            .instructedNameTextEditingController
                                                            .clear();
                                                        taskDetailsController
                                                            .instructedReasonTextEditingController
                                                            .clear();
                                                        return AlertDialog(
                                                          backgroundColor: Colors.white,
                                                          shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8),
                                                            ),
                                                          ),
                                                          content: Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                              children: [
                                                                const Icon(
                                                                  Icons.error_outline,
                                                                  size: 80,
                                                                  color: Color(0xFFed6c02),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                const Text(
                                                                  "Who instructed to return product?",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                                TextFormField(
                                                                  readOnly: false,
                                                                  onTap: () {},
                                                                  controller: taskDetailsController
                                                                      .instructedNameTextEditingController,
                                                                  decoration: InputDecoration(
                                                                    labelText: "Name",
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          const BorderRadius.all(
                                                                              Radius.circular(10)),
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              ColorConstant().baseColor),
                                                                    ),
                                                                    border: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(12.0)),
                                                                    ),
                                                                    focusedBorder:
                                                                        const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(12.0)),
                                                                      borderSide: BorderSide(
                                                                          color: Colors.purple,
                                                                          width: 0.5),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                Get.back();
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius.circular(
                                                                                          0.0))),
                                                                      content: SizedBox(
                                                                        height: 180,
                                                                        child: Column(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.error_outline,
                                                                              size: 80,
                                                                              color: Color(0xFFed6c02),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 16,
                                                                            ),
                                                                            const Text(
                                                                              "Reason",
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontWeight:
                                                                                      FontWeight.bold,
                                                                                  fontSize: 16),
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                            ),
                                                                            TextFormField(
                                                                              readOnly: false,
                                                                              // onTap: () {},
                                                                              controller:
                                                                                  taskDetailsController
                                                                                      .instructedReasonTextEditingController,
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                labelText: "Reason",
                                                                                enabledBorder:
                                                                                    OutlineInputBorder(
                                                                                  borderRadius:
                                                                                      const BorderRadius
                                                                                          .all(Radius
                                                                                              .circular(
                                                                                                  10)),
                                                                                  borderSide: BorderSide(
                                                                                      color:
                                                                                          ColorConstant()
                                                                                              .baseColor),
                                                                                ),
                                                                                border:
                                                                                    const OutlineInputBorder(
                                                                                  borderRadius:
                                                                                      BorderRadius.all(
                                                                                          Radius
                                                                                              .circular(
                                                                                                  12.0)),
                                                                                ),
                                                                                focusedBorder:
                                                                                    const OutlineInputBorder(
                                                                                  borderRadius:
                                                                                      BorderRadius.all(
                                                                                          Radius
                                                                                              .circular(
                                                                                                  12.0)),
                                                                                  borderSide:
                                                                                      BorderSide(
                                                                                          color: Colors
                                                                                              .purple,
                                                                                          width: 0.5),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        ElevatedButton(
                                                                          onPressed: () async {
                                                                            Map<String,
                                                                                    dynamic>? response =
                                                                                await taskDetailsController.returnTask(
                                                                                    endPoint: ApiUrl()
                                                                                        .returnTask,
                                                                                    taskIdForReturn:
                                                                                        taskDetailsController
                                                                                            .taskDetailsData
                                                                                            .value
                                                                                            .taskId
                                                                                            .toString());

                                                                            if (response != {}) {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    shape:
                                                                                        const RoundedRectangleBorder(
                                                                                      borderRadius:
                                                                                          BorderRadius
                                                                                              .all(
                                                                                        Radius.circular(
                                                                                            0.0),
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
                                                                                          ? Colors.green
                                                                                          : Colors.red,
                                                                                      size: 44,
                                                                                    ),
                                                                                    content: Text(
                                                                                      "${response['data']}",
                                                                                      style: const TextStyle(
                                                                                          color: Colors
                                                                                              .black,
                                                                                          fontWeight:
                                                                                              FontWeight
                                                                                                  .bold,
                                                                                          fontSize: 16),
                                                                                      textAlign:
                                                                                          TextAlign
                                                                                              .center,
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            }
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
                                                                                          0xFFed6c02))),
                                                                          child: const Text(
                                                                            "Confirm",
                                                                            style: TextStyle(
                                                                                color: Colors.white),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                );
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
                                                                "Next",
                                                                style: TextStyle(color: Colors.white),
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
                                            child: const Text("Return"))
                                        : Text(
                                            !taskDetailsController.taskReturned.value
                                                ? "Return"
                                                : "Returned",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                )
                              : const Text(
                                  "Returned",
                                  style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  convertStatus(
      UpActivityTaskController taskDetailsController, List<TaskChecklistsData>? checkList) {
    taskDetailsController.checkListData.clear();
    for (int i = 0; i < checkList!.length; i++) {
      if (checkList[i].checklistCompletionStatus == 0) {
        taskDetailsController.checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusLsit(title: "Pending", id: checkList[i].taskChecklistAutoId.toString()),
            StatusLsit(title: "Complete", id: checkList[i].taskChecklistAutoId.toString()),
          ]),
        );
      } else {
        taskDetailsController.checkListData.add(
          CheckList(title: checkList[i].taskChecklistName, statusLsit: [
            StatusLsit(title: "Completed", id: checkList[i].taskChecklistAutoId.toString())
          ]),
        );
      }
    }
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
