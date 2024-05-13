import 'package:TradeZentrum/app/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TradeZentrum/app/controller/auth_controller.dart';

class SplashPage extends GetView<AuthController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 150,
                width: 200,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 8.0),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    value: authController.progressValue / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorConstant().baseColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            
            ],
          ),
        ),
      ),
    );
  }
}
