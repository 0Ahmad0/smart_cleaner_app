import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/utils/style_manager.dart';

class DescribeProblemWidget extends StatelessWidget {
  const DescribeProblemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          margin:
          EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
          decoration: BoxDecoration(
              color: ColorManager.grayColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: ColorManager.tealColor, width: 4.sp)),
          child: Text(
            StringManager.describeProblemText,
            textAlign: TextAlign.center,
            style: StyleManager.font14SemiBold(),
          ),
        ),
        PositionedDirectional(
          top: -20.h,
          start: 10.w,
          child: Icon(
            Icons.info,
            color: ColorManager.tealColor,
            size: 60.sp,
          ),
        )
      ],
    );
  }
}
