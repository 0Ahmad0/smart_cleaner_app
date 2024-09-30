import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';

class WorkerProfileWidget extends StatelessWidget {
  const WorkerProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      dense: true,
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundColor: ColorManager.primaryColor,
        child: Icon(Icons.person,color: ColorManager.whiteColor,),
      ),
      trailing: IconButton(
        onPressed: (){},
        icon: Icon(Icons.more_horiz),
      ),
      title: Text('Title'),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('subTitle1'),
            Text('subTitle2'),
            Text('subTitle3'),
          ],
        ),
      ),
    );
  }
}
