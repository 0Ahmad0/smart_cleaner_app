import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cleaner_app/app/screens/guest/controllers/guest_problem_controller.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/string_manager.dart';
import '../../../../core/widgets/app_padding.dart';
import 'bottom_sheet_report_problem_icon_widget.dart';

class ReportProblemBottomSheetWidget extends StatelessWidget {
  const ReportProblemBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppPaddingWidget(
          child: ZoomIn(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                  color: ColorManager.grayColor,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 40.w,
                children: [
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.location_on_rounded,
                    label: StringManager.locationText,
                    onPressed: () {
                      // context.pop();
                      context.pushNamed(Routes.pickLocationGuestRoute);
                    },
                    color: ColorManager.successColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.file_open_outlined,
                    label: StringManager.documentText,
                    onPressed: () async {
                      context.pop();
                      final file = FilePicker.platform;
                      FilePickerResult? filePickerResult= await file.pickFiles();
                        for(PlatformFile platformFile in filePickerResult?.files??[])
                        {
                        Get.put(GuestProblemController()).addFile(platformFile.xFile,platformFile: platformFile,type: TypeFile.file.name);
                      }
                    },
                    color: ColorManager.purpleColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.camera_alt_outlined,
                    label: StringManager.cameraText,
                    onPressed: () async {
                      context.pop();
                      final image = ImagePicker();
                      XFile? xFile = await image.pickImage(source: ImageSource.camera);

                     if(xFile!=null)
                      {
                        Get.put(GuestProblemController()).addFile(xFile,type: TypeFile.image.name);
                      }
                    },
                    color: ColorManager.pinkColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.photo,
                    label: StringManager.galleryText,
                    onPressed: () async {
                      context.pop();
                      final image = ImagePicker();
                      XFile? xFile =await image.pickImage(source: ImageSource.gallery);
                      if(xFile!=null)
                      {
                        Get.put(GuestProblemController()).addFile(xFile,type: TypeFile.image.name);
                      }
                    },
                    color: ColorManager.deepBlueColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.audiotrack_outlined,
                    label: StringManager.audioText,
                    onPressed: () async {
                      context.pop();
                      final file = FilePicker.platform;
                      FilePickerResult? filePickerResult= await file.pickFiles(type: FileType.audio);
                      for(PlatformFile platformFile in filePickerResult?.files??[])
                      {
                        Get.put(GuestProblemController()).addFile(platformFile.xFile,platformFile: platformFile,type: TypeFile.audio.name);
                      }
                    },
                    color: ColorManager.orangeColor,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
