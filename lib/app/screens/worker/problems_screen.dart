import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

import '../../../core/models/problem_model.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/const_value_manager.dart';
import '../../../core/utils/string_manager.dart';
import '../../../core/widgets/constants_widgets.dart';
import 'controllers/worker_problems_controller.dart';
import 'widgets/problems_listview_widget.dart';

class ProblemsScreen extends StatefulWidget {
  const ProblemsScreen({super.key});

  @override
  State<ProblemsScreen> createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> {
  late WorkerProblemsController controller;
  void initState() {
    controller = Get.put(WorkerProblemsController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstValueManager.activitiesTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.problemsText.toUpperCase(),

          ),
          actions: [
            IconButton(onPressed: (){
              context.pushNamed(Routes.problemsChartRoute);
            }, icon: Icon(Icons.bar_chart_outlined))
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: StringManager.allText,
              ),
              Tab(
                text: StringManager.solvedText,
              ),
              Tab(
                text: StringManager.unSolvedText,
              ),
            ],
          ),
        ),
        body:
        StreamBuilder<QuerySnapshot>(
            stream: controller.getProblems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return    ConstantsWidgets.circularProgress();
              } else if (snapshot.connectionState ==
                  ConnectionState.active) {
                if (snapshot.hasError) {
                  return  Text('Error');
                } else if (snapshot.hasData) {
                  ConstantsWidgets.circularProgress();
                  controller.problems.items.clear();
                  if (snapshot.data!.docs.length > 0) {

                    controller.problems.items =
                        Problems.fromJson(snapshot.data?.docs).items;
                  }
                  controller.classification();
                  return
                    GetBuilder<WorkerProblemsController>(
                        builder: (WorkerProblemsController workerProblemsController)=>

                            buildProblems(context, workerProblemsController));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            })
        // TabBarView(
        //   children: [
        //     ProblemsListviewWidget(list: [1,2,3,4,5],),
        //     ProblemsListviewWidget(list: [1,5,4,6],),
        //     ProblemsListviewWidget(list: [1],)
        //   ],
        // ),
      ),
    );

  }
  Widget buildProblems(BuildContext context,WorkerProblemsController workerProblemsController){
    return
      TabBarView(
        children: [
          ProblemsListviewWidget(items: workerProblemsController.allProblems.items,),
          ProblemsListviewWidget(items: workerProblemsController.solvedProblems.items,),
          ProblemsListviewWidget(items: workerProblemsController.unSolvedProblems.items,),
        ],
      );
  }

}
