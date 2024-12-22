
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/models/weather_model.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/info_robot_model.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/profile_controller.dart';

class InfoRobotController extends GetxController{

  final searchController = TextEditingController();
  InfoRobots infoRobots=InfoRobots(items: []);
  InfoRobotModel? infoRobot;
  String? uid;
  var getInfoRobots;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getInfoRobotsFun();
    super.onInit();
    }

  getInfoRobotsFun() async {
    getInfoRobots =_fetchInfoRobotsStream();
    return getInfoRobots;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchInfoRobotsStream() {
    final result = FirebaseFun.database
        .child(FirebaseConstants.collectionInfoRobot)
        .onValue;
    return result;
  }
  filterInfoRobots({required String term}) async {
    // InfoRobotsWithFilter.items=[];
    infoRobots.items.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;       // كلاهما null
      if (a.timestamp == null) return 1;                              // a null، ضعها بعد b
      if (b.timestamp == null) return -1;                             // b null، ضعها بعد a
      return b.timestamp!.compareTo(a.timestamp!);                    // كلاهما غير null
    });
    infoRobot=infoRobots.items.firstOrNull;
     update();
  }
  classification() async {
    // InfoRobotsWithFilter.items.clear();
    // InfoRobots.items.forEach((element) {
    //   });
    update();
  }

}
