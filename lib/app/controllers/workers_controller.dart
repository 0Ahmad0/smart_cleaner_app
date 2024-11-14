
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';
import 'package:smart_cleaner_app/app/controllers/profile_controller.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';
import 'package:smart_cleaner_app/core/models/user_model.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import 'firebase/firebase_constants.dart';

class WorkersController extends GetxController{

  final searchController = TextEditingController();
  Users workers=Users(users: []);
  Users workersWithFilter=Users(users: []);
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
    .snapshots()
    ;
    return result;
  }
  filterWorkers({required String term}) async {

    workersWithFilter.users=[];
    workers.users.forEach((element) {

      if(element.isWorker&&StateWorker.Rejected!=element.state)
      if(
      (element.name?.toLowerCase().contains(term.toLowerCase())??false)||
      (element.email?.toLowerCase().contains(term.toLowerCase())??false)||
      (element.uid?.toLowerCase().contains(term.toLowerCase())??false)
      )
        workersWithFilter.users.add(element);
    });
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
