import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/core/helpers/sizer.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../widgets/container_home_widget.dart';

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
        title: Text(StringManager.homeText.toUpperCase()),
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
            AppTextField(
              hintText: StringManager.searchText,
              iconData: Icons.search,
            ),
            verticalSpace(30.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerHomeWidget(
                  icon: Icons.route,
                  text: StringManager.robotPathText,
                  color: ColorManager.hintTextColor,
                ),
                ContainerHomeWidget(
                  icon: Icons.sunny_snowing,
                  text: StringManager.weatherStatisticsText,
                  color: ColorManager.tealColor,
                  route: Routes.weatherRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.person,
                  text: StringManager.workersProfilesText,
                  route: Routes.workerProfilesRoute,
                ),
              ],
            ),
            verticalSpace(20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerHomeWidget(
                  icon: Icons.notifications_active_outlined,
                  text: StringManager.activitiesText,
                  route: Routes.activitiesRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.location_on_outlined,
                  text: StringManager.trackText,
                  color: ColorManager.hintTextColor,
                ),
                ContainerHomeWidget(
                  icon: Icons.more_horiz,
                  text: StringManager.otherText,
                  color: ColorManager.tealColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

