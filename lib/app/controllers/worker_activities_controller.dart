


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_cleaner_app/app/controllers/profile_controller.dart';
import '../../core/models/activity_model.dart';
import 'firebase/firebase_constants.dart';
import 'firebase/firebase_fun.dart';
import 'package:get/get_core/src/get_main.dart';

class WorkerActivitiesController extends GetxController{

  Activities activities=Activities(items: []);
  Activities seenActivities=Activities(items: []);
  Activities unSeenActivities=Activities(items: []);
  String? uid;
  var getActivities;

  @override
  void onInit() {
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getActivitiesFun();
    super.onInit();
    }

  getActivitiesFun() async {
    getActivities =_fetchActivitiesStream();
    return getActivities;
  }
  @override
  void dispose() {
    super.dispose();
  }


  _fetchActivitiesStream() {
    final result= FirebaseFirestore.instance
        .collection(FirebaseConstants.collectionActivity)
        // .where('idUser',isEqualTo: uid)
        .snapshots();
    return result;
  }

  filterActivities(){
    seenActivities.items.clear();
    unSeenActivities.items.clear();
    activities.items.forEach((element) {
      if(element.checkRec)
        seenActivities.items.add(element);
      else
        unSeenActivities.items.add(element);
    });
  }

  addActivity(BuildContext context ,{ required ActivityModel activity}) async {
    var result;
    // ConstantsWidgets.showLoading();
    // Activity.idUser??=uid??Get.put(ProfileController()).currentUser.value?.uid;
    result =await FirebaseFun.addActivity(activity: activity);
    //print(result);
    //   Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    // ConstantsWidgets.closeDialog();
  }

  updateActivity(context,{ required ActivityModel activity}) async {
    var result;
    result =await FirebaseFun.updateActivity(activity: activity);

    // Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }


}
