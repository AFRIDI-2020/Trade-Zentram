import 'package:TradeZentrum/app/model/get_tasks_model.dart';
import 'package:TradeZentrum/app/screens/connectivity/internet_connectivity.dart';
import 'package:TradeZentrum/app/screens/home/widgets/task_list_item_view.dart';
import 'package:TradeZentrum/app/screens/upActivityTask/up_activity_task_page.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/controller/home_controller.dart';

import 'package:TradeZentrum/app/screens/update_password_page.dart';

class HomePage extends GetView<HomeController> {
  final String title = "DashBoard";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final authController = Get.put(AuthController());

    Future<void> onRefresh() async {
      homeController.getTasks(endPoint: ApiUrl().getTasks);
    }

    return DoubleTapToExit(
      snackBar: const SnackBar(
        content: Text('Tap again to exit !'),
      ),
      child: InternetConnectivity(
        child: Scaffold(
          backgroundColor: ColorConstant.primaryBackground,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: CustomAppBar(
                toPage: "Home",
                onTapList: [
                  () => Get.off(
                        routeName: "homePage",
                        () => const UpdatePasswordPage(
                          title: "Change Password",
                        ),
                      ),
                  () => authController.logout()
                ],
              )),
         /* drawer: Obx(
            () => Drawer(
                backgroundColor: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).padding.top,
                        color: ColorConstant().baseColor.withOpacity(0.3),
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: ColorConstant().baseColor.withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${authController.userProfile.value.userFullName}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${authController.userProfile.value.userEmail}",
                                  style: const TextStyle(fontWeight: FontWeight.normal),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 44.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.password),
                          title: const Text("Change Password"),
                          onTap: () {
                            Get.to(() => UpdatePasswordPage(title: title));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 44.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          onTap: () {
                            authController.logout();
                          },
                        ),
                      ),
                      // ListTile(
                      //   leading: const Icon(Icons.home),
                      //   title:
                      //       Text("${authController.userProfile.value.roleName}"),
                      //   onTap: () {
                      //     log("ListTile Pressed");
                      //   },
                      // ),
                      //  ListTile(leading: Icon(Icons.home),title:  Text("${authController.userProfile.value.userEmail}"),),
                      //   ListTile(leading: Icon(Icons.home),title:  Text("${authController.userProfile.value.userEmail}"),),
                      // Text("${authController.userProfile.value.userEmail}"),
                      // Text("${authController.userProfile.value.userFullName}"),
                      // Text("${authController.userProfile.value.roleName}")
                    ])),
          ),*/
          body: Obx(() => homeController.taskDataList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () => onRefresh(),
                  child: LayoutBuilder(builder: (context, constrain) {
                    return ListView.builder(
                        shrinkWrap: false,
                        itemCount: homeController.taskDataList.length,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        itemBuilder: (context, index) {
                          TaskData taskData = homeController.taskDataList[index];
                          return InkWell(
                            onTap: () async {
                              /* // taskDetailsController.taskId.value =
                              //     taskData.taskId.toString();
                              if (!await authController.handleLocationPermission()) {
                                authController.logout();
                                // Get.to(() => const LoginPage());
                              } else {
                                Get.to(() => const UpActivityTaskPage(),
                                    arguments: taskData.taskId.toString());
                              }*/
                              print("deleting home controller");
                              await Get.delete<HomeController>();
                              await Get.to(() => InternetConnectivity(child: UpActivityTaskPage(pageTitle: "Task #${taskData.taskId}",)),
                                  preventDuplicates: false, arguments: taskData.taskId.toString());
                            },
                            /* child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          taskData.taskName ?? "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
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
                                                      text: taskData.soSystemNo,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
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
                                                      text: taskData
                                                              .taskDestination ??
                                                          "N/A",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
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
                                                      text: taskData
                                                              .taskDestinationAddress ??
                                                          "N/A",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  // const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: taskData.taskStartTime == null &&
                                                  taskData.taskEndTime == null
                                              ? ColorConstant().baseColor
                                              : taskData.taskStartTime != null &&
                                                      taskData.taskEndTime == null
                                                  ? ColorConstant()
                                                      .baseColor
                                                      .withOpacity(0.5)
                                                  : ColorConstant().baseColor,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.height / 20,
                                      child: Center(
                                        child: Text(
                                          taskData.taskStartTime == null &&
                                                  taskData.taskEndTime == null
                                              ? "Start"
                                              : taskData.taskStartTime != null &&
                                                      taskData.taskEndTime == null
                                                  ? "Started"
                                                  : "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: taskData.taskStartTime !=
                                                        null &&
                                                    taskData.taskEndTime != null
                                                ? Colors.white
                                                : Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),*/
                            child: TaskListItemView(
                              taskData: taskData,
                            ),
                          );
                        });
                  }),
                )
              : !homeController.isFetchTaskData.value
                  ? const SizedBox.shrink()
                  : RefreshIndicator(
                      onRefresh: () => onRefresh(),
                      child: ListView(
                        shrinkWrap: false,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(44.0),
                            child: Center(
                              child: SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: const Card(
                                  child: Center(child: Text("NO TASKS FOR NOW!")),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}
