import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:smart_cleaner_app/app/widgets/back_ground_app_widget.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';

class HomeGuestScreen extends StatelessWidget {
  const HomeGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                AssetsManager.logoIMG,
                width: 100.w,
                height: 100.h,
              ),
              verticalSpace(10.h),
              GetBuilder<ProfileController>(
                  init: Get.put(ProfileController()),
                  builder: (controller) {
                    return
              Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    TextSpan(
                      text: StringManager.welcomeText,
                      style: StyleManager.font30Bold(),
                    ),

                            // TextSpan(
                            //   text: '  ' + (controller.currentUser.value?.name??  ''),
                            //   style: StyleManager.font20SemiBold(
                            //       color: ColorManager.primaryColor)

                    // )
                  ]))
               ;}),
              verticalSpace(10.h),
              AppPaddingWidget(
                verticalPadding: 0,
                child: Text(
                  StringManager.questionHomeGuestText,
                  textAlign: TextAlign.center,
                  style: StyleManager.font16Regular(
                      color: ColorManager.primaryColor),
                ),
              ),
              verticalSpace(30.h),
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 40.w,
                    height: 40.h,
                  ),
                  horizontalSpace(10.w),
                  Flexible(
                    child: AppButton(
                        onPressed: () {
                          context.pushNamed(Routes.reportProblemGuestRoute);
                        }, text: StringManager.reportProblemText),
                  ),
                ],
              ),
              verticalSpace(20.h),
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 40.w,
                    height: 40.h,
                  ),
                  horizontalSpace(10.w),
                  Flexible(
                    child: AppButton(
                        onPressed: () {
                          context.pushNamed(Routes.weatherRoute);
                        },
                        text: StringManager.weatherStatisticsText),
                  ),
                ],
              ),
              verticalSpace(10.h),

              ListTile(
                onTap: () {
                  Get.lazyPut(() => AuthController());
                  AuthController.instance.signOut(context);
                  },
                title:Text(

                  StringManager.exitText,
                  // textAlign: TextAlign.center,
                  style: StyleManager.font16Regular(
                      color: ColorManager.primaryColor),
                ) ,
                leading:  Icon(Icons.logout,size: 20.sp,),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
