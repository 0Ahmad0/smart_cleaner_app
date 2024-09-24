import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/assets_manager.dart';
import '../../core/utils/color_manager.dart';
import '../../core/utils/string_manager.dart';
import '../../core/utils/style_manager.dart';

class HelloTopWidget extends StatelessWidget {
  const HelloTopWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AssetsManager.logoIMG,
          width: 100.w,
          height: 100.h,
        ),
        const Spacer(),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor,
            borderRadius: BorderRadiusDirectional.horizontal(
              start: Radius.circular(100.r),
            ),
          ),
          child: Text(
            StringManager.helloText,
            style: StyleManager.font20SemiBold(
                color: ColorManager.whiteColor
            ),
          ),
        )
      ],
    );
  }
}
