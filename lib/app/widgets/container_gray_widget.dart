import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/color_manager.dart';

class ContainerGrayWidget extends StatelessWidget {
  const ContainerGrayWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 30.w),
      decoration: BoxDecoration(
        color: ColorManager.grayColor,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(
            50.r,
          ),
        ),
      ),
      child: child,
    );
  }
}
