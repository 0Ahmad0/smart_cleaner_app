import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(12.r)
          ),
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
