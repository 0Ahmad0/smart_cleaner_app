import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/models/user_model.dart';
import '../../../controllers/workers_controller.dart';

class WorkerProfileWidget extends StatelessWidget {
  const WorkerProfileWidget({
    super.key, required this.index, this.user,
  });
  final int index;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            onTap: (){

              context.pushNamed(Routes.showActivitiesWorkerAdminRoute,arguments: {
                'index':index,
                "user":user
              });
            },
            dense: true,
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: ColorManager.primaryColor,
              child: Icon(Icons.person,color: ColorManager.whiteColor,),
            ),
            title: Text(user?.name??'Title'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('email: ${user?.email}'),
                  // Text('subTitle2'),
                  // Text('subTitle3'),
                ],
              ),
            ),
          ),
        ),
        if(null==user?.state)...[
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              Get.put(WorkersController()).acceptOrRejectedRequest(context,StateWorker.Accepted,user);
            },
            icon: Icon(Icons.check_circle_outline,color: ColorManager.successColor,),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              Get.put(WorkersController()).acceptOrRejectedRequest(context,StateWorker.Rejected,user);
            },
            icon: Icon(Icons.cancel_outlined,color: ColorManager.errorColor,),
          )
    ]

      ],
    );
  }
}
