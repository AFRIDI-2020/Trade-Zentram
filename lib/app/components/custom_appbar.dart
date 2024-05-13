import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final List<VoidCallback>? onTapList;
  final String? toPage;
  final VoidCallback? onBackTap;
  final String? pageTitle;
  final List<Widget>? actions;
  final Color? appBarBgColor;

  const CustomAppBar(
      {super.key,
      this.onTapList,
      this.toPage,
      this.onBackTap,
      this.pageTitle,
      this.actions,
      this.appBarBgColor});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    // final taskDetailsController = Get.put(TaskDetailsController());

    return AppBar(
      iconTheme: IconThemeData(color: ColorConstant().baseColor),
      // centerTitle: true,
      // elevation: 10,
      surfaceTintColor: Colors.transparent,
      leadingWidth: toPage == "Home" ? 4 : null,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black,
      automaticallyImplyLeading: false,
      backgroundColor: appBarBgColor,
      //backgroundColor: ColorConstant().baseColor,
      leading: InkWell(
        onTap: toPage == "Home"
            ? () {
                //Get.to(() => HomePage());
                //Scaffold.of(context).openDrawer();
              }
            : onBackTap ??
                () async {
                  authController.oldPasswordTextEditingController.value.clear();
                  authController.newPasswordTextEditingController.value.clear();
                  authController.confirmNewPasswordTextEditingController.value.clear();

                  authController.oldPasswordValidate.value = "";
                  authController.newPasswordValidate.value = "";
                  authController.confirmPasswordValidate.value = "";
                  if (!await authController.handleLocationPermission()) {
                    authController.logout();
                  } else {
                    Get.back();
                  }
                },
        child: toPage == "Home"
            ? null
            : const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              ),
      ),
      title: toPage == "Home"
          ? Stack(
              children: [
                Image.asset(
                  'assets/logo.png', // Replace 'image.png' with your image asset path

                  height: 50, // Set height of the image
                  // fit: BoxFit.cover,
                ),
                // Positioned.fill(
                //   top: 30,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //           color: const Color.fromRGBO(158, 158, 158, 1)
                //               .withOpacity(0.5), // Set shadow color
                //           spreadRadius: 2, // Set spread radius
                //           blurRadius: 2, // Set blur radius
                //           offset: const Offset(0, 3), // Set shadow offset
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.5), // Set shadow color
                //         spreadRadius: 1, // Set spread radius
                //         blurRadius: 1, // Set blur radius
                //         offset: Offset(0, 0), // Set shadow offset
                //       ),
                //     ],
                //   ),
                //   child: Image.asset(
                //     "assets/logo.png",
                //     height: 30,
                //     width: 50,
                //   ),
                // ),
              ],
            )
          : Text(
              pageTitle ?? "",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
      actions: actions ??
          (toPage == "Home"
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: PopupMenuButton(
                      color: ColorConstant().baseColor,
                      elevation: 50,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      offset: const Offset(0, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      shadowColor: Colors.grey,
                      icon: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstant().baseColor,
                        ),
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person,
                          color: ColorConstant.secondaryThemeColor,
                        ),
                      ),
                      // child: const Padding(
                      //   padding: EdgeInsets.only(
                      //     right: 10,
                      //   ),
                      //   child: Icon(
                      //     Icons.person,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            // onTap: onTapList![0],
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${authController.userProfile.value.userFullName}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Role: ${authController.userProfile.value.roleName}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: onTapList![0],
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey, width: 1),
                                              borderRadius: BorderRadius.circular(15)),
                                          height: 30,
                                          width: 140,
                                          child: const Center(
                                              child: Text(
                                            "Change Password",
                                            style: TextStyle(color: Colors.black),
                                          ))),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: onTapList![1],
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.grey, width: 1),
                                              borderRadius: BorderRadius.circular(15)),
                                          height: 30,
                                          width: 80,
                                          child: const Center(
                                              child: Text(
                                            "Logout",
                                            style: TextStyle(color: Colors.black),
                                          ))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // PopupMenuItem(
                          //   onTap: onTapList![0],
                          //   child: const Text("Logout"),
                          // )
                        ];
                      },
                    ),
                  )
                ]
              : toPage == "UpActivityTaskPage"
                  ? [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Task Details",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    ]
                  : toPage == "CheckListPage"
                      ? [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              "CheckList",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )
                        ]
                      : toPage == "MobileNumberVerifyPage"
                          ? [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "Otp",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              )
                            ]
                          : toPage == "UpdatePasswordPage"
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Update Password",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  )
                                ]
                              : toPage == "DownActivityPage"
                                  ? [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          "Down Activity",
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      )
                                    ]
                                  : []),
    );
  }
}
