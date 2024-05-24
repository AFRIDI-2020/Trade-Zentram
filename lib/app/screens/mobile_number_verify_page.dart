import 'dart:developer';

import 'package:TradeZentrum/app/components/custom_appbar.dart';
import 'package:TradeZentrum/app/controller/up_activity_task_controller.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class MobileNumberVerifyPage extends GetView<UpActivityTaskController> {
  const MobileNumberVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskDetailsController = Get.put(UpActivityTaskController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CustomAppBar(
          toPage: "MobileNumberVerifyPage",
          pageTitle: "Verify Mobile Number",
          appBarBgColor: Colors.white,
          onBackTap: () {
            taskDetailsController.showPhoneNumberError.value = "";
            taskDetailsController.showVerifyOtpError.value = "";
            taskDetailsController.mobileNumberTextFormField.clear();
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              taskDetailsController.showPhoneNumberError.value = "";
              taskDetailsController.showVerifyOtpError.value = "";
              taskDetailsController.mobileNumberTextFormField.clear();
              Get.back();
            },
            child: const Row(
             mainAxisSize: MainAxisSize.min,
              children: [
                Text("Back to Checklist"),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: taskDetailsController.otpTimeDuration.value == 120 ? true : false,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/otp_verification_image.jpg",
                        width: 250,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "OTP Verification",
                          style: theme.textTheme.displaySmall,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter your mobile number to send one time password",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),

                      /*Container(
                    padding: const EdgeInsets.fromLTRB(
                      32.0,
                      32.0,
                      32.0,
                      0,
                    ),
                    color: ColorConstant().baseColor.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'TaskId: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: taskDetailsController
                                      .taskDetailsData.value.taskId
                                      .toString(),
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
                              text: 'Invoice: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: taskDetailsController
                                      .taskDetailsData.value.soSystemNo,
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
                                  text: taskDetailsController
                                      .taskDetailsData.value.taskDestination,
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
                                  text: taskDetailsController.taskDetailsData.value
                                          .taskDestinationAddress ??
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
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              taskDetailsController.taskDetailsData.value
                                              .taskStartTime ==
                                          null &&
                                      taskDetailsController
                                              .taskDetailsData.value.taskEndTime ==
                                          null
                                  ? showDialog(
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
                                                    size: 80,
                                                    color: Color(0xFFC62828)
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
                                                    taskDetailsController
                                                        .declearTaskStart(
                                                      endPoint:
                                                          ApiUrl().declearTaskStart,
                                                      taskId: taskDetailsController
                                                          .taskId.value,
                                                    );
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
                                    )
                                  : null;
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                backgroundColor: MaterialStatePropertyAll(
                                    taskDetailsController.taskDetailsData.value
                                                    .taskStartTime ==
                                                null &&
                                            taskDetailsController.taskDetailsData
                                                    .value.taskEndTime ==
                                                null
                                        ? ColorConstant().baseColor
                                        : taskDetailsController.taskDetailsData
                                                        .value.taskStartTime !=
                                                    null &&
                                                taskDetailsController
                                                        .taskDetailsData
                                                        .value
                                                        .taskEndTime ==
                                                    null
                                            ? ColorConstant()
                                                .baseColor
                                                .withOpacity(0.3)
                                            : ColorConstant().baseColor)),
                            child: Text(
                              taskDetailsController.taskDetailsData.value
                                              .taskStartTime ==
                                          null &&
                                      taskDetailsController
                                              .taskDetailsData.value.taskEndTime ==
                                          null
                                  ? "Start"
                                  : taskDetailsController.taskDetailsData.value
                                                  .taskStartTime !=
                                              null &&
                                          taskDetailsController.taskDetailsData
                                                  .value.taskEndTime ==
                                              null
                                      ? "Started"
                                      : "",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),*/

                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: taskDetailsController.mobileNumberTextFormField,
                        onChanged: (value) {
                          if (value == "") {
                            taskDetailsController.showPhoneNumberError.value =
                                'Phone number is required';
                          } else {
                            if (value.length < 11 || value.length > 11) {
                              taskDetailsController.showPhoneNumberError.value =
                                  "Use valid phone number";
                            } else {
                              for (int i = 0; i < value.length; i++) {
                                if (value[0] == "0" && value[1] == "1") {
                                  taskDetailsController.showPhoneNumberError.value = "";
                                }
                              }
                            }
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          prefix: const Text(
                            "+88 ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          hintText: "Enter mobile number",
                          labelText: 'Number',
                          alignLabelWithHint: true,
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
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                          visible:
                              taskDetailsController.showPhoneNumberError.value != "" ? true : false,
                          child: Text(
                            taskDetailsController.showPhoneNumberError.value,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            if (taskDetailsController.mobileNumberTextFormField.text.isEmpty) {
                              taskDetailsController.showPhoneNumberError.value =
                                  "Mobile number is required";
                              return;
                            }
                            taskDetailsController.otpTimeDuration.value == 120
                                ? taskDetailsController.getOtp(
                                    endPoint: ApiUrl().getOtp,
                                    number:
                                        "88${taskDetailsController.mobileNumberTextFormField.text}")
                                : null;
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                taskDetailsController.otpTimeDuration.value != 120
                                    ? ColorConstant().baseColor.withOpacity(0.5)
                                    : ColorConstant().baseColor),
                          ),
                          child: Text(
                            taskDetailsController.otpTimeDuration.value != 120 ? "Sent" : "Send",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: taskDetailsController.otpTimeDuration.value != 120 ? true : false,
                  child: Column(
                    children: [
                      Text(
                        "Verification Code",
                        style: theme.textTheme.displaySmall,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "We have send an one time password\non your mobile number",
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      OTPTextField(
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 50,
                        style: const TextStyle(fontSize: 17),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) {
                          taskDetailsController.otpValue.value = pin;
                          print("p : $pin");
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Didn't you receive code?",
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "You may request a new code in ${taskDetailsController.timeLeft.value}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Visibility(
                            visible: taskDetailsController.showPhoneNumberError.value != ""
                                ? true
                                : false,
                            child: Text(
                              taskDetailsController.showVerifyOtpError.value,
                              style: const TextStyle(color: Colors.red),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 42,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            taskDetailsController.otpTimeDuration.value != 120 &&
                                    !taskDetailsController.verifyOtpStatus.value
                                ? taskDetailsController.verifyOtp(
                                    endPoint: ApiUrl().verityOtp,
                                    otp: taskDetailsController.otpValue.value)
                                : null;
                          },
                          child: const Text(
                            "Verify",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
