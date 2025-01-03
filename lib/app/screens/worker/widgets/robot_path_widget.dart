import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/models/info_robot_model.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import 'live_feed_widget.dart';

class RobotPathWidget extends StatelessWidget {
  const RobotPathWidget({
    super.key,
    required this.index, this.robot, this.infoRobot,
  });

  final int index;
  final RobotModel? robot;
  final InfoRobotModel? infoRobot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: ColorManager.grayColor,
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          Column(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsManager.robotIcon,
                width: 50.w,
                height: 50.h,
              ),
              SizedBox(height: 6.h,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "${infoRobot?.batteryLevel??""}",style: TextStyle(color: ColorManager.primaryColor),),
                  Icon(Icons.energy_savings_leaf_outlined,size: 20.sp,color: ColorManager.successColor,)
                ],
              ),
              SizedBox(height: 24.h,)
            ],
          ),
          SizedBox(width: 10.w,),
          Expanded(
            child: ListTile(
              onTap: (){
                context.pushNamed(Routes.trackTheRobotRoute);
              },
              contentPadding: EdgeInsets.zero,

              // dense: true,
              // isThreeLine: true,
              // leading: SizedBox.shrink(),
              title:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      robot?.name??
                      'SSC 00$index'),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(

                      onPressed: () async {
                        await Get.dialog(
                            AlertDialog(
                              content: LiveFeedWidget(),
                            ));

                      },
                      icon: Icon(Icons.pageview_outlined),
                      label: Text(StringManager.viewLiveFeedText),
                    ),
                  )
                ],
              ),
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
                          onPressed: () async {

                            context.pushNamed(Routes.trackTheRobotRoute,
                            arguments: {"robot":robot}
                            );
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
          ),
        ],
      ),
    );
  }
}
