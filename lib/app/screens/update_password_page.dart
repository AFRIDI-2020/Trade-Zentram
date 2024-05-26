import 'dart:developer';
import 'package:TradeZentrum/app/screens/connectivity/internet_connectivity.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';

class UpdatePasswordPage extends GetView<AuthController> {
  final String title;
  const UpdatePasswordPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        authController.oldPasswordTextEditingController.value.clear();
        authController.newPasswordTextEditingController.value.clear();
        authController.confirmNewPasswordTextEditingController.value.clear();

        authController.oldPasswordValidate.value = "";
        authController.newPasswordValidate.value = "";
        authController.confirmPasswordValidate.value = "";
        Get.back();
      },
      child: InternetConnectivity(
        child: Scaffold(
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: CustomAppBar(
                  toPage: "UpdatePasswordPage",
                )),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Old Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: authController
                                .oldPasswordTextEditingController.value,
                            //cursorHeight: 16,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                            cursorColor: Colors.black,
                            obscureText: false,
                            onChanged: (value) {
                              if (value.length >= 2) {
                                authController.oldPasswordValidate.value = "true";
                              } else {
                                if (value == "") {
                                  authController.oldPasswordValidate.value =
                                      "null";
                                } else {
                                  authController.oldPasswordValidate.value =
                                      "false";
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your old Password",
                              fillColor: const Color(0xFFE8F0FE),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: /*authController.oldPasswordValidate.value !=
                                          "das"
                                      ? */
                                      Colors.grey.withOpacity(
                                          0.2) /*: Colors.red.withOpacity(0.2)*/,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                authController.oldPasswordValidate.value == "true"
                                    ? false
                                    : true,
                            child: Text(
                              authController.oldPasswordValidate.value == "false"
                                  ? "Old password must be at least 2 characters"
                                  : authController.oldPasswordValidate.value ==
                                          "null"
                                      ? "Please enter your password"
                                      : authController
                                                  .oldPasswordValidate.value ==
                                              "Old Password does not match!"
                                          ? authController
                                              .oldPasswordValidate.value
                                          : "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                            child: RichText(
                              text: const TextSpan(
                                text: 'New Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: authController
                                .newPasswordTextEditingController.value,
                            //cursorHeight: 16,
                            obscureText: false,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              RegExp passwordRegex = RegExp(passwordPattern);
                              if (passwordRegex.hasMatch(value)) {
                                authController.newPasswordValidate.value = "true";
                              } else {
                                if (value == "") {
                                  authController.newPasswordValidate.value =
                                      "null";
                                } else {
                                  authController.newPasswordValidate.value =
                                      "false";
                                }
                              }
                            },
                            decoration: InputDecoration(
                              // suffix: InkWell(
                              //   onTap: () =>
                              //       eyeVisibility.value = !eyeVisibility.value,
                              //   child: Icon(eyeVisibility.value
                              //       ? Icons.visibility
                              //       : Icons.visibility_off),
                              // ),
                              hintText: "Enter your new password",
                              fillColor: const Color(0xFFE8F0FE),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: /*authController.newPasswordValidate.value ==
                                              "true" ||

                                      ?*/
                                      Colors.grey.withOpacity(
                                          0.2) /*: Colors.red.withOpacity(0.2)*/,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                authController.newPasswordValidate.value == "true"
                                    ? false
                                    : true,
                            child: Text(
                              authController.newPasswordValidate.value == "false"
                                  ? "must contain atleaset a number, an uppercase letter and any symbol(!#\$%&'()*+,-./:;<=>?@[]^_`{|}~)"
                                  : authController.newPasswordValidate.value ==
                                          "null"
                                      ? "Please enter your new password"
                                      : "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Confirm Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: authController
                                .confirmNewPasswordTextEditingController.value,
                            //cursorHeight: 16,
                            obscureText: false,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              if (value == "") {
                                authController.confirmPasswordValidate.value =
                                    "null";
                              } else {
                                authController.newPasswordTextEditingController
                                            .value.text !=
                                        authController
                                            .confirmNewPasswordTextEditingController
                                            .value
                                            .text
                                    ? authController
                                        .confirmPasswordValidate.value = "miss"
                                    : authController
                                        .confirmPasswordValidate.value = "same";
                              }
                            },
                            decoration: InputDecoration(
                              // suffix: InkWell(
                              //   onTap: () =>
                              //       eyeVisibility.value = !eyeVisibility.value,
                              //   child: Icon(eyeVisibility.value
                              //       ? Icons.visibility
                              //       : Icons.visibility_off),
                              // ),
                              hintText: "Enter your password again",
                              fillColor: const Color(0xFFE8F0FE),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: /*authController
                                              .confirmPasswordValidate.value ==
                                          "true"
                                      ?*/
                                      Colors.grey.withOpacity(
                                          0.2) /*: Colors.red.withOpacity(0.2)*/,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                authController.confirmPasswordValidate.value ==
                                            "null" ||
                                        authController
                                                .confirmPasswordValidate.value ==
                                            "miss"
                                    ? true
                                    : false,
                            child: Text(
                              authController.confirmPasswordValidate.value ==
                                      "null"
                                  ? "Confirm password is a required field"
                                  : authController
                                              .confirmPasswordValidate.value ==
                                          "miss"
                                      ? "Password must match"
                                      : "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 16,
                    ),
                    InkWell(
                      onTap: () {
                        if (authController.oldPasswordTextEditingController.value.text != "" &&
                            authController.newPasswordTextEditingController.value
                                    .text !=
                                "" &&
                            authController.confirmNewPasswordTextEditingController
                                    .value.text !=
                                "" &&
                            authController.oldPasswordValidate.value != "null" &&
                            authController.newPasswordValidate.value != "null" &&
                            authController.confirmPasswordValidate.value ==
                                "same") {
                          authController.updatePassword(
                            context,
                            endPoint: ApiUrl().updatePasswordUrl,
                          );
                        } else {
                          authController.oldPasswordValidate.value = "null";
                          authController.newPasswordValidate.value = "null";
                          authController.confirmPasswordValidate.value = "null";
                          authController.oldPasswordTextEditingController.value
                              .clear();
                          authController.newPasswordTextEditingController.value
                              .clear();
                          authController
                              .confirmNewPasswordTextEditingController.value
                              .clear();
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorConstant().baseColor,
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 20,
                          child: const Center(
                              child: Text(
                            "Update Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ))),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
