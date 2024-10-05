import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

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
                      context.pop();
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
                      await file.pickFiles();
                    },
                    color: ColorManager.purpleColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.camera_alt_outlined,
                    label: StringManager.cameraText,
                    onPressed: () async {
                      context.pop();
                      final image = ImagePicker();
                      await image.pickImage(source: ImageSource.camera);
                    },
                    color: ColorManager.pinkColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.photo,
                    label: StringManager.galleryText,
                    onPressed: () async {
                      context.pop();
                      final image = ImagePicker();
                      await image.pickImage(source: ImageSource.gallery);
                    },
                    color: ColorManager.deepBlueColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.audiotrack_outlined,
                    label: StringManager.audioText,
                    onPressed: () async {
                      context.pop();
                      final file = FilePicker.platform;
                      await file.pickFiles(type: FileType.audio);
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
