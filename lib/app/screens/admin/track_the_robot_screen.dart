import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

class TrackTheRobotScreen extends StatefulWidget {
  const TrackTheRobotScreen({super.key});

  @override
  State<TrackTheRobotScreen> createState() => _TrackTheRobotScreenState();
}

class _TrackTheRobotScreenState extends State<TrackTheRobotScreen> {
  late GoogleMapController mapController;

  final LatLng _kuwaitCenter = const LatLng(29.3759, 47.9774);

  final LatLng _startPoint = LatLng(29.3786, 47.9903);
  final LatLng _endPoint = LatLng(29.3720, 47.9642);

  late final Polyline _routeLine = Polyline(
    polylineId: PolylineId('route'),
    points: [_startPoint, _endPoint],
    color: Colors.blue,
    width: 4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          StringManager.trackTheRobotText.toUpperCase(),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _kuwaitCenter,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('startPoint'),
            position: _startPoint,
            infoWindow: InfoWindow(title: 'Start Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
          Marker(

            markerId: MarkerId('endPoint'),
            position: _endPoint,
            infoWindow: InfoWindow(title: 'End Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ),
        },
        polylines: {_routeLine},
      ),
    );
  }
}
