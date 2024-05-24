import 'dart:async';
import 'dart:developer';

import 'package:TradeZentrum/app/controller/home_controller.dart';
import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

void showSnackbar(BuildContext context, String content, Color color) {
  final snackBar = SnackBar(
    content: Text(content),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

startLoading() {
  EasyLoading.show(status: 'loading...');
}

endLoading() {
  EasyLoading.dismiss();
}

String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
String passwordPattern =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$';

void popUpStatus(
  context, {
  IconData? leadingIcon,
  Color? leadingIconColor,
  String? title,
  String? subtitle,
  bool twoButton = false,
  String? firstActionButtonTitle,
  Color? firstActionButtonColor,
  VoidCallback? firstActionButtonOnTap,
  String? secondActionButtonTitle,
  VoidCallback? secondActionButtonOnTap,
  Color? secondActionButtonColor,
  bool barrierDismissible = true,
}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        content: SizedBox(
          height: 180,
          child: Column(
            children: [
              Icon(
                leadingIcon!,
                size: 80,
                color: leadingIconColor ?? const Color(0xFFed6c02),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: !twoButton
            ? <Widget>[
                ElevatedButton(
                  onPressed: firstActionButtonOnTap ?? () => Get.back(),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStatePropertyAll(firstActionButtonColor),
                  ),
                  child: Text(
                    firstActionButtonTitle!,
                    style: const TextStyle(
                      color: ColorConstant.secondaryThemeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            : <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:firstActionButtonOnTap ?? () => Get.back(),
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
                      onPressed: secondActionButtonOnTap,
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
  );
}

late StreamSubscription<Position> positionStream;

void listenToLocationUpdates({required String control, HomeController? homeController}) {
  const locationOptions = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10,
  );
  positionStream = Geolocator.getPositionStream(locationSettings: locationOptions).listen(
        (Position? position) async {
      log(position == null
          ? 'Unknown'
          : 'Positions :::  ${position.latitude.toString()}, ${position.longitude.toString()}');
    },
    onError: (e) async {
      print("show dialog");
      await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
          content: const PopScope(
            canPop: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_off_rounded, size: 80, color: Color(0xFF9c27b0)),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "TURN ON LOCATION!",
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "You need to turn on your location or you will be logged out!",
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AuthController().logout(homeController: homeController);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal:8, vertical: 4)),
                        backgroundColor: const MaterialStatePropertyAll(Colors.red)),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 16,),
                        SizedBox(width: 4,),
                        Text(
                          "No Thanks!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      enableLocationService();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal:8, vertical: 4)),
                        backgroundColor: const MaterialStatePropertyAll(Color(0xFF9c27b0))),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.white,size: 16,),
                        SizedBox(width: 4,),
                        Text(
                          "Turn On",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ).then((value) {
        Get.back();
      });
    },
  );
}

var locationServiceEnabled = false.obs;

Future<void> checkLocationService() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  locationServiceEnabled.value = serviceEnabled;
}

Future<void> enableLocationService() async {
  Get.back();
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await Geolocator.openLocationSettings();
  }

  locationServiceEnabled.value = serviceEnabled;
}
