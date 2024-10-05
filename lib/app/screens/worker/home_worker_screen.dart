import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/string_manager.dart';
import '../../../core/utils/style_manager.dart';
import '../../../core/widgets/app_padding.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../widgets/container_home_widget.dart';

class HomeWorkerScreen extends StatelessWidget {
  const HomeWorkerScreen({super.key});

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
            verticalSpace(30.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerHomeWidget(
                  icon: Icons.settings_outlined,
                  text: StringManager.settingText,
                  color: ColorManager.hintTextColor,
                  route: Routes.settingWorkerRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.sunny_snowing,
                  text: StringManager.weatherStatisticsText,
                  color: ColorManager.tealColor,
                  route: Routes.weatherRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.close_outlined,
                  text: StringManager.cancelTripText,
                  route: Routes.robotOnDutyWorkerRoute,
                ),
              ],
            ),
            verticalSpace(20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerHomeWidget(
                  icon: Icons.location_on_outlined,
                  text: StringManager.locationText,
                  route: Routes.robotPathWorkerRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.notifications_active_outlined,
                  text: StringManager.notificationText,
                  color: ColorManager.hintTextColor,
                  route: Routes.notificationWorkerRoute,
                ),
                ContainerHomeWidget(
                  icon: Icons.details,
                  text: StringManager.problemsText,
                  color: ColorManager.tealColor,
                  route: Routes.problemsWorkerRoute,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
