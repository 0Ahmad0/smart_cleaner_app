import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

class ActivitiesListviewWidget extends StatelessWidget {
  const ActivitiesListviewWidget({super.key, required this.list});

  final List list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(
        height: 0,
        thickness: .5,
      ),
      itemBuilder: (context, index) => ListTile(
        onTap: (){},
        contentPadding: EdgeInsets.only(
          right: 0,
          left: 20.w
        ),
        leading: CircleAvatar(
          backgroundColor: ColorManager.primaryColor,
          child: Icon(
            Icons.notifications,
            color: ColorManager.whiteColor,
          ),
        ),
        title: Text('Lable'),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            'subTitle',
            style: StyleManager.font12Regular(
                color: ColorManager.blackColor.withOpacity(.75)),
          ),
        ),
        trailing: Visibility(
          visible: list.length.isEven,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h
            ),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(100.r)
              )
            ),
            child: Text(
              'Seen',
              style: StyleManager.font12Medium(color: ColorManager.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
