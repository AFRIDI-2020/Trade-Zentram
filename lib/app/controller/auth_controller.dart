import 'dart:developer';
import 'package:TradeZentrum/app/controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:TradeZentrum/app/model/user_info_model.dart';
import 'package:TradeZentrum/app/repository/auth_repository.dart';
import 'package:TradeZentrum/app/screens/home/home_page.dart';
import 'package:TradeZentrum/app/screens/login_page.dart';
import 'package:TradeZentrum/app/services/storage_service.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';
import 'package:TradeZentrum/app/utils/storage_key.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../services/api_env.dart';

class AuthController extends GetxController {
  Rx<TextEditingController> emailTextEditingController = TextEditingController().obs;
  Rx<TextEditingController> passwordTextEditingController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordTextEditingController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordTextEditingController = TextEditingController().obs;
  Rx<TextEditingController> confirmNewPasswordTextEditingController = TextEditingController().obs;

  AuthRepository authRepository = AuthRepository();
  StorageService storageService = StorageService();
  StorageKey storageKey = StorageKey();
  RxString token = "".obs;
  RxBool eyeVisibility = false.obs;
  RxBool rememberMe = true.obs;
  var userProfile = UserProfileModel().obs;
  RxString userNameValidate = "".obs;
  RxString userPasswordValidate = "".obs;
  RxString wrongPassword = "".obs;
  RxString wrongUserName = "".obs;
  RxString oldPasswordValidate = "".obs;
  RxString newPasswordValidate = "".obs;
  RxString confirmPasswordValidate = "".obs;
  RxDouble progressValue = 0.0.obs;

