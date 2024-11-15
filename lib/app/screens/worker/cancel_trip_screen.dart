import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../../core/dialogs/cancel_trip_success_canceled_dialog.dart';
import '../../../core/utils/style_manager.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/smtp_service.dart';
import '../../controllers/workers_controller.dart';

class CancelTripScreen extends StatefulWidget {
  const CancelTripScreen({super.key});

  @override
  State<CancelTripScreen> createState() => _CancelTripScreenState();
}

class _CancelTripScreenState extends State<CancelTripScreen> {
  static const int countdownDuration = 300; // 5 minutes in seconds
  late Timer _timer;
  int _remainingTime = countdownDuration;

  String? code;

  setupCode(){
    Future.delayed(Duration(seconds: 2),()=>
    SmtpService.sendCode(code: code??"",name: robot?.name, email: Get.put(ProfileController()).currentUser.value?.email??"")
    );
  }
  String generateRandomCode() {
    final random = Random();
    code = "${random.nextInt(900) + 100}"; // يولد أرقام بين 100 و 999
    return code.toString();
  }

  @override
  void initState() {
    generateRandomCode();
    setupCode();
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
                if (value ==(code??"000")) {

                  Get.put(WorkersController()).cancelTripRobot(context, robot);
                // if (value == '000') {
                //   showDialog(
                //     context: context,
                //     builder: (_) => CancelTripSuccessCanceledDialog(),
                //   );
                }else{
                  ConstantsWidgets.TOAST(context,textToast:"The code entry is wrong, Try again.",state: false);

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
            verticalSpace(10.h),
            Visibility(
              visible: !_timer.isActive,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    _remainingTime = countdownDuration;
                   _startTimer();
                   setupCode();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: ColorManager.enterButtonColor,
                        borderRadius:
                        BorderRadius.all( Radius.circular(100.r))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email_outlined,size: 18.w,color: ColorManager.whiteColor,),
                        SizedBox(width: 8.w,),
                        Text(
                          StringManager.sendText,
                          style: StyleManager.font12Medium(color: ColorManager.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
