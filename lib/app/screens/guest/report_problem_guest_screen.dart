import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import 'widgets/describe_problem_widget.dart';

class ReportProblemGuestScreen extends StatefulWidget {
  const ReportProblemGuestScreen({super.key});

  @override
  State<ReportProblemGuestScreen> createState() =>
      _ReportProblemGuestScreenState();
}

class _ReportProblemGuestScreenState extends State<ReportProblemGuestScreen> {
  final reportProblemController = TextEditingController();

  @override
  void initState() {
    reportProblemController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    reportProblemController.dispose();
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
          Visibility(
            visible: reportProblemController.text.isEmpty,
            child: DescribeProblemWidget(),
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
                    controller: reportProblemController,
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
                Visibility(
                  visible: reportProblemController.text.isNotEmpty,
                  child: ZoomIn(
                    child: IconButton(
                      onPressed: () {
                        reportProblemController.clear();
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    onPressed: () {},
                    color: ColorManager.successColor,
                  ),
                  BottomSheetReportProblemIconWidget(
                    icon: Icons.file_open_outlined,
                    label: StringManager.documentText,
                    onPressed: () async {
                      context.pop();
                      final file = FilePicker.platform;
                      await file.pickFiles(
                          type: FileType.media
                      );
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
                      await file.pickFiles(
                        type: FileType.audio
                      );
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

class BottomSheetReportProblemIconWidget extends StatelessWidget {
  const BottomSheetReportProblemIconWidget({
    super.key,
    required this.icon,
    this.label = '',
    this.onPressed,
    this.color = ColorManager.primaryColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.sp,
          backgroundColor: color,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 30.sp,
              color: ColorManager.whiteColor,
            ),
          ),
        ),
        verticalSpace(6.h),
        Text(
          label,
          style: StyleManager.font12Regular(),
        ),
        verticalSpace(20.h)
      ],
    );
  }
}
