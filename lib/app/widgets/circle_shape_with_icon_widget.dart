import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/color_manager.dart';

class CircleShapeWithIconWidget extends StatelessWidget {
  const CircleShapeWithIconWidget({
    super.key, required this.icon,
  });
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80.r,
      child: Icon(
        icon,
        color: ColorManager.primaryColor,
        size: 60.sp,
      ),
    );
  }
}
