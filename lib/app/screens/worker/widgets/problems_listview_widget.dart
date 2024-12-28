import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/problem_model.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_button.dart';

import '../../../../core/enums/enums.dart';
import '../../guest/widgets/file_list_widget.dart';
import '../../guest/widgets/location_list_widget.dart';
import '../controllers/worker_problems_controller.dart';

class ProblemsListviewWidget extends StatelessWidget {
  const ProblemsListviewWidget({super.key, required this.items});

  final List<ProblemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: 0,
        thickness: .5,
      ),
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          await Get.dialog(
              AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // FileListWidget(files:items[index].files,
                      //   // onDelete: (file)=>controller.removeFile(file),
                      // ),
                      // SizedBox(height: 10.h,),
                      LocationListWidget(locations:items[index].locations,
                        // onDelete: (location)=>controller.removeLocation(location),
                      ),
                    ],
                  ),
                ),
              )

          );
        },
        contentPadding: EdgeInsets.only(right: 0, left: 20.w),
        leading: CircleAvatar(
          backgroundColor: ColorManager.primaryColor,
          child: Icon(
            Icons.details,
            color: ColorManager.whiteColor,
          ),
        ),
        title: Text('report 00${index + 1}'),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            items[index].description??
            'There is a crashed robot in this location',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StyleManager.font12Regular(
                color: ColorManager.blackColor.withOpacity(.5)),
          ),
        ),
        trailing:
        StateProblem.pending==items[index].getState?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Get.put(WorkerProblemsController()).solveProblem(context,items[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                  color: ColorManager.enterButtonColor,
                  borderRadius:
                  BorderRadius.all( Radius.circular(100.r))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,size: 18.w,color: ColorManager.whiteColor,),
                  SizedBox(width: 8.w,),
                  Text(
                    StringManager.solveText,
                    style: StyleManager.font12Medium(color: ColorManager.whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ):
        Visibility(
          visible:[StateProblem.solved,StateProblem.unSolved].contains(items[index].getState) ,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: ColorManager.tealColor,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(100.r))),
            child: Text(
              StateProblem.solved==items[index].getState?
              StringManager.solvedText:
              StringManager.unSolvedText,
              style: StyleManager.font12Medium(color: ColorManager.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
