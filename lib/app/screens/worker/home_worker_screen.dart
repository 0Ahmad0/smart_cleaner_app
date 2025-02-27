import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smart_cleaner_app/core/enums/enums.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/models/user_model.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/string_manager.dart';
import '../../../core/utils/style_manager.dart';
import '../../../core/widgets/app_padding.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fab_controller.dart';
import '../../widgets/container_home_widget.dart';
import 'controllers/worker_state_controller.dart';

class HomeWorkerScreen extends StatefulWidget {
  const HomeWorkerScreen({super.key});

  @override
  State<HomeWorkerScreen> createState() => _HomeWorkerScreenState();
}

class _HomeWorkerScreenState extends State<HomeWorkerScreen> {
  late WorkerStateController controller;
  final GlobalKey _startKey = GlobalKey();
  final GlobalKey _problemsKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _robotPathKey = GlobalKey();
  final GlobalKey _robotOnDutyKey = GlobalKey();
  final GlobalKey _weatherKey = GlobalKey();
  final GlobalKey _settingKey = GlobalKey();

  void initState() {
    controller = Get.put(WorkerStateController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  ShowCaseWidget(
        builder:  (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {

            if (Get.put(FabController()).checkIsFirst("HomeWorkerShowcase")) {
              ShowCaseWidget.of(context)?.startShowCase([
                _startKey,
                _settingKey,
                _weatherKey,
                _robotOnDutyKey,
                _robotPathKey,
                _notificationKey,
                _problemsKey
              ]);
            }
          });
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                child: CircleAvatar(),
              ),
              title: Text(StringManager.homeText.toUpperCase()),
              actions: [
                Showcase(
                  key: _startKey,
                  description: "Welcome to the worker section! I'm here to help you understand some sections. Click to continue and complete the instructions",
                  child: SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                horizontalSpace(6.w),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: controller.getWorkers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      controller.workers.users.clear();
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        controller.workers.users = Users.fromJson(
                            snapshot.data!.docs).users;

                      }
                      controller.filterWorkers(term: controller.searchController.value.text);

                    } }
                  return
                    GetBuilder<WorkerStateController>(
                        builder: (WorkerStateController workerStateController)=>
                            AppPaddingWidget(
                              child:


                              Column(
                                children: [
                                  verticalSpace(30.h),
                                  if(workerStateController.worker?.state==StateWorker.Accepted.name)...[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ContainerHomeWidget(
                                          casekey : _settingKey,
                                          caseDescription: "Adjust the robot settings according to your needs to ensure efficient operation",

                                          icon: Icons.settings_outlined,
                                          text: StringManager.settingText,
                                          color: ColorManager.hintTextColor,
                                          route: Routes.settingWorkerRoute,

                                        ),
                                        ContainerHomeWidget(
                                          casekey: _weatherKey,
                                          caseDescription: "Check the current weather conditions along with comprehensive statistics for the past month",

                                          icon: Icons.sunny_snowing,
                                          text: StringManager.weatherStatisticsText,
                                          color: ColorManager.tealColor,
                                          route: Routes.weatherRoute,

                                        ),
                                        ContainerHomeWidget(
                                          casekey: _robotOnDutyKey,
                                          caseDescription: "Cancel an active robot mission if it is no longer needed",

                                          icon: Icons.close_outlined,
                                          text: StringManager.cancelTripText,
                                          route: Routes.robotOnDutyWorkerRoute,
                                        ),

                                      ],
                                    ),
                                    verticalSpace(20.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Showcase(
                                        //   key: _robotPathKey,
                                        //   description: "Monitor the robot's path in real-time and modify it as needed for precise navigation",
                                        //   child:
                                        ContainerHomeWidget(
                                          casekey: _robotPathKey,
                                          caseDescription: "Monitor the robot's path in real-time and modify it as needed for precise navigation",

                                          icon: Icons.location_on_outlined,
                                          text: StringManager.locationText,
                                          route: Routes.robotPathWorkerRoute,
                                        ),
                                        // ),
                                        ContainerHomeWidget(
                                          casekey: _notificationKey,
                                          caseDescription: "View notifications related to issues and account updates",

                                          icon: Icons.notifications_active_outlined,
                                          text: StringManager.notificationText,
                                          color: ColorManager.hintTextColor,
                                          route: Routes.notificationWorkerRoute,
                                        ),

                                        ContainerHomeWidget(
                                          casekey: _problemsKey,
                                          caseDescription: "Access the list of reported issues for review and resolution",

                                          icon: Icons.details,
                                          text: StringManager.problemsText,
                                          color: ColorManager.tealColor,
                                          route: Routes.problemsWorkerRoute,
                                        ),

                                      ],
                                    ),
                                  ]
                                  else ...[
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: ColorManager.grayColor,
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(color: ColorManager.primaryColor, width: 1.w),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              workerStateController.worker?.state == StateWorker.Rejected.name
                                                  ? Icons.cancel
                                                  : Icons.hourglass_empty,
                                              size: 50.sp,
                                              color: workerStateController.worker?.state == StateWorker.Rejected.name
                                                  ? ColorManager.errorColor
                                                  :ColorManager.orangeColor,
                                            ),
                                            verticalSpace(10.h),
                                            Text(
                                              workerStateController.worker?.state == StateWorker.Rejected.name

                                                  ?    "Your request to be a worker has been rejected by the admin."
                                                  : "Your request to be a worker is still pending.",
                                              style: StyleManager.font16Regular(
                                                color: ColorManager.primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,

                                  verticalSpace(10.h),

                                  ListTile(
                                    onTap: () {
                                      Get.lazyPut(() => AuthController());
                                      AuthController.instance.signOut(context);
                                    },
                                    title:Text(

                                      StringManager.logoutText,
                                      // textAlign: TextAlign.center,
                                      style: StyleManager.font16Regular(
                                          color: ColorManager.primaryColor),
                                    ) ,
                                    leading:  Icon(Icons.logout,size: 20.sp,),

                                  ),
                                ],
                              ),
                            ));
                }),
          );
        }
    );
  }
}
