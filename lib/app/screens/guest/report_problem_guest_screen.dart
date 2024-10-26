import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/app/screens/guest/widgets/file_list_widget.dart';
import 'package:smart_cleaner_app/app/screens/guest/widgets/location_list_widget.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import 'controllers/guest_problem_controller.dart';
import 'widgets/describe_problem_widget.dart';
import 'widgets/report_problem_bottom_sheet_widget.dart';

class ReportProblemGuestScreen extends StatefulWidget {
  const ReportProblemGuestScreen({super.key});

  @override
  State<ReportProblemGuestScreen> createState() =>
      _ReportProblemGuestScreenState();
}

class _ReportProblemGuestScreenState extends State<ReportProblemGuestScreen> {
  final reportProblemController = TextEditingController();
  late GuestProblemController controller;
  @override
  void initState() {
    controller = Get.put(GuestProblemController());
    controller.onInit();
    controller.descriptionController.addListener(() {
     controller.update();
    });
    reportProblemController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    reportProblemController.dispose();
    controller.descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SvgPicture.asset(
            AssetsManager.robotIcon,
            width: 40.w,
            height: 40.h,
          ),
          horizontalSpace(10.w),
        ],
        title: Text(
          StringManager.reportProblemText.toUpperCase(),
        ),
      ),
      body: Column(
        children: [
          AppPaddingWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  AssetsManager.robotIcon,
                  width: 100.w,
                  height: 100.h,
                ),
                Flexible(
                  child: Text(
                    StringManager.reportingProblemsText,
                    textAlign: TextAlign.center,
                    style: StyleManager.font30SemiBold(),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),

          GetBuilder<GuestProblemController>(
            init: controller,
            builder: (GuestProblemController problemController) {
              return
                ( (controller.problem?.files?.isEmpty??true)
                &&  (controller.problem?.locations?.isEmpty??true)
                &&  (controller.descriptionController.text.isEmpty))?


                Visibility(
                visible: controller.descriptionController.text.isEmpty,
                // visible: reportProblemController.text.isEmpty,
                child: DescribeProblemWidget(),
              ):
                Column(
                  children: [
                    FileListWidget(files:controller.problem?.files,
                    onDelete: (file)=>controller.removeFile(file),
                    ),
                    SizedBox(height: 10.h,),
                    LocationListWidget(locations:controller.problem?.locations,
                      onDelete: (location)=>controller.removeLocation(location),
                    ),
                  ],
                )
                // FileListWidget(files:controller.problem?.files,)
              ;
            }
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(.5),
            ),
            child: Row(
              children: [
                horizontalSpace(12.w),
                Flexible(
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.descriptionController,
                    // controller: reportProblemController,
                    decoration: InputDecoration(
                      fillColor: ColorManager.grayColor,
                      filled: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) =>
                                      ReportProblemBottomSheetWidget());
                            },
                            icon: Icon(Icons.attach_file),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.camera_alt_outlined),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                horizontalSpace(12.w),
                GetBuilder<GuestProblemController>(
                  init: controller,
                  builder: ( problemController)=>
                Visibility(
                  visible: controller.descriptionController.text.isNotEmpty,
                  // visible: reportProblemController.text.isNotEmpty,
                  child: ZoomIn(
                    child: IconButton(
                      onPressed: () {
                       controller.addProblem(context);
                        // reportProblemController.clear();
                      },
                      icon: CircleAvatar(
                        backgroundColor: ColorManager.primaryColor,
                        child: Transform.rotate(
                          angle: -.4,
                          child: Icon(
                            Icons.send,
                            size: 20.sp,
                            color: ColorManager.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}


