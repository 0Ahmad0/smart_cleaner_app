import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';

class RobotPathWidget extends StatelessWidget {
  const RobotPathWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: ColorManager.grayColor,
          borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: (){
          context.pushNamed(Routes.trackTheRobotRoute);
        },
        contentPadding: EdgeInsets.zero,
        dense: true,
        isThreeLine: true,
        leading: SvgPicture.asset(
          AssetsManager.robotIcon,
          width: 50.w,
          height: 50.h,
        ),
        title: Text('SSC 00$index'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Robot Description'),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () {
                      context.pushNamed(Routes.trackTheRobotRoute);
                    },
                    icon: Icon(Icons.visibility_outlined),
                    label: Text(StringManager.viewRobotText),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
