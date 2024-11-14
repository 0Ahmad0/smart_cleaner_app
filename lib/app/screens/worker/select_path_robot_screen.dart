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

class SelectPathRobotScreen extends StatefulWidget {
  const SelectPathRobotScreen({super.key});

  @override
  State<SelectPathRobotScreen> createState() => _SelectPathRobotScreenState();
}

class _SelectPathRobotScreenState extends State<SelectPathRobotScreen> {
  late GoogleMapController mapController;

   LatLng _kuwaitCenter = const LatLng(29.3759, 47.9774);

   LatLng? _startPoint = LatLng(29.3786, 47.9903);
   LatLng? _endPoint = LatLng(29.3720, 47.9642);

  late  Polyline _routeLine = Polyline(
    polylineId: PolylineId('route'),
    points: [_startPoint, _endPoint].whereType<LatLng>().toList(),
    color: Colors.blue,
    width: 4,
  );

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map?;
    _startPoint=args?['startPoint'];
    _endPoint=args?['endPoint'];

    _kuwaitCenter=_endPoint??_startPoint??_kuwaitCenter;
    _routeLine = Polyline(
      polylineId: PolylineId('route'),
      points: [_startPoint, _endPoint].whereType<LatLng>().toList(),
      color: Colors.blue,
      width: 4,
    );
    Set<Marker> markers={};
    if(_startPoint!=null){
      markers.add(Marker(
        markerId: MarkerId('startPoint'),
        position: _startPoint!,
        infoWindow: InfoWindow(title: 'Start Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
      ));
    }
    if(_endPoint!=null){
      markers.add( Marker(

        markerId: MarkerId('endPoint'),
        position: _endPoint!,
        infoWindow: InfoWindow(title: 'End Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
      ),);
    }

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
        markers: markers,
        polylines: {_routeLine},
      ),
    );
  }
}
