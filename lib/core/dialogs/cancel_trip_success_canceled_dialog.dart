import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

class CancelTripSuccessCanceledDialog extends StatelessWidget {
  const CancelTripSuccessCanceledDialog({
    super.key,
    this.index = 0,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppPaddingWidget(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: ColorManager.grayColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: ColorManager.tealColor, width: 4.sp)),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  verticalSpace(20.h),
                  SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 80.w,
                    height: 80.h,
                  ),
                  verticalSpace(40.h),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(children: [
                      TextSpan(
                          text: 'SSC ${00}',
                          style: StyleManager.font20SemiBold(
                              color: ColorManager.tealColor)),
                      TextSpan(
                          text:
                              '  ' + StringManager.tripSuccessfullyCanceledText,
                          style: StyleManager.font18Medium()),
                    ]),
                  ),
                  verticalSpace(20.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      onTap: (){
                        context.pop();
                      },
                      child: Text(
                        StringManager.okText,
                        style: StyleManager.font14SemiBold(
                          color: ColorManager.tealColor
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(20.h),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}