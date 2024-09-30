import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/sizer.dart';

import '../../core/helpers/spacing.dart';
import '../../core/utils/color_manager.dart';
import '../../core/utils/style_manager.dart';

class ContainerHomeWidget extends StatelessWidget {
  const ContainerHomeWidget({
    super.key,
    required this.icon,
    required this.text,
    this.color = ColorManager.primaryColor,
     this.route  = '',
  });

  final IconData icon;
  final String text;
  final String route;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: (){
          context.pushNamed(route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: color.withOpacity(.9),
                  borderRadius: BorderRadius.circular(2.r)),
              child: Icon(
                icon,
                size: 30.sp,
                color: ColorManager.whiteColor,
              ),
            ),
            verticalSpace(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: StyleManager.font14SemiBold(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
