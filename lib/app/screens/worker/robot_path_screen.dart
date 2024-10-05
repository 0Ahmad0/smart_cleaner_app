import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cleaner_app/core/helpers/sizer.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import 'widgets/robot_path_widget.dart';

class RobotPathWorkerScreen extends StatefulWidget {
  const RobotPathWorkerScreen({super.key});

  @override
  State<RobotPathWorkerScreen> createState() => _RobotPathWorkerScreenState();
}

class _RobotPathWorkerScreenState extends State<RobotPathWorkerScreen> {
  late GoogleMapController mapController;

  // Define the locations
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('location1'),
      position: LatLng(29.3759, 47.9774), // Example location 1
      infoWindow: InfoWindow(title: 'Location 1'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('location2'),
      position: LatLng(29.3755, 47.9754), // Example location 2
      infoWindow: InfoWindow(title: 'Location 2'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('location3'),
      position: LatLng(29.3765, 47.9784), // Example location 3
      infoWindow: InfoWindow(title: 'Location 3'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('location4'),
      position: LatLng(29.3761, 47.9764), // Example location 4
      infoWindow: InfoWindow(title: 'Location 4'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('location5'),
      position: LatLng(29.3749, 47.9794), // Example location 5
      infoWindow: InfoWindow(title: 'Location 5'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringManager.robotPathText.toUpperCase(),
        ),
      ),
      body: Column(
        children: <Widget>[
          AppPaddingWidget(
            child: AppTextField(
              hintText: StringManager.searchText,
              iconData: Icons.search,
            ),
          ),
          Expanded(
              child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
            return RobotPathWidget(
              index: index + 1,
            );
          })),
          Divider(
            thickness: 10.sp,
            color: ColorManager.tealColor,
            height: 1.sp,
          ),
          Expanded(
              child: GoogleMap(
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(29.3759, 47.9774),
              zoom: 16,
            ),
            markers: _markers,
          ))
        ],
      ),
    );
  }
}
