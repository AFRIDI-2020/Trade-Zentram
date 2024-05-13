import 'package:TradeZentrum/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:TradeZentrum/app/screens/splash_page.dart';

import 'app/utils/color_const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: defaultTextTheme,
        cardTheme: CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 15, vertical: 3)),
            backgroundColor: MaterialStatePropertyAll(ColorConstant().baseColor),
            surfaceTintColor: MaterialStateProperty.all<Color>(ColorConstant.secondaryThemeColor),
            foregroundColor: MaterialStateProperty.all<Color>(ColorConstant.secondaryThemeColor),
            textStyle: MaterialStateProperty.all<TextStyle>(
                defaultTextTheme.titleMedium!.copyWith(color: ColorConstant.secondaryThemeColor)),
          ),
        ),
      ),
      builder: EasyLoading.init(),
      home: const SplashPage(),
    );
  }
}
