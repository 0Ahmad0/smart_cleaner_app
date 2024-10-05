import 'package:flutter/material.dart';
import '/app/screens/worker/widgets/notification_listview_widget.dart';

import '../../../core/utils/const_value_manager.dart';
import '../../../core/utils/string_manager.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstValueManager.activitiesTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.notificationText.toUpperCase()),
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
            NotificationsListviewWidget(list: [1,2,3,4,5],),
            NotificationsListviewWidget(list: [1,5,4,6],),
            NotificationsListviewWidget(list: [1],)
          ],
        ),
      ),
    );


  }
}
