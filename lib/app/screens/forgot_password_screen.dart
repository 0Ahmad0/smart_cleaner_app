import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/app/widgets/back_ground_app_widget.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';
import 'package:smart_cleaner_app/core/widgets/custome_back_button.dart';

import '../widgets/circle_shape_with_icon_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAppWidget(
        visibleBackIcon: true,
        child: Center(
          child: SingleChildScrollView(
            child: AppPaddingWidget(
              child: Column(
                children: [
                  CircleShapeWithIconWidget(
                    icon: Icons.lock_open,
                  ),
                  verticalSpace(20.h),
                  AppPaddingWidget(
                    verticalPadding: 0.0,
                    child: Text(
                      StringManager.pleaseEnterValidEmailText,
                      textAlign: TextAlign.center,
                      style: StyleManager.font16Regular(
                          color: ColorManager.primaryColor),
                    ),
                  ),
                  verticalSpace(20.h),
                  AppTextField(
                    hintText: StringManager.enterEmailHintText,
                    iconData: Icons.email_outlined,
                  ),
                  verticalSpace(40.h),
                  AppButton(
                    onPressed: () {
                      context.pushReplacement(Routes.checkInboxRoute);
                    },
                    text: StringManager.sendText,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
