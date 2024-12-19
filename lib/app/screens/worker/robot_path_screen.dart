import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cleaner_app/app/controllers/profile_controller.dart';
import 'package:smart_cleaner_app/app/screens/worker/widgets/robot_path_widget.dart';
import 'package:smart_cleaner_app/core/enums/enums.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/location_model.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

import '../../../core/models/robot_model.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/string_manager.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import '../../controllers/workers_controller.dart';
import 'controllers/worker_robots_controller.dart';

class RobotPathWorkerScreen extends StatefulWidget {
  const RobotPathWorkerScreen({super.key});

  @override
  State<RobotPathWorkerScreen> createState() =>
      _RobotPathWorkerScreenState();
}

class _RobotPathWorkerScreenState extends State<RobotPathWorkerScreen> {
  LatLng? _startPoint;
  LatLng? _endPoint;

  Future<void> _navigateToMap(bool isStartPoint) async {
    final LatLng? selectedPoint = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionScreen(
          isStartPoint: isStartPoint,
          initialPosition: isStartPoint?_startPoint:_endPoint,
        ),
      ),
    );
    if (selectedPoint != null) {
      setState(() {
        if (isStartPoint) {
          _startPoint = selectedPoint;
          controller.robots.items.firstOrNull?.startPoint??=LocationModel();
          controller.robots.items.firstOrNull?.startPoint?.latitude=_startPoint?.latitude;
          controller.robots.items.firstOrNull?.startPoint?.longitude=_startPoint?.longitude;
        } else {
          _endPoint = selectedPoint;
          controller.robots.items.firstOrNull?.endPoint??=LocationModel();
          controller.robots.items.firstOrNull?.endPoint?.latitude=_endPoint?.latitude;
          controller.robots.items.firstOrNull?.endPoint?.longitude=_endPoint?.longitude;
        }
      });
      if( controller.robots.items.firstOrNull!=null)
      controller.updateRobot(context, controller.robots.items.first);
    }
  }
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
        title: const Text("Select Start and End Points"),
      ),
      body: StreamBuilder<DatabaseEvent>(
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
          }),
    );
  }
  Widget buildScreen(BuildContext context,List<RobotModel> robots){
    _startPoint=robots.first.startPoint?.getPoint;
    _endPoint=robots.first.endPoint?.getPoint;

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: ListView.builder(
                  itemCount: robots.length,
                  itemBuilder: (context, index) {
                    return RobotPathWidget(
                      index: index + 1,
                      robot: robots[index],
                    );
                  })),
          if(_startPoint!=null||_endPoint!=null)...[
            InkWell(
              onTap: (){
                context.pushNamed(Routes.selectPathRobotRoute,arguments: {
                  "startPoint":_startPoint,
                  "endPoint":_endPoint,
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                    color: ColorManager.enterButtonColor,
                    borderRadius:
                    BorderRadius.all( Radius.circular(100.r))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map,size: 20.w,color: ColorManager.whiteColor,),
                    SizedBox(width: 8.w,),
                    Text(
                      StringManager.showSelectedPath,
                      style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

    if(_startPoint!=null&&_endPoint!=null
        && (Get.put(ProfileController()).currentUser.value?.isWorker??false)
    )...[
      SizedBox(height: 10.h,),
      Visibility(
        visible: robots.firstOrNull?.getState==PowerCommand.shutdown,
        child: InkWell(
          onTap: (){
            Get.put(WorkersController()).startRobot(context,  robots.firstOrNull);
          },

          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
                color: ColorManager.successColor,
                borderRadius:
                BorderRadius.all( Radius.circular(100.r))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.start,size: 20.w,color: ColorManager.whiteColor,),
                SizedBox(width: 8.w,),
                Text(
                  StringManager.start,
                  style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      Visibility(
        visible: robots.firstOrNull?.getState==PowerCommand.start,
        child: InkWell(
          onTap: (){
            Get.put(WorkersController()).cancelRobot(context,  robots.firstOrNull);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
                color: ColorManager.errorColor,
                borderRadius:
                BorderRadius.all( Radius.circular(100.r))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_outlined,size: 20.w,color: ColorManager.whiteColor,),
                SizedBox(width: 8.w,),
                Text(
                  StringManager.cancel,
                  style: StyleManager.font18Medium(color: ColorManager.whiteColor).copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    ],

            Spacer()
          ]
        ,
          Divider(
            thickness: 10,
            color: ColorManager.tealColor,
            height: 1,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: InkWell(
                  onTap: () => _navigateToMap(true),
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    color: ColorManager.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Select start Point',style: StyleManager.font14SemiBold(
                            color: ColorManager.whiteColor
                        ),),
                        verticalSpace(10.sp),

                        Text(
                          _startPoint != null
                              ? 'Selected:\nLat: ${_startPoint!.latitude.toStringAsFixed(2)},\nLng: ${_startPoint!.longitude.toStringAsFixed(2)}'
                              : 'No Start Point Selected',
                          textAlign: TextAlign.center,
                          style: StyleManager.font12Regular(
                              color: ColorManager.whiteColor
                          ),
                        ),

                      ],
                    ),
                  ),
                )),
                horizontalSpace(2.sp),
                Expanded(child: InkWell(
                  onTap: () => _navigateToMap(false),
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    color: ColorManager.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Select end Point',style: StyleManager.font14SemiBold(
                            color: ColorManager.whiteColor
                        ),),
                        verticalSpace(10.sp),
                        Text(
                          _endPoint != null
                              ? 'Selected: \nLat: ${_endPoint!.latitude.toStringAsFixed(2)},\nLng: ${_endPoint!.longitude.toStringAsFixed(2)}'
                              : 'No End Point Selected',
                          textAlign: TextAlign.center,
                          style: StyleManager.font12Regular(
                              color: ColorManager.whiteColor
                          ),
                        ),

                      ],
                    ),

                  ),
                )),
              ],
            ),
          ),
        ],
      )
     ;
  }

}

class MapSelectionScreen extends StatefulWidget {
  final bool isStartPoint;
  final LatLng? initialPosition;

  const MapSelectionScreen({super.key, required this.isStartPoint, this.initialPosition});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng _initialPosition = const LatLng(29.3759, 47.9774);
  LatLng? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    _initialPosition=widget.initialPosition??_initialPosition;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isStartPoint ? 'Select Start Point' : 'Select End Point'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 16,
        ),
        onTap: (LatLng location) {
          setState(() {
            _selectedPoint = location;
          });
        },
        markers: _selectedPoint != null
            ? {
          Marker(
            markerId: MarkerId(widget.isStartPoint ? 'startPoint' : 'endPoint'),
            position: _selectedPoint!,
          )
        }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedPoint != null) {
            Navigator.pop(context, _selectedPoint);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}


