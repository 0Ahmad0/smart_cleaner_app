import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../../core/models/robot_model.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/style_manager.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import 'controllers/worker_robots_controller.dart';

class RobotOnDutyScreen extends StatefulWidget {
  const RobotOnDutyScreen({super.key});

  @override
  State<RobotOnDutyScreen> createState() => _RobotOnDutyScreenState();
}

class _RobotOnDutyScreenState extends State<RobotOnDutyScreen> {
  late WorkerRobotsController controller;

  @override
  void initState() {
    controller = Get.put(WorkerRobotsController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.robotOnDutyText.toUpperCase()),
      ),
      body: Column(
        children: [
          AppPaddingWidget(
            child: AppTextField(
              hintText: StringManager.searchText,
              onChanged: (value)=>  controller.filterTrip(term: value),
            ),
          ),
          Expanded(
            child:StreamBuilder<DatabaseEvent>(
                stream: controller.getRobots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return    ConstantsWidgets.circularProgress();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasError) {
                      return  Text('Error');
                    } else if (snapshot.hasData) {
                      ConstantsWidgets.circularProgress();
                      controller.robots.items.clear();
                      if ((snapshot.data?.snapshot.children.length ?? 0) > 0) {
                        controller.robots.items = Robots.fromJsonReal(
                            snapshot.data!.snapshot.children).items;

                      }
                      controller.filterTrip(term: controller.searchController.value.text);
                      return
                        GetBuilder<WorkerRobotsController>(
                            builder: (WorkerRobotsController workerRobotsController)=>
                            workerRobotsController.robotsWithFilter.items.isEmpty?
                            NoDataFoundWidget(text: "No Trip Robots Yet",)
                                :
                            buildProblems(context, workerRobotsController.robotsWithFilter.items));
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                }),
          ),
        ],
      ),
    );
  }
  Widget buildProblems(BuildContext context,List<RobotModel> robots){
    return
      ListView.builder(
        itemCount: robots.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
              color: ColorManager.grayColor,
              borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            isThreeLine: true,
            onTap: () {
              context.pushNamed(Routes.cancelTripWorkerRoute, arguments: {
                "robot":robots[index],
                'index':index+1
              });
            },
            contentPadding: EdgeInsetsDirectional.only(start: 20.w),
            leading: SvgPicture.asset(
              AssetsManager.robotIcon,
              width: 40.w,
              height: 40.h,
            ),
            title: Text(robots[index].name??'SSC 00${index + 1}'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Robot is facing a garbage',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StyleManager.font12Regular(
                        color: ColorManager.blackColor.withOpacity(.5)),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                        onPressed: () {
                          context.pushNamed(
                              Routes.cancelTripWorkerRoute,
                              arguments: {
                                'index':index+1,
                                "robot":robots[index]
                              }
                          );
                        },
                        icon: Icon(Icons.highlight_remove_outlined),
                        label: Text(
                          StringManager.cancelTripText,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }

}
