import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import 'widgets/activities_worker_widget.dart';

class ShowActivitiesWorkerScreen extends StatelessWidget {
  const ShowActivitiesWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker 00${args['index']}'.toUpperCase()),
      ),
      body: Column(
        children: [
          AppPaddingWidget(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 100.sp,
                  color: ColorManager.tealColor,
                ),
                Flexible(
                  child: Text(
                    'Worker 00${args['index']}',
                    style: StyleManager.font30SemiBold(),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(20.h),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ActivitiesWorkerWidget(),
            ),
          )
        ],
      ),
    );
  }
}

