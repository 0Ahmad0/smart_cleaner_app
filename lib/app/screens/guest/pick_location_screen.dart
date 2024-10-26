import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

import 'controllers/guest_problem_controller.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition? cameraPosition; // Make it nullable
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get current location on init
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle it
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Set the camera position to the user's current location
    setState(() {
      cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraPosition == null // Check if camera position is ready
          ? Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                MapPicker(
                  iconWidget: Icon(
                    Icons.location_on,
                    size: 60.sp,
                    color: ColorManager.errorColor,
                  ),
                  mapPickerController: mapPickerController,
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    initialCameraPosition: cameraPosition!,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMoveStarted: () {
                      mapPickerController.mapMoving!();
                      locationController.text = "checking ...";
                    },
                    onCameraMove: (cameraPosition) {
                      this.cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () async {
                      mapPickerController.mapFinishedMoving!();
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        cameraPosition!.target.latitude,
                        cameraPosition!.target.longitude,
                      );

                      // update the ui with the address

                      locationController.text =
                          '${placemarks.first.name},'
                          '${placemarks.first.country},'
                              ' ${placemarks.first.street},'
                              ' ${placemarks.first.country}';
                    },
                  ),
                ),
                PositionedDirectional(
                  top: MediaQuery.of(context).viewPadding.top + 20,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration:  InputDecoration(
                      filled: true,
                        fillColor: ColorManager.whiteColor.withOpacity(.1),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,),
                    controller: locationController,
                  ),
                ),
                PositionedDirectional(
                  bottom: 20.h,
                  start: 20.w,
                  end: 20.w,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        minimumSize: Size(double.maxFinite, 50.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r))),
                    child: Text(
                      StringManager.submitText,
                      style: StyleManager.font16Regular(
                          color: ColorManager.whiteColor),
                    ),
                    onPressed: () {
                      print(
                          "Location ${cameraPosition!.target.latitude} ${cameraPosition!.target.longitude}");
                      print("Address: ${locationController.text}");
                      Get.put(GuestProblemController()).addLocation(address: locationController.text,longitude: cameraPosition!.target.longitude, latitude: cameraPosition!.target.latitude);
                  Get.back();
                      },
                  ),
                )
              ],
            ),
    );
  }
}
