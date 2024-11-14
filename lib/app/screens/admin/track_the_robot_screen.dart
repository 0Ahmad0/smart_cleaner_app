import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/location_model.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import 'controllers/tracks_controller.dart';

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

   late
  Polyline _routeLine = Polyline(
    polylineId: PolylineId('route'),
    points: [_startPoint, _endPoint],
    color: Colors.blue,
    width: 4,
  );

  late TracksController controller;
  void initState() {
    controller = Get.put(TracksController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          StringManager.trackTheRobotText.toUpperCase(),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
          stream: controller.getLocations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return    ConstantsWidgets.circularProgress();
            } else if (snapshot.connectionState ==
                ConnectionState.active) {
              if (snapshot.hasError) {
                return  Text('Error');
              } else if (snapshot.hasData) {
                ConstantsWidgets.circularProgress();
                controller.locations.items.clear();
                if ((snapshot.data?.snapshot.children.length ?? 0) > 0) {
                  controller.locations.items = Locations.fromJsonReal(
                      snapshot.data!.snapshot.children).items;
                }
                controller.filterProviders(term: controller.searchController.value.text);
                return
                  GetBuilder<TracksController>(
                      builder: (TracksController tracksController)=>
                      tracksController.locations.items.isEmpty?
                      NoDataFoundWidget(text: "No Paths Yet",)
                          :
                      buildScreen(context, tracksController.locations.items));
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          })
    );
  }
  Widget buildScreen(BuildContext context,List<LocationModel> locations){
    _routeLine = Polyline(
      polylineId: PolylineId('route'),
      points:locations.map((e)=>LatLng(e.latitude??0,e.longitude??0)).toList(),// [_startPoint,  LatLng(29.37550, 47.9652), _endPoint],
      color: Colors.blue,
      width: 4,
    );
    return
      GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target:
          locations.length>0?
          LatLng(locations.first.latitude??0,locations.first.longitude??0):_kuwaitCenter,
          zoom: 14.0,
        ),
        markers:
        locations.map((e){
          if(locations.indexOf(e)==locations.length-1)
            return Marker(
              markerId: MarkerId('startPoint'),
              position:  LatLng(e.latitude??0,e.longitude??0),
              // position: _startPoint,
              infoWindow: InfoWindow(title: 'Start Point'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            );
          else    if(locations.indexOf(e)==0)
            return  Marker(

              markerId: MarkerId('endPoint'),
              position:  LatLng(e.latitude??0,e.longitude??0),
              // position: _endPoint,
              infoWindow: InfoWindow(title: 'End Point'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            );
          else
           return Marker(

              markerId: MarkerId('node${e.id}'),
              position:
              // LatLng(29.37550, 47.9652),
              LatLng(e.latitude??0,e.longitude??0),
              infoWindow: InfoWindow(title: 'Node'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            );
        }).toSet(),
        // {
        //   Marker(
        //     markerId: MarkerId('startPoint'),
        //     position: _startPoint,
        //     infoWindow: InfoWindow(title: 'Start Point'),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(
        //         BitmapDescriptor.hueGreen),
        //   ),
        //   Marker(
        //
        //     markerId: MarkerId('endPoint'),
        //     position: _endPoint,
        //     infoWindow: InfoWindow(title: 'End Point'),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(
        //         BitmapDescriptor.hueRed),
        //   ),
        // },
        polylines: {_routeLine},
      )
    ;
  }

}
