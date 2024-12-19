import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/utils/app_constant.dart';
import '../controllers/auth_controller.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController authController;
  @override
  void initState() {
    authController= Get.put(AuthController());
    authController.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        child: AppPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: authController.formKey,
              child: Stack(
                children: [
                  Column(
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
                        controller:  authController.emailController,
                        validator: (value)=>authController.validateEmail(value??''),
                        hintText: StringManager.emailText,
                      ),
                      verticalSpace(20.h),
                      AppTextField(
                        controller: authController.passwordController,
                        iconData: Icons.lock_open,
                        obscureText: true,
                        suffixIcon: true,
                        validator: (value)=>authController.validatePassword(value??''),
                        hintText: StringManager.enterPasswordHintText,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              constraints:BoxConstraints(
                                  maxWidth: 184.w,
                                  maxHeight: 30.h
                              ),

                              child:
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorManager.primaryColor),
                                  onPressed: () async {
                                    authController.typeUser=AppConstants.collectionUser;
                                    context.pushReplacement(Routes.homeGuestRoute);
                                  },
                                  child: Text(
                                    StringManager.continueAsGuest+" >>",
                                    style: StyleManager.font12Regular(color: ColorManager.whiteColor),
                                  ))
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
                        ],
                      ),

                      verticalSpace(30.h),
                      AppButton(
                        onPressed: () async {
                          // context.pushReplacement(Routes.homeAdminRoute);
                          // await authController.seeder();
                          if (authController.formKey.currentState!.validate()) {
                            authController.login(context);
                          }
                        },
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
                              text: StringManager.signUpAsWorkerText,
                              style: StyleManager.font14Bold(
                                      color: ColorManager.primaryColor)
                                  .copyWith(decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  authController.typeUser=AppConstants.collectionWorker;
                                  context.pushReplacement(Routes.signUpRoute);
                                // context.pushNamed(Routes.selectRoleRoute);
                                }
                            ),
                          ]))
                    ],
                  ),
                  // PositionedDirectional(
                  //   end: 0,
                  //   top: 70.h,
                  //   child: Container(
                  //       constraints:BoxConstraints(
                  //         maxWidth: 184.w,
                  //         maxHeight: 30.h
                  //       ),
                  //
                  //     child:
                  //     ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: ColorManager.primaryColor),
                  //         onPressed: () async {
                  //           authController.typeUser=AppConstants.collectionUser;
                  //           context.pushReplacement(Routes.homeGuestRoute);
                  //         },
                  //         child: Text(
                  //           StringManager.continueAsGuest+" >>",
                  //           style: StyleManager.font12Regular(color: ColorManager.whiteColor),
                  //         ))
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
