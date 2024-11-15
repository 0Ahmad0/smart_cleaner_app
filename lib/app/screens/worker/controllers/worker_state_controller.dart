
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/app/controllers/profile_controller.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/models/user_model.dart';
import 'package:smart_cleaner_app/core/utils/app_constant.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';

class WorkerStateController extends GetxController{

  final searchController = TextEditingController();
  Users workers=Users(users: []);
  UserModel? worker;
  String? uid;
  var getWorkers;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getWorkersFun();
    super.onInit();
    }

  getWorkersFun() async {
    getWorkers =_fetchWorkersStream();
    return getWorkers;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchWorkersStream() {
    final result = FirebaseFirestore.instance.collection(FirebaseConstants.collectionUser)
    .where("uid",isEqualTo: uid)
    .snapshots()
    ;
    return result;
  }
  filterWorkers({required String term}) async {

    worker=workers.users.where((e)=>e.uid==uid).firstOrNull;
     update();
  }



}
