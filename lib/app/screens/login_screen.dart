import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                Text(
                  StringManager.welcomeText,
                  textAlign: TextAlign.center,
                  style: StyleManager.font20Bold(),
                ),
                verticalSpace(50.h),
                AppTextField(
                  iconData: Icons.person,
                  hintText: StringManager.emailText,
                ),
                verticalSpace(20.h),
                AppTextField(
                  iconData: Icons.lock_open,
                  obscureText: true,
                  suffixIcon: true,
                  hintText: StringManager.enterPasswordHintText,
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(Routes.forgotPasswordRoute);
                    },
                    child: Text(
                      StringManager.forgotPasswordText,
                      style: StyleManager.font14Regular(
                              color: ColorManager.primaryColor)
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                verticalSpace(30.h),
                AppButton(
                  onPressed: () {},
                  text: StringManager.loginText,
                ),
                verticalSpace(20.h),
                Text.rich(
                    style: StyleManager.font14Regular(),
                    TextSpan(children: [
                      TextSpan(
                        text: StringManager.doNotHaveAccountText,
                      ),
                      TextSpan(
                        text: StringManager.signUpText,
                        style: StyleManager.font14Bold(
                                color: ColorManager.primaryColor)
                            .copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {
                          context.pushReplacement(Routes.signUpRoute);
                          }
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
