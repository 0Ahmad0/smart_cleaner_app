import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/app/screens/admin/widgets/worker_profile_widget.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../../core/models/user_model.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../../core/widgets/no_data_found_widget.dart';
import '../../controllers/workers_controller.dart';

class WorkerProfilesAdminScreen extends StatefulWidget {
  const WorkerProfilesAdminScreen({super.key});

  @override
  State<WorkerProfilesAdminScreen> createState() => _WorkerProfilesAdminScreenState();
}

class _WorkerProfilesAdminScreenState extends State<WorkerProfilesAdminScreen> {
  late WorkersController controller;
  void initState() {
    controller = Get.put(WorkersController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.workersProfilesText.toUpperCase()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPaddingWidget(
            horizontalPadding: 14.w,
            child: AppTextField(
              hintText: StringManager.searchText,
              iconData: Icons.search,
              onChanged: (value)=>    controller.filterWorkers(term: value),
            ),
          ),
          verticalSpace(8.h),
          Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: controller.getWorkers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return    ConstantsWidgets.circularProgress();
                } else if (snapshot.connectionState ==
                    ConnectionState.active) {
                  if (snapshot.hasError) {
                    return  Text('Error');
                  } else if (snapshot.hasData) {
                    ConstantsWidgets.circularProgress();
                    controller.workers.users.clear();
                    if ((snapshot.data?.docs.length ?? 0) > 0) {
                      controller.workers.users = Users.fromJson(
                          snapshot.data!.docs).users;

                    }
                    controller.filterWorkers(term: controller.searchController.value.text);
                    return
                      GetBuilder<WorkersController>(
                          builder: (WorkersController workersController)=>
                          workersController.workersWithFilter.users.isEmpty?
                          NoDataFoundWidget(text: "No Worker Yet",)
                              :
                          buildProblems(context, workersController.workersWithFilter.users));
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              }))
        ],
      ),
    );
  }
  Widget buildProblems(BuildContext context,List<UserModel> workers){
    return
      ListView.separated(
          itemBuilder: (context,index)=>WorkerProfileWidget(index: index+1,user: workers[index],),
          separatorBuilder: (_,__)=>Divider(
            height: 0,
            thickness: .5,
          ),
          itemCount: workers.length
      );
  }

}

