
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/models/weather_model.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/profile_controller.dart';

class WeathersController extends GetxController{

  final searchController = TextEditingController();
  Weathers weathers=Weathers(items: []);
  // Weathers weathersWithFilter=Weathers(items: []);
  WeatherModel? weather;
  String? uid;
  var getWeathers;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getWeathersFun();
    super.onInit();
    }

  getWeathersFun() async {
    getWeathers =_fetchWeathersStream();
    return getWeathers;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchWeathersStream() {
    final result = FirebaseFun.database
        .child(FirebaseConstants.collectionWeather)
        .onValue;
    return result;
  }
  filterWeathers({required String term}) async {
    // WeathersWithFilter.items=[];
    weathers.items.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;       // كلاهما null
      if (a.timestamp == null) return 1;                              // a null، ضعها بعد b
      if (b.timestamp == null) return -1;                             // b null، ضعها بعد a
      return b.timestamp!.compareTo(a.timestamp!);                    // كلاهما غير null
    });
    weather=weathers.items.firstOrNull;
     update();
  }
  classification() async {
    // WeathersWithFilter.items.clear();
    // Weathers.items.forEach((element) {
    //   });
    update();
  }

}
