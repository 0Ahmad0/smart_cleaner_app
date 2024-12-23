
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/profile_controller.dart';

class WorkerRobotsController extends GetxController{

  final searchController = TextEditingController();
  Robots robots=Robots(items: []);
  Robots robotsWithFilter=Robots(items: []);
  String? uid;
  var getRobots;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getRobotsFun();
    super.onInit();
    }

  getRobotsFun() async {
    getRobots =_fetchRobotsStream();
    return getRobots;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchRobotsStream() {
    final result = FirebaseFun.database
        .child(FirebaseConstants.collectionRobot)
        .onValue;
    return result;
  }
  filterProviders({required String term}) async {

    robotsWithFilter.items=[];
    robots.items.forEach((element) {

      if((element.name?.toLowerCase().contains(term.toLowerCase())??false))
        robotsWithFilter.items.add(element);
    });
     update();
  }
  filterTrip({required String term}) async {
    robotsWithFilter.items.clear();
    robots.items.forEach((element) {
      if((element.name?.toLowerCase().contains(term.toLowerCase())??false))
        if(element.startPoint!=null&&element.endPoint!=null)
          if(element.getState==PowerCommand.start||element.getState==PowerCommand.shutdown)
          robotsWithFilter.items.add(element);
    });
    update();
  }
  classification() async {
    robotsWithFilter.items.clear();
    // robots.items.forEach((element) {
    //   if((element.name?.toLowerCase().contains(term.toLowerCase())??false))
    //   if(element.startPoint!=null&&element.endPoint!=null)
    //     robotsWithFilter.items.add(element);
    //   });
    update();
  }

  changeModeRobot(BuildContext context ,RobotModel? robot) async {
  var result;
  if(robot==null)
    return;
  // ConstantsWidgets.showLoading();
  robot.mode=!robot.mode;
  result = await FirebaseFun.updateRobotReal(robot: robot);
  // ConstantsWidgets.closeDialog();
  if(!result['status']){
    robot.mode=!robot.mode;
    ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);

  }
  }

  updateRobot(BuildContext context ,RobotModel? robot) async {
    var result;
    if(robot==null)
      return;
    ConstantsWidgets.showLoading();
    result = await FirebaseFun.updateRobotReal(robot: robot);
    ConstantsWidgets.closeDialog();
    // if(!result['status']){
      ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);

    // }
  }
  cancelTripRobot(BuildContext context ,RobotModel? robot) async {
    var result;
    if(robot==null)
      return;
    ConstantsWidgets.showLoading();
    result = await FirebaseFun.updateRobotReal(robot: robot);
    ConstantsWidgets.closeDialog();
    // if(!result['status']){
    ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);

    // }
  }


// solveProblem(BuildContext context ,ProblemModel problem) async {
  //   var result;
  //   // ConstantsWidgets.showLoading();
  //   problem.state=StateProblem.solved.name;
  //   result = await FirebaseFun.updateProblem(problem: problem);
  //   // ConstantsWidgets.closeDialog();
  //   ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);
  //
  // }


}
