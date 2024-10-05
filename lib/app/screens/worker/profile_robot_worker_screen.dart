import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

class ProfileRobotWorkerScreen extends StatefulWidget {
  const ProfileRobotWorkerScreen({super.key});

  @override
  State<ProfileRobotWorkerScreen> createState() =>
      _ProfileRobotWorkerScreenState();
}

class _ProfileRobotWorkerScreenState extends State<ProfileRobotWorkerScreen> {
  bool mode = false;

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.profileText.toUpperCase()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20.h),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 50.sp,
                child: SvgPicture.asset(
                  AssetsManager.robotIcon,
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
              PositionedDirectional(
                bottom: -10.h,
                end: -10.w,
                child: IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    backgroundColor: ColorManager.primaryColor,
                    radius: 18.sp,
                    child: Icon(
                      Icons.edit,
                      size: 20.sp,
                      color: ColorManager.whiteColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          verticalSpace(10.h),
          Text(
            'SCC 00${args['index']}',
            style: StyleManager.font12SemiBold(),
          ),
          verticalSpace(100.h),
          Container(
            decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(.25)),
            child: ListTile(
              title: Text(
                StringManager.generalSettingText,
                style: StyleManager.font16SemiBold(),
              ),
            ),
          ),
          verticalSpace(20.h),
          StatefulBuilder(builder: (context, modeSetState) {
            return SwitchListTile(
              title: Text(StringManager.robotModeText),
              secondary: SvgPicture.asset(
                AssetsManager.robotIcon,
                width: 28.w,
                height: 28.h,
              ),
              subtitle: Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: StringManager.inDoorText,
                    style: StyleManager.font12Regular(
                      color: !mode
                          ? ColorManager.tealColor
                          : ColorManager.blackColor.withOpacity(.5),
                    ),
                  ),
                  TextSpan(
                    text: '/',
                    style: StyleManager.font18Medium(
                        color: ColorManager.blackColor.withOpacity(.5)),
                  ),
                  TextSpan(
                    text: StringManager.outDoorText,
                    style: StyleManager.font12Regular(
                      color: mode
                          ? ColorManager.tealColor
                          : ColorManager.blackColor.withOpacity(.5),
                    ),
                  ),
                ],
              )),
              // subtitle: Text(
              // StringManager.inDoorText + '/' + StringManager.outDoorText,
              // ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              value: mode,
              onChanged: (value) {
                modeSetState(() => mode = value);
              },
            );
          })
        ],
      ),
    );
  }
}
