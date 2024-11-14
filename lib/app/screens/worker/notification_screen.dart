import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/widgets/no_data_found_widget.dart';

import '../../../core/models/notification_model.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/widgets/constants_widgets.dart';
import '../../controllers/notifications_controller.dart';
import '/app/screens/worker/widgets/notification_listview_widget.dart';

import '../../../core/utils/const_value_manager.dart';
import '../../../core/utils/string_manager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsController controller;
  void initState() {
    controller = Get.put(NotificationsController());
    controller.onInit();
    super.initState();
  }
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
        body:
        StreamBuilder<QuerySnapshot>(
            stream: controller.getNotifications,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return    ConstantsWidgets.circularProgress();
              } else if (snapshot.connectionState ==
                  ConnectionState.active) {
                if (snapshot.hasError) {
                  return  Text('Error');
                } else if (snapshot.hasData) {
                  ConstantsWidgets.circularProgress();
                  controller.notifications.items.clear();
                  if (snapshot.data!.docs.length > 0) {

                    controller.notifications.items =
                        Notifications.fromJson(snapshot.data?.docs).items;
                  }
                  controller.filterNotification();
                  return
                    GetBuilder<NotificationsController>(
                        builder: (NotificationsController notificationsController)=>
                        (notificationsController.notifications.items.isEmpty ?? true)
                            ?
                        Center(child: NoDataFoundWidget(text: StringManager.noNotificationText,))
                            :

                        buildNotification(context, controller));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            })


      ),
    );


  }
  Widget buildNotification(BuildContext context,NotificationsController notificationsController){
    return
      TabBarView(
        children: [
          NotificationsListviewWidget(list: notificationsController.notifications.items,),
          NotificationsListviewWidget(list: notificationsController.seenNotifications.items,),
          NotificationsListviewWidget(list: notificationsController.unSeenNotifications.items,)
        ],
      );
  }

}
