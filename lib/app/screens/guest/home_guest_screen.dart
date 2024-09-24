import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/app/widgets/back_ground_app_widget.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

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
              Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(children: [
                    TextSpan(
                      text: StringManager.welcomeText,
                      style: StyleManager.font30Bold(),
                    ),
                    TextSpan(
                        text: '  ' + 'Ghadeer',
                        style: StyleManager.font20SemiBold(
                            color: ColorManager.primaryColor))
                  ])),
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
              AppButton(
                  onPressed: () {}, text: StringManager.reportProblemText),
              verticalSpace(20.h),
              AppButton(
                  onPressed: () {}, text: StringManager.weatherStatisticsText),
            ],
          ),
        ),
      ),
    );
  }
}
