import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';
import 'package:smart_cleaner_app/core/widgets/app_textfield.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/style_manager.dart';
import '../../../../core/widgets/constants_widgets.dart';
import '../../../../core/widgets/no_data_found_widget.dart';

class LiveFeedWidget extends StatefulWidget {
  const LiveFeedWidget({super.key});

  @override
  State<LiveFeedWidget> createState() => _LiveFeedWidgetState();
}

class _LiveFeedWidgetState extends State<LiveFeedWidget> {
 late  Future<ListResult> getFeeds;
 Map<String,dynamic> urlMap={};
 getUrl(Reference reference) async {
   if(urlMap.containsKey(reference.name))
     return;
   urlMap[reference.name]=await reference.getDownloadURL();
   setState(() {});

 }
  _fetchFeedsStream() {
    getFeeds = FirebaseStorage.instance.ref().child("live_feed").listAll();
    return getFeeds;
  }
  @override
  void initState() {
    _fetchFeedsStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Feeds".toUpperCase()),
      ),
      body: FutureBuilder<ListResult>(
          future: getFeeds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return    ConstantsWidgets.circularProgress();
            } else if (snapshot.connectionState ==
                ConnectionState.done) {
              if (snapshot.hasError) {
                return  Text('Error');
              } else if (snapshot.hasData) {
                ConstantsWidgets.circularProgress();
                return
                      snapshot.data?.items.isEmpty??true?
                      NoDataFoundWidget(text: "No Feeds Yet",)
                          :
                      buildProblems(context, snapshot.data?.items??[]);
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }
  Widget buildProblems(BuildContext context,List<Reference> items){

    return
      ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          getUrl(items[index]);
          return
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                  color: ColorManager.grayColor,
                  borderRadius: BorderRadius.circular(12.r)),
              child:
              Column(children: [
                urlMap.containsKey(items[index].name)?
                Image.network(
                  urlMap[items[index].name]??"",
                  // width: 80.w,
                  // height: 100.h,
                ):SizedBox(
                  width: 80.w,
                  height: 100.h,
                  child: ConstantsWidgets.circularProgress(),
                ),
                Text(items[index].name??'SSC 00${index + 1}')
              ],)
              //
              // ListTile(
              //
              //   // contentPadding: EdgeInsetsDirectional.only(start: 20.w),
              //   leading:
              //   urlMap.containsKey(items[index].name)?
              //   Image.network(
              //     urlMap[items[index].name]??"",
              //   width: 80.w,
              //   height: 100.h,
              //   ):SizedBox(
              //     width: 80.w,
              //     height: 100.h,
              //     child: ConstantsWidgets.circularProgress(),
              //   ),
              //   title: Text(items[index].name??'SSC 00${index + 1}'),
              //   subtitle:SizedBox.shrink(),
              // ),
            );
        },
      );
  }

}
