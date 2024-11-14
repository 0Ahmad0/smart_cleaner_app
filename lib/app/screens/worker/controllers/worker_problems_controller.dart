
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/controllers/firebase/firebase_fun.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/problem_model.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/profile_controller.dart';

class WorkerProblemsController extends GetxController{

  final searchController = TextEditingController();
  Problems problems=Problems(items: []);
  Problems allProblems=Problems(items: []);
  Problems solvedProblems=Problems(items: []);
  Problems unSolvedProblems=Problems(items: []);
  String? uid;
  var getProblems;

  @override
  void onInit() {
   searchController.clear();
   ProfileController profileController=Get.put(ProfileController());
   uid= profileController.currentUser.value?.uid;
   getProblemsFun();
    super.onInit();
    }

  getProblemsFun() async {
    getProblems =_fetchProblemsStream();
    return getProblems;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  _fetchProblemsStream() {
    final result= FirebaseFirestore.instance
        .collection(FirebaseConstants.collectionProblem)
        .snapshots();
    return result;
  }
  filterProviders({required String term}) async {

    // providersWithFilter.items=[];
    // Problems.items.forEach((element) {
    //
    //   if((element.name?.toLowerCase().contains(term.toLowerCase())??false))
    //     providersWithFilter.items.add(element);
    // });
     update();
  }
  classification() async {
    allProblems.items.clear();
    solvedProblems.items.clear();
    unSolvedProblems.items.clear();
    problems.items.forEach((element) {

      switch(element.getState){
        case StateProblem.pending:
          allProblems.items.add(element);
          unSolvedProblems.items.add(element);
        case StateProblem.unSolved:
          allProblems.items.add(element);
          unSolvedProblems.items.add(element);
        case StateProblem.solved:
          allProblems.items.add(element);
          solvedProblems.items.add(element);
        // case StateProblem.unSolved:
        //   unSolvedProblems.items.add(element);
        default:
          allProblems.items.add(element);
      }
      });
    update();
  }

  solveProblem(BuildContext context ,ProblemModel problem) async {
    var result;
    // ConstantsWidgets.showLoading();
    problem.state=StateProblem.solved.name;
    result = await FirebaseFun.updateProblem(problem: problem);
    // ConstantsWidgets.closeDialog();
    ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);

  }


}