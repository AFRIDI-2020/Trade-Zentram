import 'dart:developer';
import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/controller/up_activity_task_controller.dart';
import 'package:TradeZentrum/app/dialogs/location_arrival_confirmation_dialog.dart';
import 'package:TradeZentrum/app/dialogs/missed_end_location_dialog.dart';
import 'package:TradeZentrum/app/dialogs/start_task_dialog.dart';
import 'package:TradeZentrum/app/dialogs/task_not_started_dialog.dart';
import 'package:TradeZentrum/app/model/locations_model.dart';
import 'package:TradeZentrum/app/model/vehicles_model.dart';
import 'package:TradeZentrum/app/screens/checklist_page.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/widgets/task_detail_widget.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/widgets/transport_list_item.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/task_details_model.dart';

class UpActivityTaskPage extends GetView<UpActivityTaskController> {
  final String pageTitle;

  const UpActivityTaskPage({
    super.key,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final taskDetailsController = Get.put(UpActivityTaskController());

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
          Get.back(result: true);
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: CustomAppBar(
            toPage: "UpActivityTaskPage",
            pageTitle: pageTitle,
            actions: [
              InkWell(
                onTap: () async {
                  AuthController authController = AuthController();
                  if (!await authController.checkLocationStatus()) {
                    authController.logout();
                  } else {
                    taskDetailsController.taskDetailsData.value
                            .taskChecklistsData!.isNotEmpty
                        ? await Get.to(() => CheckListPage(
                              pageTitle: pageTitle,
                            ))
                        : null;
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
                    Icons.list,
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
        body: Obx(
          () {

            String? taskStartTime = taskDetailsController.taskDetailsData.value.taskStartTime;
            String? taskEndTime = taskDetailsController.taskDetailsData.value.taskEndTime;
            List<TaskTransportationData>? taskTransportations = taskDetailsController.taskDetailsData.value.taskTransportationData ?? [];
            return Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Task Details -->
                  TaskDetailWidget(
                    taskDetailsData: taskDetailsController.taskDetailsData.value,
                    onPlayPauseButtonTap: () {
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Up Activity",
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),

                      /// Add Transport -->

                      ElevatedButton(
                        onPressed: () {
                          addTransport(taskEndTime, taskStartTime, context,
                              taskTransportations, taskDetailsController, theme);
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
                      )
                    ],
                  ),

                  /// Transportation List -->
                  if (taskTransportations.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: taskTransportations.length,
                        itemBuilder: (context, index) {
                          TaskTransportationData transport =
                          taskTransportations[index];
                          return TransportListItem(
                            onSelected: (String value) async {
                              await _onOptionSelect(value, context,
                                  taskDetailsController, index, theme);
                            },
                            taskTransportationData: transport,
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onOptionSelect(
      String value,
      BuildContext context,
      UpActivityTaskController taskDetailsController,
      int index,
      ThemeData theme) async {
    bool isLocationEnabled = await AuthController().checkLocationStatus();
    TaskTransportationData transport = taskDetailsController
        .taskDetailsData.value.taskTransportationData![index];
    switch (value) {
      case 'Edit':
        if (!isLocationEnabled) {
          AuthController().logout();
        } else {
          if (context.mounted) {
            showModal(
              context,
              taskDetailsController,
              true,
              from: transport.taskTransportationStartLocation,
              to: transport.taskTransportationEndLocation,
              vehicle: transport.vehicleName,
              vehicleId: transport.vehicleId.toString(),
              autoId: transport.taskTransportationAutoId.toString(),
              fare: transport.taskTransportationCost.toString(),
              remark: transport.taskTransportationRemarks,
              theme: theme,
            );
          }
        }
        break;
      case 'Delete':
        if (!isLocationEnabled) {
          AuthController().logout();
        } else {
          if (context.mounted) {
            taskDetailsController.deleteTransport(
              endPoint: ApiUrl().deleteTransportation,
              taskTransportationAutoId:
                  transport.taskTransportationAutoId.toString(),
              taskId: taskDetailsController.taskId.value,
            );
          }
        }

        break;
      case 'Reached':
        if (!isLocationEnabled) {
          AuthController().logout();
        } else {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LocationArrivalConfirmationDialog(
                  onNoButtonPressed: () {
                    Get.back();
                  },
                  onYesButtonPressed: () {
                    taskDetailsController.reachedTransport(
                      endPoint: ApiUrl().reachLocation,
                      taskId: taskDetailsController.taskId.value,
                      taskTransportationAutoId:
                          transport.taskTransportationAutoId.toString(),
                      taskTransportationEndLocation:
                          transport.taskTransportationEndLocation,
                    );
                    Get.back();
                  },
                );
              },
            );
          }
        }

        break;
    }
  }

  void addTransport(
      String? taskEndTime,
      String? taskStartTime,
      BuildContext context,
      List<TaskTransportationData> taskTransportations,
      UpActivityTaskController taskDetailsController,
      ThemeData theme) {

    if (taskEndTime == null && taskStartTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskNotStartedDialog(
            onOkayButtonPressed: () {
              Get.back();
            },
            warningText: "You must have to click the start button and then you can click ADD TRANSPORT!",
          );
        },
      );
    } else if (taskTransportations.isEmpty) {
      showModal(context, taskDetailsController, false, theme: theme);
    } else if (taskTransportations.isNotEmpty &&
        (taskTransportations[taskTransportations.length - 1]
                    .taskTransportationEndLat !=
                null &&
            taskTransportations[taskTransportations.length - 1]
                    .taskTransportationEndLong !=
                null)) {
      showModal(context, taskDetailsController, false, theme: theme);
    } else {
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
    }
  }

  showModal(BuildContext context,
      UpActivityTaskController taskDetailsController, bool edit,
      {String? from,
      String? to,
      String? vehicle,
      String? vehicleId,
      String? fare,
      String? remark,
      String? autoId,
      required ThemeData theme}) {
    log(
      "$from ,$to, $vehicle, $fare, $remark, $vehicleId",
    );
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Add Transport', style: theme.textTheme.titleLarge),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            taskDetailsController.searchFromController.clear();
                            taskDetailsController.searchToController.clear();
                            taskDetailsController.searchVehicleController
                                .clear();
                            taskDetailsController.fareTextEditingController
                                .clear();
                            taskDetailsController.remarkTextEditingController
                                .clear();
                            taskDetailsController.fareCloseIcon.value = false;
                            taskDetailsController.remarkCloseIcon.value = false;
                            taskDetailsController.showFromValidate.value =
                                "false";
                            taskDetailsController.showToValidate.value =
                                "false";
                            taskDetailsController.showVehicleValidate.value =
                                "false";
                            taskDetailsController.showFareValidate.value =
                                "false";
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
                      searchController:
                          taskDetailsController.searchFromController,
                      viewHintText:
                          taskDetailsController.searchFromController.text,
                      viewOnChanged: (value) {
                        taskDetailsController.filterFromLocations(value);
                        mystate(() {
                          taskDetailsController.showFromValidate.value =
                              "false";
                        });
                      },
                      viewTrailing: [
                        IconButton(
                            onPressed: () {
                              mystate(() {
                                taskDetailsController.searchFromController
                                    .clear();
                                taskDetailsController
                                    .filteredFromLocationsList.value = [];
                                taskDetailsController.searchFromController
                                    .closeView("");
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: ColorConstant().baseColor),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 0.5),
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
                                      ? taskDetailsController
                                          .formLocationDetailsList.length
                                      : taskDetailsController
                                          .filteredFromLocationsList.length,
                                  itemBuilder: (context, index) {
                                    LocationDetails location =
                                        taskDetailsController
                                                .filteredFromLocationsList
                                                .isEmpty
                                            ? taskDetailsController
                                                .formLocationDetailsList[index]
                                            : taskDetailsController
                                                    .filteredFromLocationsList[
                                                index];

                                    return InkWell(
                                      onTap: () {
                                        // taskDetailsController
                                        //         .filteredFromLocationsList =
                                        //     taskDetailsController.locations;
                                        taskDetailsController
                                            .searchFromController
                                            .closeView(location.locationName);
                                      },
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                    visible: taskDetailsController.showFromValidate.value ==
                                "true" &&
                            taskDetailsController.searchFromController.text ==
                                ""
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
                      searchController:
                          taskDetailsController.searchToController,
                      viewHintText:
                          taskDetailsController.searchToController.text,
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
                                taskDetailsController.searchToController
                                    .clear();
                                // taskDetailsController
                                //         .filteredToLocationsList =
                                //     taskDetailsController.locations;
                                taskDetailsController.searchToController
                                    .closeView("");
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: ColorConstant()
                                      .baseColor), // Change underline color here
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 0.5),
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
                                  itemCount: taskDetailsController
                                          .filteredToLocationsList.isEmpty
                                      ? taskDetailsController
                                          .toLocationDetailsList.length
                                      : taskDetailsController
                                          .filteredToLocationsList.length,
                                  itemBuilder: (context, index) {
                                    LocationDetails location =
                                        taskDetailsController
                                                .filteredToLocationsList.isEmpty
                                            ? taskDetailsController
                                                .toLocationDetailsList[index]
                                            : taskDetailsController
                                                .filteredToLocationsList[index];
                                    return SizedBox(
                                      height: 50,
                                      child: InkWell(
                                        onTap: () {
                                          taskDetailsController
                                              .searchToController
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
                    visible: taskDetailsController.showToValidate.value ==
                                "true" &&
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
                      searchController:
                          taskDetailsController.searchVehicleController,
                      viewHintText:
                          taskDetailsController.searchVehicleController.text,
                      viewOnChanged: (value) {
                        taskDetailsController.filterVehicles(value);
                        mystate(() {
                          taskDetailsController.showVehicleValidate.value =
                              "false";
                        });
                      },
                      viewTrailing: [
                        IconButton(
                            onPressed: () {
                              mystate(() {
                                taskDetailsController.searchVehicleController
                                    .clear();

                                taskDetailsController.searchVehicleController
                                    .closeView("");
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: ColorConstant().baseColor),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 0.5),
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
                                  itemCount: taskDetailsController
                                          .filteredVechileList.isEmpty
                                      ? taskDetailsController
                                          .vehiclesList.length
                                      : taskDetailsController
                                          .filteredVechileList.length,
                                  itemBuilder: (context, index) {
                                    VehicleData vehicle = taskDetailsController
                                            .filteredVechileList.isEmpty
                                        ? taskDetailsController
                                            .vehiclesList[index]
                                        : taskDetailsController
                                            .filteredVechileList[index];
                                    return InkWell(
                                      onTap: () {
                                        taskDetailsController.selectedVehicleId
                                            .value = vehicle.key ?? 0;
                                        taskDetailsController
                                            .searchVehicleController
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
                    visible: taskDetailsController.showVehicleValidate.value ==
                                "true" &&
                            taskDetailsController
                                    .searchVehicleController.text ==
                                ""
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
                      if (taskDetailsController
                              .fareTextEditingController.text !=
                          "") {
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
                                  taskDetailsController
                                      .fareTextEditingController
                                      .clear();
                                  taskDetailsController.fareCloseIcon.value =
                                      false;
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: ColorConstant().baseColor),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.purple, width: 0.5),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: taskDetailsController.showFareValidate.value ==
                                "true" &&
                            taskDetailsController
                                    .fareTextEditingController.text ==
                                ""
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
                    controller:
                        taskDetailsController.remarkTextEditingController,
                    onTap: () {
                      taskDetailsController.remarkCloseIcon.value = true;
                    },
                    onChanged: (value) {
                      if (taskDetailsController
                              .remarkTextEditingController.text !=
                          "") {
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
                                  taskDetailsController
                                      .remarkTextEditingController
                                      .clear();
                                  taskDetailsController.remarkCloseIcon.value =
                                      false;
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: ColorConstant()
                                .baseColor), // Change underline color here
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide:
                            BorderSide(color: Colors.purple, width: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: !edit
                        ? () async {
                            AuthController authController =
                                Get.put(AuthController());
                            if (taskDetailsController
                                        .searchFromController.text !=
                                    "" &&
                                taskDetailsController.searchToController.text !=
                                    "" &&
                                taskDetailsController
                                        .searchVehicleController.text !=
                                    "" &&
                                taskDetailsController
                                        .fareTextEditingController.text !=
                                    "") {
                              if (!await authController.checkLocationStatus()) {
                                authController.logout();
                              } else {
                                taskDetailsController.addTransport();
                                Get.back();
                              }
                            } else {
                              mystate(() {
                                taskDetailsController.showFromValidate.value =
                                    "true";
                                taskDetailsController.showToValidate.value =
                                    "true";
                                taskDetailsController
                                    .showVehicleValidate.value = "true";
                                taskDetailsController.showFareValidate.value =
                                    "true";
                              });
                            }
                          }
                        : () async {
                            AuthController authController =
                                Get.put(AuthController());

                            var request = {
                              // "taskId": taskDetailsController.taskId.value,
                              "taskTransportationAutoId": autoId ?? "",
                              "taskTransportationCost": taskDetailsController
                                          .fareTextEditingController.text ==
                                      ""
                                  ? fare
                                  : taskDetailsController
                                      .fareTextEditingController.text,
                              "taskTransportationEndLat": null,
                              "taskTransportationEndLocation":
                                  taskDetailsController
                                              .searchToController.text ==
                                          ""
                                      ? to
                                      : taskDetailsController
                                          .searchToController.text,
                              "taskTransportationEndLong": null,
                              "taskTransportationRemarks": taskDetailsController
                                          .remarkTextEditingController.text ==
                                      ""
                                  ? remark
                                  : taskDetailsController
                                      .remarkTextEditingController.text,
                              "taskTransportationStartLat":
                                  authController.latitude.value,
                              "taskTransportationStartLocation":
                                  taskDetailsController
                                              .searchFromController.text ==
                                          ""
                                      ? from
                                      : taskDetailsController
                                          .searchFromController.text,
                              "taskTransportationStartLong":
                                  authController.longitude.value,
                              "taskTransportationVehicleId":
                                  taskDetailsController
                                              .selectedVehicleId.value ==
                                          0
                                      ? vehicleId
                                      : taskDetailsController
                                          .selectedVehicleId.value,
                              "taskTransporationWayStatus": 0
                            };
                            if (!await authController.checkLocationStatus()) {
                              authController.logout();
                            } else {
                              taskDetailsController.editTransport(
                                  endPoint: ApiUrl().updateTransportation,
                                  data: request);
                              Get.back();
                            }
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          !edit ? "Add" : "Update",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 500,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  double listHeightChanging(UpActivityTaskController taskDetailsController) {
    double intHeight = 85;
    double totalHeight = 0;
    if (taskDetailsController
        .taskDetailsData.value.taskTransportationData!.isNotEmpty) {
      for (int i = 1;
          i <=
              taskDetailsController
                  .taskDetailsData.value.taskTransportationData!.length;
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
}
