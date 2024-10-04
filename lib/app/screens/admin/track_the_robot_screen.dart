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
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(29.3759, 47.9774),
    zoom: 14.4746,
  );
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
      appBar: AppBar(
        title: Text(
          StringManager.trackTheRobotText.toUpperCase(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: ColorManager.whiteColor,
                  child: GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                AppPaddingWidget(
                  child: AppTextField(
                    iconData: Icons.search,
                    hintText: StringManager.enterRobotNameHintText,
                  ),
                ),

              ],
            ),
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                color: ColorManager.primaryColor.withOpacity(.6),
              ),
              PositionedDirectional(
                top: -26,
                start: 0,
                end: 0,
                child: AppPaddingWidget(
                  verticalPadding: 0.0,
                  horizontalPadding: 100.w,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorManager.enterButtonColor,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                              color: ColorManager.hintTextColor, width: 4.sp)),
                    ),
                    onPressed: () {},
                    child: Text(
                      StringManager.enterText,
                      style: StyleManager.font16Regular(
                          color: ColorManager.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
