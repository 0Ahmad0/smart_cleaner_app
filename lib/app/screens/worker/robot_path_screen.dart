import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cleaner_app/app/screens/worker/widgets/robot_path_widget.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

import '../../../core/utils/color_manager.dart';

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
        ),
      ),
    );
    if (selectedPoint != null) {
      setState(() {
        if (isStartPoint) {
          _startPoint = selectedPoint;
        } else {
          _endPoint = selectedPoint;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Start and End Points"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
              child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return RobotPathWidget(
                      index: index + 1,
                    );
                  })),
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
      ),
    );
  }
}

class MapSelectionScreen extends StatefulWidget {
  final bool isStartPoint;

  const MapSelectionScreen({super.key, required this.isStartPoint});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng _initialPosition = const LatLng(29.3759, 47.9774);
  LatLng? _selectedPoint;

  @override
  Widget build(BuildContext context) {
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


