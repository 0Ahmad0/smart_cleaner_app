import 'package:flutter/material.dart';
import 'package:smart_cleaner_app/app/screens/admin/widgets/activities_listview_widget.dart';
import 'package:smart_cleaner_app/core/utils/const_value_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstValueManager.activitiesTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.activitiesText.toUpperCase()),
          bottom: TabBar(
            tabs: [
              Tab(
                text: StringManager.allText,
              ),
              Tab(
                text: StringManager.seenText,
              ),
              Tab(
                text: StringManager.unSeenText,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActivitiesListviewWidget(list: [1,2,3,4,5],),
            ActivitiesListviewWidget(list: [1,5,4,6],),
            ActivitiesListviewWidget(list: [1],)
          ],
        ),
      ),
    );
  }
}
