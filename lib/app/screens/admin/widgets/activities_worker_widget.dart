import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/helpers/sizer.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

class ActivitiesWorkerWidget extends StatelessWidget {
  const ActivitiesWorkerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.grayColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.tealColor,
          width: 4.sp,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activities',
            style: StyleManager.font24Medium(
              color: ColorManager.primaryColor,
            ),
          ),
          verticalSpace(20.h),
          Container(
            width: getWidth(context) / 2,
            height: 10.h,
            color: ColorManager.purpleColor,
          ),
          verticalSpace(10.h),
          Container(
            width: getWidth(context) / 2.5,
            height: 10.h,
            color: ColorManager.orangeColor,
          ),
          verticalSpace(10.h),
          Container(
            width: getWidth(context) / 3,
            height: 10.h,
            color: ColorManager.deepBlueColor,
          ),
        ],
      ),
    );
  }
}
