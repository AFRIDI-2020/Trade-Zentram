import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';
import 'package:TradeZentrum/app/services/api_env.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return DoubleTapToExit(
      snackBar: const SnackBar(
        content: Text('Tap again to exit !'),
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            alignment: Alignment.topLeft,
                            "assets/logo.png",
                            height: 50,
                            width: 80,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Sign in to your account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0.0, 8, 8, 8),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Username',
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
                                      .emailTextEditingController.value,
                                  // cursorHeight: 18,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  cursorColor: Colors.black,
                                  onChanged: (value) {
                                    if (value == "") {
                                      authController.userNameValidate.value =
                                          "null";
                                    } else {
                                      authController.userNameValidate.value = "";
                                      authController.wrongUserName.value = "";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "username",
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
                                        color: authController
                                                    .userNameValidate.value !=
                                                "null"
                                            ? Colors.grey.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      authController.userNameValidate.value ==
                                              "null"
                                          ? true
                                          : false,
                                  child: Text(
                                    authController.userNameValidate.value ==
                                            "null"
                                        ? "Please enter your username"
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      authController.wrongUserName.value != ""
                                          ? true
                                          : false,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      authController.wrongUserName.value,
                                      style: const TextStyle(color: Colors.red),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0.0, 8, 8, 8),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Password',
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
                                      .passwordTextEditingController.value,
                                  // cursorHeight: 16,
                                  obscureText:
                                      !authController.eyeVisibility.value,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  cursorColor: Colors.black,
                                  onChanged: (value) {
                                    if (value == "") {
                                      authController.userPasswordValidate.value =
                                          "null";
                                    } else {
                                      authController.userPasswordValidate.value =
                                          "";
                                      authController.wrongPassword.value = "";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () =>
                                          authController.eyeVisibility.value =
                                              !authController.eyeVisibility.value,
                                      child: Icon(
                                          authController.eyeVisibility.value
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                    ),
                                    hintText: "userPassword",
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
                                        color: authController
                                                    .userPasswordValidate.value !=
                                                "null"
                                            ? Colors.grey.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      authController.userPasswordValidate.value ==
                                              "null"
                                          ? true
                                          : false,
                                  child: Text(
                                    authController.userPasswordValidate.value ==
                                            "null"
                                        ? "Please enter your password"
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: authController.wrongPassword != ""
                                      ? true
                                      : false,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      authController.wrongPassword.value,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: authController.rememberMe.value,
                                        onChanged: (value) {
                                          authController.rememberME(value);
                                        },
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                        overlayColor:
                                            const MaterialStatePropertyAll(
                                                Colors.transparent),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 10),
                                      child: Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const Text(
                                "By signing in, you agree with our policy and usages terms",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 24,
                          ),
                          // const Spacer(),
                          InkWell(
                            onTap: () {
                              // if (authController
                              //         .emailTextEditingController.value.text ==
                              //     "") {
                              //   authController.userNameValidate.value = "false";
                              // }
                              // if (authController
                              //         .passwordTextEditingController.value.text ==
                              //     "") {
                              //   authController.userPasswordValidate.value = "false";
                              // }
      
                              if (authController.emailTextEditingController.value
                                          .text !=
                                      "" &&
                                  authController.passwordTextEditingController
                                          .value.text !=
                                      "" &&
                                  authController.userNameValidate.value !=
                                      "null" &&
                                  authController.userPasswordValidate.value !=
                                      "null") {
                                authController
                                    .signIn(context, endPoint: ApiUrl().signInUrl)
                                    .then((value) => null);
                              } else if (authController.emailTextEditingController
                                          .value.text ==
                                      "" &&
                                  authController.passwordTextEditingController
                                          .value.text ==
                                      "") {
                                authController.userNameValidate.value = "null";
                                authController.userPasswordValidate.value =
                                    "null";
                                authController.wrongPassword.value = "";
                                authController.wrongUserName.value = "";
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
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ))),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0))),
                                    content: const SizedBox(
                                      height: 150,
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
                                            "PASSWORD ISSUE!!!",
                                            style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Contact to the Administrator!",
                                             style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 20),
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            )),
      ),
    );
  }
}
