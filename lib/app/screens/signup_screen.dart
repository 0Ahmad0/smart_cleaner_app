import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/utils/const_value_manager.dart';
import '/app/widgets/back_ground_app_widget.dart';
import '/core/helpers/extensions.dart';
import '/core/helpers/spacing.dart';
import '/core/routing/routes.dart';
import '/core/utils/assets_manager.dart';
import '/core/utils/color_manager.dart';
import '/core/utils/string_manager.dart';
import '/core/utils/style_manager.dart';
import '/core/widgets/app_button.dart';
import '/core/widgets/app_padding.dart';
import '/core/widgets/app_textfield.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        child: AppPaddingWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(100.h),
                Image.asset(
                  AssetsManager.logoIMG,
                  width: 150.w,
                  height: 150.h,
                ),
                Text(
                  StringManager.appName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style:
                      StyleManager.font24Bold(color: ColorManager.primaryColor),
                ),
                verticalSpace(20.h),
                AppTextField(
                  iconData: Icons.person,
                  hintText: StringManager.enterUserNameText,
                ),
                verticalSpace(20.h),
                AppTextField(
                  iconData: Icons.email_outlined,
                  hintText: StringManager.enterEmailHintText,
                ),
                verticalSpace(20.h),
                AppTextField(
                  iconData: Icons.lock_open,
                  obscureText: true,
                  suffixIcon: true,
                  hintText: StringManager.enterPasswordHintText,
                ),
                verticalSpace(20.h),
                AppTextField(
                  iconData: Icons.lock_open,
                  obscureText: true,
                  suffixIcon: true,
                  hintText: StringManager.enterConfirmPasswordHintText,
                ),
                verticalSpace(30.h),
                AppButton(
                  onPressed: () {
                    if(ConstValueManager.role == ConstValueManager.worker){
                      context.pushAndRemoveUntil(Routes.workerProfilesRoute,
                          predicate: (route) => false);
                    }
                    context.pushAndRemoveUntil(Routes.homeGuestRoute,
                        predicate: (route) => false);
                  },
                  text: StringManager.signUpText,
                ),
                verticalSpace(20.h),
                Text.rich(
                    style: StyleManager.font14Regular(),
                    TextSpan(children: [
                      TextSpan(
                        text: StringManager.allReadyHaveAnAccountText,
                      ),
                      TextSpan(
                          text: StringManager.loginText,
                          style: StyleManager.font14Bold(
                                  color: ColorManager.primaryColor)
                              .copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushReplacement(Routes.loginRoute);
                            }),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
