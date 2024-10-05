import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/style_manager.dart';

class BottomSheetReportProblemIconWidget extends StatelessWidget {
  const BottomSheetReportProblemIconWidget({
    super.key,
    required this.icon,
    this.label = '',
    this.onPressed,
    this.color = ColorManager.primaryColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.sp,
          backgroundColor: color,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 30.sp,
              color: ColorManager.whiteColor,
            ),
          ),
        ),
        verticalSpace(6.h),
        Text(
          label,
          style: StyleManager.font12Regular(),
        ),
        verticalSpace(20.h)
      ],
    );
  }
}
