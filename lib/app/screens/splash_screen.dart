import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/const_value_manager.dart';

import '../controllers/splash_controller.dart';
import '../widgets/back_ground_app_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _goToNextScreen() async {
    await Future.delayed(Duration(seconds: ConstValueManager.delayedSplash),(){
      context.pushReplacement(Routes.loginRoute);
    });
  }
  @override
  void initState() {
    // _goToNextScreen();
    Get.put(SplashController()).initSplash(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDownBig(
              child: Image.asset(
                AssetsManager.logoIMG,
                width: 200.w,
                height: 200.h,
              ),
            ),
            verticalSpace(20.h),
            CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }
}