  void showAlertDialog() {
    Get.dialog(
      barrierDismissible: false,
      const AlertDialog(
        title: Text('Testing Application'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'You are using a testing application. Please pay your dues and update the application from the developer.',
              ),
            ],
          ),
        ),
        // actions: <Widget>[
        //   TextButton(
        //     child: const Text('OK'),
        //     onPressed: () {
        //       Get.back(); // Close the dialog
        //     },
        //   ),
        // ],
      ),
    );
  }

  @override
  onInit() async {
    super.onInit();
    startTimer();
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    FlutterSecureStorage storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    String? rememberMeString = await storage.read(key: "rememberMe");
    rememberMeString == "true" ? rememberMe.value = true : rememberMe.value = false;
    await Future.delayed(
        const Duration(
          milliseconds: 2000,
        ), () async {
      if (!await handleLocationPermission()) {
        logout();
        Get.to(() => const LoginPage());
      } else {
        return hasUserLoggedIn();
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
   /* await Future.delayed(const Duration(seconds: 3), () {
      DateTime currentDate = DateTime.now();
      DateTime april7 = DateTime(currentDate.year, 4, 7);
      if (currentDate.isAfter(april7)) {
        // Show the AlertDialog
        showAlertDialog();
      }
    });*/
  }

  void startTimer() {
    const twoSeconds = Duration(milliseconds: 1000);
    Timer.periodic(twoSeconds, (Timer timer) {
      progressValue.value += 30.0;
      if (progressValue.value >= 100) {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    emailTextEditingController.close();
    passwordTextEditingController.close();
  }

  Map<String, dynamic>? decodeToken({String? jwtToken}) {
    Map<String, dynamic> decodedToken = {};
    try {
      // Decode the JWT
      decodedToken = JwtDecoder.decode(jwtToken!);
      // Print the decoded token
      log('Decoded Token: $decodedToken');
      return decodedToken;
    } catch (e) {
      log('Error decoding JWT: $e');
    }
    return decodedToken;
  }

  saveUserInfo(value) async {
    var data = decodeToken(jwtToken: value);
    return await storageService.writeData(storageKey.userProfile, data);
  }

  readUserProfile() async {
    Map<String, dynamic> user = await storageService.readData(storageKey.userProfile);
    userProfile.value = UserProfileModel.fromJson(user);
    userNameValidate.value = "true";
    userPasswordValidate.value = "true";
  }

  checkTokenTIme() async {
    DateTime currentTime = DateTime.now();
    DateTime tokenExpaireTime =
        DateTime.fromMillisecondsSinceEpoch((userProfile.value.exp!) * 1000);
    if (currentTime.isAfter(tokenExpaireTime)) {
      await storageService.writeData(storageKey.token, null);
    }
  }

  hasUserLoggedIn() async {
    String? data;
    var status = await Permission.location.status;
    log("Permission status: $status");
    if (status.isDenied) {
      data = await storageService.readData(storageKey.token);
      if (data != null) {
        Get.off(() => const LoginPage());
      } else {
        Get.off(() => const LoginPage());
      }
      logout();
    } else if (status.isPermanentlyDenied) {
      logout();
      data = await storageService.readData(storageKey.token);
      if (data != null) {
        Get.off(() => const LoginPage());
      } else {
        Get.off(() => const LoginPage());
      }
    } else {
      data = await storageService.readData(storageKey.token);
      if (data != null) {
        saveUserInfo(data);
        readUserProfile();
        getCurrentLocation();
        await Future.delayed(const Duration(milliseconds: 1000), () {
          checkTokenTIme();
        });
        AndroidOptions getAndroidOptions() => const AndroidOptions(
              encryptedSharedPreferences: true,
            );
        FlutterSecureStorage storage = FlutterSecureStorage(aOptions: getAndroidOptions());
        String? email = await storage.read(key: "email");
        String? password = await storage.read(key: "password");
        String? rememberMeString = await storage.read(key: "rememberMe");

        if (email != null && password != null && rememberMeString == "true") {
          emailTextEditingController.value.text = email;
          passwordTextEditingController.value.text = password;
          rememberMeString == "true" ? rememberMe.value = true : rememberMe.value = false;
        }
        Get.off(() => const HomePage());
      } else {
        logout();
        await Future.delayed(const Duration(milliseconds: 700), () {
          rememberMe.value = true;
        });
        Get.off(() => const LoginPage());
      }
    }
  }

  rememberME(value, {bool? clear}) async {
    await Future.delayed(const Duration(milliseconds: 00), () async {
      rememberMe.value = value!;
      AndroidOptions getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      FlutterSecureStorage storage = FlutterSecureStorage(
        aOptions: getAndroidOptions(),
      );
      if (rememberMe.value) {
        await storage.write(key: 'email', value: emailTextEditingController.value.text);
        await storage.write(key: 'password', value: passwordTextEditingController.value.text);
        await storage.write(key: 'rememberMe', value: "true");
      } else {
        await storage.write(key: 'email', value: emailTextEditingController.value.text);
        await storage.write(key: 'password', value: passwordTextEditingController.value.text);
        if (clear!) {
          await storage.deleteAll();
        }
      }
    });
  }

/*  Future<void> signIn(context, {String? endPoint}) async {
    var status = await Permission.location.status;
    if (status.isPermanentlyDenied) {
      await [Permission.location].request();
    }

    else if (status.isDenied) {
      await [Permission.location].request();
    }

    else if (status.isGranted) {
      startLoading();
      final requestData = {
        "username": emailTextEditingController.value.text.trim(),
        "userPassword": passwordTextEditingController.value.text.trim()
      };
      var response =
          await authRepository.signIn(endPoint: endPoint!, data: requestData);
      log("SignIn Response: $response");
      if (response["status"]) {
        token.value = response['data'];
        await storageService.writeData(storageKey.token, token.value);
        getCurrentLocation();
        rememberMe.value ? rememberME(true) : rememberME(false, clear: true);
        saveUserInfo(token.value);
        readUserProfile();
        wrongUserName.value = "";
        wrongPassword.value = "";
        endLoading();
        if (!await handleLocationPermission()) {
          Get.to(() => const LoginPage());
        } else {
          Get.off(() => const HomePage());
        }
      } else {
        rememberME(false);
        endLoading();
        wrongUserName.value = "";
        wrongPassword.value = "";
        if (response['data'] == "Wrong Password!") {
          wrongPassword.value = response['data'];
        }
        if (response['data'] == "Wrong User Name!") {
          wrongUserName.value = response['data'];
        }
        //emailWrong.value =
      }
    }
  }*/

  Future<void> signIn(context, {String? endPoint}) async {
    if (await Permission.location.request().isGranted) {
      /*const locationOptions = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );*/
      final requestData = {
        "username": emailTextEditingController.value.text.trim(),
        "userPassword": passwordTextEditingController.value.text.trim()
      };
      startLoading();
      var response = await authRepository.signIn(endPoint: endPoint!, data: requestData);
      log("SignIn Response: $response");
      if (response["status"]) {
        token.value = response['data'];
        await storageService.writeData(storageKey.token, token.value);
        rememberMe.value ? rememberME(true) : rememberME(false, clear: true);
        saveUserInfo(token.value);
        readUserProfile();
        wrongUserName.value = "";
        wrongPassword.value = "";

        await getCurrentLocation();
        endLoading();

        print("...........lll${latitude.value}.........${longitude.value}");

        if (!await handleLocationPermission()) {
          Get.offAll(() => const LoginPage());
        } else {
          Get.offAll(() => const HomePage());
        }
      } else {
        rememberME(false);
        endLoading();
        wrongUserName.value = "";
        wrongPassword.value = "";
        if (response['data'] == "Wrong Password!") {
          wrongPassword.value = response['data'];
        }
        if (response['data'] == "Wrong User Name!") {
          wrongUserName.value = response['data'];
        }
      }
      /*StreamSubscription<Position> authPositionStream =
          Geolocator.getPositionStream(locationSettings: locationOptions).listen(
              (Position? position) async {
        startLoading();
      }, onError: () async {
        log("When Pressing in Signin button: $status");
      });*/
    }
    if (await Permission.location.request().isPermanentlyDenied) {
      await showPermissionDeniedDialog(context);
    }
    if (await Permission.location.request().isDenied) {
      await Permission.location.request();
      signIn(context, endPoint: ApiUrl().signInUrl);
    }
  }

  RxDouble latitude = RxDouble(0.0);
  RxDouble longitude = RxDouble(0.0);

  Future<void> getCurrentLocation() async {
    try {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  // Show dialog when permission is permanently denied
  Future<void> showPermissionDeniedDialog(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("Location permission is required to use this app."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text(
                "Go to Settings",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  void logout({HomeController? homeController}) async {
    await Future.delayed(const Duration(milliseconds: 500), () async {
      StorageService storageService = StorageService();
      var token = await storageService.readData(StorageKey().token);
      AndroidOptions getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      FlutterSecureStorage storage = FlutterSecureStorage(aOptions: getAndroidOptions());
      String? email = await storage.read(key: "email");
      String? password = await storage.read(key: "password");
      String? rememberMeString = await storage.read(key: "rememberMe");
      if (email != null && password != null && rememberMeString != null) {
        emailTextEditingController.value.text = email;
        passwordTextEditingController.value.text = password;
        rememberMeString == "true" ? rememberMe.value = true : rememberMe.value = false;
      } else {
        emailTextEditingController.value.clear();
        passwordTextEditingController.value.clear();
        rememberMe.value = false;
      }

      if (token != "") {
        await storageService.writeData(StorageKey().token, null);
        if (homeController != null) {
          await Get.delete<HomeController>();
        }

        log("User Logout");
        Get.offAll(
          () => const LoginPage(),
        );
      }
    });
  }

  updatePassword(
    context, {
    String? endPoint,
  }) async {
    startLoading();
    final requestData = {
      "userSystemId": userProfile.value.userSystemId,
      "oldPassword": oldPasswordTextEditingController.value.text.trim(),
      "newPassword": newPasswordTextEditingController.value.text.trim(),
    };
    var response = await authRepository.updatePassword(endPoint: endPoint!, data: requestData);
    log("Update Password Response: $response");
    if (response['status']) {
      AndroidOptions getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      FlutterSecureStorage storage = FlutterSecureStorage(
        aOptions: getAndroidOptions(),
      );
      await storage.write(key: 'password', value: newPasswordTextEditingController.value.text);
      oldPasswordTextEditingController.value.clear();
      newPasswordTextEditingController.value.clear();
      confirmNewPasswordTextEditingController.value.clear();
      endLoading();
      Get.off(() => const HomePage());
    } else {
      response["data"] == "Old Password does not match!"
          ? oldPasswordValidate.value = "Old Password does not match!"
          : "";
      endLoading();
    }
  }

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
