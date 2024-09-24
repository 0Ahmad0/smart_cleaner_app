import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/core/helpers/sizer.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
          ),
          child: CircleAvatar(),
        ),
        title: Text(StringManager.homeText),
        actions: [
          SvgPicture.asset(
            AssetsManager.robotIcon,
            width: 50.w,
            height: 50.h,
          ),
          horizontalSpace(6.w),
        ],
      ),
      body: AppPaddingWidget(
        child: Column(
          children: [
            Center(
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                        text: StringManager.welcomeText,
                        style: StyleManager.font20SemiBold()),
                    TextSpan(
                      text: ' ' + StringManager.adminText,
                      style: StyleManager.font16Regular(
                          color: ColorManager.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(20.h),
            SizedBox(
              width: double.maxFinite,
              height: getWidth(context) / 1.5,
              child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 20.h
                  ),
                  itemBuilder: (context, index) => Container(
                        alignment: Alignment.center,
                        color:
                            ColorManager.errorColor.withOpacity(index / 20),
                        child: Text('${index + 1}'),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
