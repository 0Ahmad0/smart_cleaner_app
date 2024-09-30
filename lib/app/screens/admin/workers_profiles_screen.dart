import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/app/screens/admin/widgets/worker_profile_widget.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

class WorkerProfilesAdminScreen extends StatelessWidget {
  const WorkerProfilesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.workersProfilesText.toUpperCase()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPaddingWidget(
            horizontalPadding: 14.w,
            child: AppTextField(
              hintText: StringManager.searchText,
              iconData: Icons.search,
            ),
          ),
          verticalSpace(8.h),
          Expanded(child: ListView.separated(
              itemBuilder: (context,index)=>WorkerProfileWidget(),
              separatorBuilder: (_,__)=>Divider(
                height: 0,
                thickness: .5,
              ),
              itemCount: 20
          ))
        ],
      ),
    );
  }
}

