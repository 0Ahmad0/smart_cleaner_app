import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/screens/admin/widgets/activities_listview_widget.dart';
import 'package:smart_cleaner_app/core/utils/const_value_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';

import '../../../core/models/activity_model.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import '../../controllers/worker_activities_controller.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late WorkerActivitiesController controller;
  void initState() {
    controller = Get.put(WorkerActivitiesController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstValueManager.activitiesTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.activitiesText.toUpperCase()),
          bottom: TabBar(
            tabs: [
              Tab(
                text: StringManager.allText,
              ),
              Tab(
                text: StringManager.seenText,
              ),
              Tab(
                text: StringManager.unSeenText,
              ),
            ],
          ),
        ),
        body:
        StreamBuilder<QuerySnapshot>(
            stream: controller.getActivities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return    ConstantsWidgets.circularProgress();
              } else if (snapshot.connectionState ==
                  ConnectionState.active) {
                if (snapshot.hasError) {
                  return  Text('Error');
                } else if (snapshot.hasData) {
                  ConstantsWidgets.circularProgress();
                  controller.activities.items.clear();
                  if (snapshot.data!.docs.length > 0) {

                    controller.activities.items =
                        Activities.fromJson(snapshot.data?.docs).items;
                  }
                  controller.filterActivities();
                  return
                    GetBuilder<WorkerActivitiesController>(
                        builder: (WorkerActivitiesController workerActivitiesController)=>
                        (workerActivitiesController.activities.items.isEmpty ?? true)
                            ?
                        Center(child: NoDataFoundWidget(text: StringManager.noActivitiesText,))
                            :

                        buildActivities(context, controller));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            })

      ),
    );
  }
  Widget buildActivities(BuildContext context,WorkerActivitiesController workerActivitiesController){
    return
      TabBarView(
        children: [
          ActivitiesListviewWidget(list: workerActivitiesController.activities.items,),
          ActivitiesListviewWidget(list: workerActivitiesController.seenActivities.items,),
          ActivitiesListviewWidget(list: workerActivitiesController.unSeenActivities.items,)
        ],
      );
  }

}
