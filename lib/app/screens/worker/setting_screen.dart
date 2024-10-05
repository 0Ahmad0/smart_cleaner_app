import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../../core/utils/assets_manager.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/style_manager.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.settingText.toUpperCase()),
      ),
      body: Column(
        children: [
          AppPaddingWidget(
            child: AppTextField(
              hintText: StringManager.searchText,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                    color: ColorManager.grayColor,
                    borderRadius: BorderRadius.circular(12.r)),
                child: ListTile(
                  isThreeLine: true,
                  onTap: () {
                    context.pushNamed(Routes.profileRobotWorkerRoute,
                        arguments: {'index': index + 1});
                  },
                  contentPadding: EdgeInsetsDirectional.only(start: 20.w),
                  leading: SvgPicture.asset(
                    AssetsManager.robotIcon,
                    width: 40.w,
                    height: 40.h,
                  ),
                  title: Text('SSC 00${index + 1}'),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Robot is facing a garbage',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: StyleManager.font12Regular(
                              color: ColorManager.blackColor.withOpacity(.5)),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton.icon(
                              onPressed: () {
                                context.pushNamed(
                                    Routes.profileRobotWorkerRoute,
                                    arguments: {'index': index + 1});
                              },
                              icon: Icon(Icons.change_circle_outlined),
                              label: Text(
                                StringManager.changeSettingText,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
