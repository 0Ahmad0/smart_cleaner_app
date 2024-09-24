import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/app/widgets/back_ground_app_widget.dart';
import 'package:smart_cleaner_app/app/widgets/circle_shape_with_icon_widget.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../core/helpers/spacing.dart';
import '../../core/utils/color_manager.dart';
import '../../core/utils/string_manager.dart';
import '../../core/utils/style_manager.dart';

class CheckInboxScreen extends StatelessWidget {
  const CheckInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        visibleBackIcon: true,
        child: AppPaddingWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              CircleShapeWithIconWidget(
                icon: Icons.email_outlined,
              ),
              verticalSpace(20.h),
              AppPaddingWidget(
                verticalPadding: 0.0,
                child: Text(
                  StringManager.sentEmailVerifyToResetPasswordText,
                  textAlign: TextAlign.center,
                  style: StyleManager.font16Regular(
                      color: ColorManager.primaryColor),
                ),
              ),
              verticalSpace(40.h),
              AppButton(
                onPressed: () {
                  context.pushAndRemoveUntil(Routes.loginRoute,
                      predicate: (route) => false);
                },
                text: StringManager.goToLoginText,
              ),
              verticalSpace(10.h),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    StringManager.resendEmailText,
                    style: StyleManager.font16Regular(
                            color: ColorManager.primaryColor)
                        .copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
