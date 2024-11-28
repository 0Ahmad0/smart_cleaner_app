import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/models/notification_model.dart';
import 'package:smart_cleaner_app/core/utils/assets_manager.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';

import '../../../controllers/notifications_controller.dart';

class NotificationsListviewWidget extends StatelessWidget {
  const NotificationsListviewWidget({super.key, required this.list});

  final List<NotificationModel> list;

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(
        height: 0,
        thickness: .5,
      ),
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if(!list[index].checkRec){
            list[index].checkRec = true;
            Get.put(NotificationsController())
                .updateNotification(context, notification: list[index]);
          }
        },
        contentPadding: EdgeInsets.only(right: 0, left: 20.w),
        leading: SvgPicture.asset(
          AssetsManager.robotIcon,
          width: 40.w,
          height: 40.h,
        ),
        title: Text(list[index].title??'SSC 00${index + 1}'),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            list[index].subtitle??
            'The Robot is facing a garbage accumulation in this location',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StyleManager.font12Regular(
                color: ColorManager.blackColor.withOpacity(.5)),
          ),
        ),
        trailing:

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox.shrink(),
            Visibility(
              visible: list[index].checkRec,
              // visible: list.length.isEven,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: ColorManager.tealColor,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(100.r))),
                child: Text(
                  'Seen',
                  style: StyleManager.font12Medium(color: ColorManager.whiteColor),
                ),
              ),
            ),
            Text(
              "${DateFormat("MMM d,").add_jm().format(list[index].dateTime??DateTime.now())}"+' ',
              overflow: TextOverflow.ellipsis,
              style: StyleManager.font12Regular(
                  color: ColorManager.blackColor.withOpacity(.5)),
            )
          ],
        ),
      ),
    );
  }
}
