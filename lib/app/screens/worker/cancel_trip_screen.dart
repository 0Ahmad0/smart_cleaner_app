import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../../core/dialogs/cancel_trip_success_canceled_dialog.dart';
import '../../../core/utils/style_manager.dart';

class CancelTripScreen extends StatefulWidget {
  const CancelTripScreen({super.key});

  @override
  State<CancelTripScreen> createState() => _CancelTripScreenState();
}

class _CancelTripScreenState extends State<CancelTripScreen> {
  static const int countdownDuration = 300; // 5 minutes in seconds
  late Timer _timer;
  int _remainingTime = countdownDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
   RobotModel? robot;

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    robot=args?['robot'];
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.cancelTripText.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppPaddingWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 100.w,
                    height: 100.h,
                  ),
                  Flexible(
                    child: Text(
                      StringManager.cancelTripText +
                          '\n' +
                          "${robot?.name?? 'SCC 00${args['index']}'}",
                      textAlign: TextAlign.center,
                      style: StyleManager.font24Medium(),
                    ),
                  )
                ],
              ),
            ),
            verticalSpace(100.h),
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration:
                  BoxDecoration(color: ColorManager.tealColor.withOpacity(.25)),
              child: Text(
                StringManager.enterVerificationCodeText.toUpperCase(),
                style:
                    StyleManager.font18Medium(color: ColorManager.primaryColor),
              ),
            ),
            verticalSpace(40.h),
            Pinput(
              autofocus: true,
              length: 3,
              showCursor: true,
              pinAnimationType: PinAnimationType.rotation,
              defaultPinTheme: PinTheme(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: ColorManager.primaryColor.withOpacity(.5),
                      borderRadius: BorderRadius.circular(100.r))),
              submittedPinTheme: PinTheme(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: ColorManager.tealColor.withOpacity(.5),
                      borderRadius: BorderRadius.circular(100.r))),
              onCompleted: (value) {
                if (value == '000') {
                  showDialog(
                    context: context,
                    builder: (_) => CancelTripSuccessCanceledDialog(),
                  );
                }
              },
            ),
            verticalSpace(40.h),
            Text(
              StringManager.thisCodeWillBeExpiredText,
              textAlign: TextAlign.center,
              style: StyleManager.font16SemiBold(),
            ),
            verticalSpace(20.h),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: '$_formattedTime' + ' ',
                    style:
                        StyleManager.font14Bold(color: ColorManager.tealColor)),
                TextSpan(
                  text: StringManager.leftText,
                  style: StyleManager.font16SemiBold(),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
