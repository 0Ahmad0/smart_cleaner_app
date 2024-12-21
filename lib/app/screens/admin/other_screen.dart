import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

import '../../../core/models/robot_model.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import '../../controllers/workers_controller.dart';
import '../worker/controllers/worker_robots_controller.dart';

class OtherAdminScreen extends StatefulWidget {
  const OtherAdminScreen({super.key});

  @override
  _OtherAdminScreenState createState() => _OtherAdminScreenState();
}

class _OtherAdminScreenState extends State<OtherAdminScreen> {
  bool isCharged = false; // حالة الروبوت (مشحون أو غير مشحون)
  bool  isDumping  = false;

  late WorkerRobotsController controller;
  void initState() {
    controller = Get.put(WorkerRobotsController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            StringManager.otherText.toUpperCase(),
          ),
        ),
        body:
        StreamBuilder<DatabaseEvent>(
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
                  controller.filterProviders(term: controller.searchController.value.text);
                  return
                    GetBuilder<WorkerRobotsController>(
                        builder: (WorkerRobotsController workerRobotsController)=>
                        workerRobotsController.robotsWithFilter.items.isEmpty?
                        NoDataFoundWidget(text: "No Robots Yet",)
                            :
                        buildScreen(context, workerRobotsController.robotsWithFilter.items));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            })


    );
  }
  Widget buildScreen(BuildContext context, List<RobotModel> robots) {
    isCharged = robots.first.isCharged;
    isDumping = robots.first.isDumping; // تأكد من أن نموذج الروبوت يحتوي على حالة isDumping

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isCharged ? 'The robot is charging' : '',
            style: StyleManager.font20Bold(
              color: isCharged ? ColorManager.primaryColor : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            !isDumping ? '' : 'The robot is dumping trash',
            style: StyleManager.font20Bold(
              color: isDumping ? ColorManager.primaryColor : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.put(WorkersController()).toggleChargingRobot(context, robots.firstOrNull);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isCharged ? ColorManager.successColor : ColorManager.errorColor,
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                   "Forced Charging",
                    style: StyleManager.font18Medium(color: ColorManager.whiteColor)
                        .copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 10), // مسافة بين النص و الـ Switch
                  Switch(
                    value: isCharged,
                    onChanged: (value) {
                      // تحديث الحالة عند تغيير المفتاح
                      Get.put(WorkersController()).toggleChargingRobot(context, robots.firstOrNull);
                    },
                    activeColor: ColorManager.successColor, // لون المفتاح عند التفعيل
                    activeTrackColor:Colors.white,
                    inactiveThumbColor: ColorManager.errorColor, // لون المفتاح عند التعطيل
                    inactiveTrackColor: Colors.white, // لون المسار عند التعطيل
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.put(WorkersController()).toggleDumpingRobot(context, robots.firstOrNull);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isDumping ? ColorManager.successColor : ColorManager.errorColor,
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Forced Dumping",
                    style: StyleManager.font18Medium(color: ColorManager.whiteColor)
                        .copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 10), // مسافة بين النص و الـ Switch
                  Switch(
                    value: isDumping,
                    onChanged: (value) {
                      // تحديث الحالة عند تغيير المفتاح
                      Get.put(WorkersController()).toggleDumpingRobot(context, robots.firstOrNull);
                    },
                    activeColor: ColorManager.successColor, // لون المفتاح عند التفعيل
                    activeTrackColor:Colors.white,
                    inactiveThumbColor: ColorManager.errorColor, // لون المفتاح عند التعطيل
                    inactiveTrackColor: Colors.white, // لون المسار عند التعطيل
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScreen1(BuildContext context,List<RobotModel> robots){
    isCharged=robots.first.isCharged;
    isDumping = robots.first.isDumping;

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Align(
          //   alignment: AlignmentDirectional.center,
          //   child: Text(
          //     'COMING SOON...',
          //     textAlign: TextAlign.center,
          //     style: StyleManager.font30Bold(
          //       color: ColorManager.primaryColor,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 30),
          Text(
            isCharged ? 'The robot is charging' : 'The robot is dumping trash',
            // isCharged ? 'The robot is fully charged' : 'The robot is discharged',
            style: StyleManager.font20Bold(
              color: isCharged
                  ? ColorManager.primaryColor
                  : Colors.red, // لون النص بناءً على حالة الروبوت
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Get.put(WorkersController()).chargingRobot(context,  robots.firstOrNull);
                  // setState(() {
                  //   isCharged = true;
                  // });
                },

                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                      color: ColorManager.successColor,
                      borderRadius:
                      BorderRadius.all( Radius.circular(100.r))),
                  child: Text(
                    "Forced Charging",
                    // StringManager.start,
                    style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
                  ),
                ),
              )
              ,
              const SizedBox(width: 20),
              InkWell(
                onTap: (){
                  // setState(() {
                  //   isCharged = false;
                  // });
                  Get.put(WorkersController()).dumpingRobot(context,  robots.firstOrNull);
                },

                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                      color: ColorManager.errorColor,
                      borderRadius:
                      BorderRadius.all( Radius.circular(100.r))),
                  child: Text(
                    "Forced dumping",
                    // StringManager.start,
                    style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
                  ),
                ),
              ),

              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         isCharged = true; // تغيير حالة الروبوت إلى مشحون
              //       });
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: ColorManager.primaryColor,
              //     ),
              //     child: const Text('شحن الروبوت'),
              //   ),
              // ),
              // const SizedBox(width: 20),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         isCharged = false; // تغيير حالة الروبوت إلى مفرغ الشحن
              //       });
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red,
              //     ),
              //     child: const Text('تفريغ الشحن'),
              //   ),
              // ),
            ],
          ),
        ],
      )
    ;
  }
}



// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:smart_cleaner_app/core/utils/color_manager.dart';
// import 'package:smart_cleaner_app/core/utils/string_manager.dart';
// import 'package:smart_cleaner_app/core/utils/style_manager.dart';
//
// import '../../../core/models/robot_model.dart';
// import '../../../core/widgets/constants_widgets.dart';
// import '../../../core/widgets/no_data_found_widget.dart';
// import '../../controllers/workers_controller.dart';
// import '../worker/controllers/worker_robots_controller.dart';
//
// class OtherAdminScreen extends StatefulWidget {
//   const OtherAdminScreen({super.key});
//
//   @override
//   _OtherAdminScreenState createState() => _OtherAdminScreenState();
// }
//
// class _OtherAdminScreenState extends State<OtherAdminScreen> {
//   bool isCharged = false; // حالة الروبوت (مشحون أو غير مشحون)
//
//   late WorkerRobotsController controller;
//   void initState() {
//     controller = Get.put(WorkerRobotsController());
//     controller.onInit();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           StringManager.otherText.toUpperCase(),
//         ),
//       ),
//       body:
//       StreamBuilder<DatabaseEvent>(
//           stream: controller.getRobots,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return    ConstantsWidgets.circularProgress();
//             } else if (snapshot.connectionState ==
//                 ConnectionState.active) {
//               if (snapshot.hasError) {
//                 return  Text('Error');
//               } else if (snapshot.hasData) {
//                 ConstantsWidgets.circularProgress();
//                 controller.robots.items.clear();
//                 if ((snapshot.data?.snapshot.children.length ?? 0) > 0) {
//                   controller.robots.items = Robots.fromJsonReal(
//                       snapshot.data!.snapshot.children).items;
//
//                 }
//                 controller.filterProviders(term: controller.searchController.value.text);
//                 return
//                   GetBuilder<WorkerRobotsController>(
//                       builder: (WorkerRobotsController workerRobotsController)=>
//                       workerRobotsController.robotsWithFilter.items.isEmpty?
//                       NoDataFoundWidget(text: "No Robots Yet",)
//                           :
//                       buildScreen(context, workerRobotsController.robotsWithFilter.items));
//               } else {
//                 return const Text('Empty data');
//               }
//             } else {
//               return Text('State: ${snapshot.connectionState}');
//             }
//           })
//
//
//     );
//   }
//   Widget buildScreen(BuildContext context,List<RobotModel> robots){
//     isCharged=robots.first.isCharged;
//
//     return
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Align(
//           //   alignment: AlignmentDirectional.center,
//           //   child: Text(
//           //     'COMING SOON...',
//           //     textAlign: TextAlign.center,
//           //     style: StyleManager.font30Bold(
//           //       color: ColorManager.primaryColor,
//           //     ),
//           //   ),
//           // ),
//           // const SizedBox(height: 30),
//           Text(
//             isCharged ? 'The robot is charging' : 'The robot is dumping trash',
//             // isCharged ? 'The robot is fully charged' : 'The robot is discharged',
//             style: StyleManager.font20Bold(
//               color: isCharged
//                   ? ColorManager.primaryColor
//                   : Colors.red, // لون النص بناءً على حالة الروبوت
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               InkWell(
//                 onTap: (){
//                   Get.put(WorkersController()).chargingRobot(context,  robots.firstOrNull);
//                   // setState(() {
//                   //   isCharged = true;
//                   // });
//                 },
//
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                   decoration: BoxDecoration(
//                       color: ColorManager.successColor,
//                       borderRadius:
//                       BorderRadius.all( Radius.circular(100.r))),
//                   child: Text(
//                     "Forced Charging",
//                     // StringManager.start,
//                     style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
//                   ),
//                 ),
//               )
//               ,
//               const SizedBox(width: 20),
//               InkWell(
//                 onTap: (){
//                   // setState(() {
//                   //   isCharged = false;
//                   // });
//                   Get.put(WorkersController()).dumpingRobot(context,  robots.firstOrNull);
//                 },
//
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                   decoration: BoxDecoration(
//                       color: ColorManager.errorColor,
//                       borderRadius:
//                       BorderRadius.all( Radius.circular(100.r))),
//                   child: Text(
//                     "Forced dumping",
//                     // StringManager.start,
//                     style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
//                   ),
//                 ),
//               ),
//
//               // Expanded(
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       setState(() {
//               //         isCharged = true; // تغيير حالة الروبوت إلى مشحون
//               //       });
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: ColorManager.primaryColor,
//               //     ),
//               //     child: const Text('شحن الروبوت'),
//               //   ),
//               // ),
//               // const SizedBox(width: 20),
//               // Expanded(
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       setState(() {
//               //         isCharged = false; // تغيير حالة الروبوت إلى مفرغ الشحن
//               //       });
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.red,
//               //     ),
//               //     child: const Text('تفريغ الشحن'),
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       )
//     ;
//   }
// }
