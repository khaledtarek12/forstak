// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/screens/login.dart';
import 'package:active_ecommerce_seller_app/screens/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _hideStatusBar();
    _initPackageInfo();
    _navigateAfterSplash();
    log(access_token.$.toString());
  }

  // Hides the status bar
  void _hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  // Initializes the package info
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Navigates to the appropriate screen after splash
  void _navigateAfterSplash() async {
    await access_token.load();
    log(access_token.$.toString());
    await Future.delayed(const Duration(seconds: 2));

    if (access_token.$!.isNotEmpty) {
      // Token is present, go to Main screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Main()),
        (route) => false,
      );
    } else {
      // Token is empty, go to Login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen(
      version: Text(
        "version ${_packageInfo.version}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11.0,
          color: MyTheme.app_accent_border,
        ),
      ),
      useLoader: false,
      loadingText: Text(
        AppConfig.app_name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      image: Image.asset(
        "assets/logo/app_logo.png",
        width: 100,
        height: 100,
      ),
      backgroundColor: MyTheme.splash_screen_color,
      backgroundPhotoSize: 120.0,
      photoSize: 55,
    );
  }
}

class CustomSplashScreen extends StatelessWidget {
  final Text version;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final double? photoSize;
  final double? backgroundPhotoSize;
  final dynamic onClick;
  final Color? loaderColor;
  final Image? image;
  final Image? backgroundImage;
  final Text loadingText;
  final ImageProvider? imageBackground;
  final Gradient? gradientBackground;
  final bool useLoader;
  final Route? pageRoute;
  final String? routeName;
  final Function? afterSplashScreen;

  const CustomSplashScreen({
    super.key,
    this.loaderColor,
    this.photoSize,
    this.backgroundPhotoSize,
    this.pageRoute,
    this.onClick,
    this.version = const Text(''),
    this.backgroundColor = Colors.white,
    this.styleTextUnderTheLoader = const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.image,
    this.backgroundImage,
    this.loadingText = const Text(""),
    this.imageBackground,
    this.gradientBackground,
    this.useLoader = true,
    this.routeName,
    this.afterSplashScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: imageBackground == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: imageBackground!,
                      ),
                gradient: gradientBackground,
                color: backgroundColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: MyTheme.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            "assets/logo/app_logo.png",
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadingText,
                      ),
                      version,
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
