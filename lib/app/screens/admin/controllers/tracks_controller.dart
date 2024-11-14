
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/core/models/location_model.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/profile_controller.dart';

class TracksController extends GetxController{

  final searchController = TextEditingController();
  Locations locations=Locations(items: []);
  Locations locationsWithFilter=Locations(items: []);
  String? uid;
  var getLocations;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getLocationsFun();
    super.onInit();
    }

  getLocationsFun() async {
    getLocations =_fetchLocationsStream();
    return getLocations;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchLocationsStream() {
    final result = FirebaseFun.database
        .child(FirebaseConstants.collectionTrack)
        .onValue;
    return result;
  }
  filterProviders({required String term}) async {

    locations.items.sort((a, b) {
      if (a.dateTime == null && b.dateTime == null) return 0;       // كلاهما null
      if (a.dateTime == null) return 1;                              // a null، ضعها بعد b
      if (b.dateTime == null) return -1;                             // b null، ضعها بعد a
      return b.dateTime!.compareTo(a.dateTime!);                    // كلاهما غير null
    });

     update();
  }
  classification() async {
    // LocationsWithFilter.items.clear();
    // Locations.items.forEach((element) {
    //   });
    update();
  }


}
