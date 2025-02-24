import 'dart:io';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_cleaner_app/core/models/activity_model.dart';
import 'package:smart_cleaner_app/core/models/problem_model.dart';
import '../../app/controllers/firebase/firebase_constants.dart';
import '../../app/controllers/firebase/firebase_fun.dart';

import '../enums/enums.dart';

import '../models/file_model.dart';

import '../models/location_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../utils/app_constant.dart';
import '../utils/string_manager.dart';


class Seeder{


  static Future<void> admin() async {

    try {
      // ConstantsWidgets.showLoading();
      for(UserModel userModel in adminsData){
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: userModel.email!, password: userModel.password!)
            .timeout(FirebaseFun.timeOut);
        if(userCredential.user!=null){
          userModel.uid=userCredential.user!.uid;

          await FirebaseFirestore.instance
              .collection(FirebaseConstants.collectionUser)
              .doc(userModel.uid)
              .set(userModel.toJson());
        }
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }
  static Future<void> worker() async {

    try {
      //ConstantsWidgets.showLoading();
      for(UserModel userModel in workersData){
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: userModel.email!, password: userModel.password!)
            .timeout(FirebaseFun.timeOut);
        if(userCredential.user!=null){
          userModel.uid=userCredential.user!.uid;

          await FirebaseFirestore.instance
              .collection(FirebaseConstants.collectionUser)
              .doc(userModel.uid)
              .set(userModel.toJson());
        }
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }

  static Future<void> user() async {

    try {
      //ConstantsWidgets.showLoading();
      for(UserModel userModel in usersData){
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: userModel.email!, password: userModel.password!)
            .timeout(FirebaseFun.timeOut);
        if(userCredential.user!=null){
          userModel.uid=userCredential.user!.uid;

          await FirebaseFirestore.instance
              .collection(FirebaseConstants.collectionUser)
              .doc(userModel.uid)
              .set(userModel.toJson());
        }
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }
  static Future<void> problem() async {
    final random = Random();

    problems= List.generate(25, (index) {
      UserModel user = index%3==0?usersData.first:usersData[random.nextInt(usersData.length)];

      DateTime now = DateTime.now();
      DateTime sendingTime = now.add(Duration(days: random.nextInt(60) - 30));
      List<FileModel> files=[fileData,imageData,fileData,imageData,fileData,fileData,imageData];

      return ProblemModel(
        id: 'problem_$index',
        idUser: user.uid,

        description:
        index%2==0?
        problemNames[random.nextInt(problemNames.length)]
            :
        'This is a description of Problem ${index + 1}.',
        state: StateProblem.values[random.nextInt(StateProblem.values.length)].name,
       sendingTime: sendingTime,
        locations: [LocationModel(
          latitude: 25.0 + random.nextDouble() * 10,
          longitude: 55.0 + random.nextDouble() * 10,
        )],
        files: [...List.generate(random.nextInt(5)+1, (_) => files[random.nextInt(files.length)])],
      );
    });
    try {
      //ConstantsWidgets.showLoading();
      for(ProblemModel item in problems){
        await FirebaseFun.addProblem(problem:item);
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }
  static Future<void> activity() async {
    final random = Random();

    activities= List.generate(25, (index) {
      UserModel user = index%3==0?usersData.first:usersData[random.nextInt(usersData.length)];
      ProblemModel problem = problems[random.nextInt(problems.length)];
      DateTime now = DateTime.now();
      DateTime sendingTime = now.add(Duration(days: random.nextInt(60) - 30));
      List<FileModel> files=[fileData,imageData,fileData,imageData,fileData,fileData,imageData];

      final textActivities=[
        {"title":StringManager.activityTitleProblemSolved,"subTitle":StringManager.activitySubTitleProblemSolved+' '+(user.name??'')},
        {"title":StringManager.activityTitleTripCanceled,"subTitle":StringManager.activitySubTitleTripCanceled},
        {"title":StringManager.activityTitleRobotPathSet,"subTitle":StringManager.activitySubTitleRobotPathSet},
      ];
      final textActivity= textActivities[random.nextInt(textActivities.length)];

      return
        ActivityModel(
          idUser: user.uid
          ,nameUser: user?.name,
          checkRec: [true,false,false][random.nextInt(3)],
          checkSend:[true,false,false][random.nextInt(3)] ,
          subtitle: textActivity['subTitle'],
          dateTime: sendingTime,
          title: textActivity['title']??'',);


    });
    try {
      //ConstantsWidgets.showLoading();
      for(ActivityModel item in activities){
        await FirebaseFun.addActivity(activity:item);
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }
  static  Future<void> notification() async {

    final UserModel? worker=workersData.firstOrNull;
    final UserModel?  user=usersData.firstOrNull;
    final UserModel? admin=adminsData.firstOrNull;

    List<NotificationModel> notificationsData = [
      NotificationModel(typeUser: AppConstants.collectionWorker,idUser:user?.uid, subtitle: StringManager.notificationSubTitleProblemSolved, dateTime: DateTime.now(), title: StringManager.notificationTitleNewProblem, message: ''),
      NotificationModel(typeUser: AppConstants.collectionWorker,idUser:user?.uid, subtitle: StringManager.notificationSubTitleProblemSolved, dateTime: DateTime.now(), title: StringManager.notificationTitleNewProblem, message: ''),
      NotificationModel(typeUser: AppConstants.collectionWorker,idUser:workersData.lastOrNull?.uid, subtitle: StringManager.notificationSubTitleRejectRequestWorker, dateTime: DateTime.now(), title: StringManager.notificationTitleRejectRequestWorker, message: ''),
     NotificationModel(typeUser: AppConstants.collectionWorker,idUser:worker?.uid, subtitle: StringManager.notificationSubTitleAcceptRequestWorker, dateTime: DateTime.now(), title: StringManager.notificationTitleAcceptRequestWorker, message: '')

     ,
      NotificationModel(typeUser: AppConstants.collectionAdmin,idUser:worker?.uid, subtitle: StringManager.notificationSubTitleProblemSolved+' '+(_getRandomItem(workersData)?.name??''), dateTime: DateTime.now(), title: StringManager.notificationTitleProblemSolved, message: ''),
      NotificationModel(typeUser: AppConstants.collectionAdmin,idUser:worker?.uid, subtitle: StringManager.notificationSubTitleTripCanceled+' '+(_getRandomItem(workersData)?.name??''), dateTime: DateTime.now(), title: StringManager.notificationTitleTripCanceled, message: ''),
      NotificationModel(typeUser: AppConstants.collectionAdmin,idUser:worker?.uid, subtitle: StringManager.notificationTitleRobotPathSet+' '+(_getRandomItem(workersData)?.name??''), dateTime: DateTime.now(), title: StringManager.notificationTitleRobotPathSet, message: ''),


    ];
    try {
      //ConstantsWidgets.showLoading();
      for(NotificationModel item in notificationsData){
        await FirebaseFun.addNotification(notification: item);
      }
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }



  static  Future<void> file() async {

    try {
      // ConstantsWidgets.showLoading();

      fileData=FileModel(
          name: _xFile.name,
          localUrl:_xFile.path,
          size: 13260,
          type: TypeFile.file.name,
          subType: _xFile.mimeType,
          url:"https://firebasestorage.googleapis.com/v0/b/smart-cleaner-app-cb462.appspot.com/o/1000006647.jpg?alt=media&token=7412951b-326a-4891-b8af-dd1a7a801061"
      );
      imageData=FileModel(
          name: _xImage.name,
          localUrl:_xImage.path,
          size: 13096,
          type: TypeFile.image.name,
          subType: _xImage.mimeType,
          url: "https://firebasestorage.googleapis.com/v0/b/smart-cleaner-app-cb462.appspot.com/o/dummy.pdf?alt=media&token=a9caff90-0287-44a6-9271-f08df5461606"
      );
      // fileData=FileModel(
      //   name: _xFile.name,
      //   localUrl:_xFile.path,
      //   size: await _xFile.length(),
      //   type: TypeFile.file.name,
      //   subType: _xFile.mimeType,
      // );
      // imageData=FileModel(
      //   name: _xImage.name,
      //   localUrl:_xImage.path,
      //   size: await _xImage.length(),
      //   type: TypeFile.file.name,
      //   subType: _xImage.mimeType,
      // );
      //

      // fileData.url=await FirebaseFun.uploadImage(image:_xFile,folder:'');
      // imageData.url=await FirebaseFun.uploadImage(image:_xImage,folder:'');
      // ConstantsWidgets.closeDialog();
    } on FirebaseException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // ConstantsWidgets.closeDialog();
      // ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      throw Exception(errorMessage);
    }on Exception catch (e) {
      throw Exception();
    }
  }

  static FileModel fileData=FileModel();
  static FileModel imageData=FileModel();
  static XFile _xFile = XFile("assets/dummy.pdf");
  static XFile _xImage = XFile("assets/images/logo.png");
  static List<UserModel> adminsData=[
    // UserModel(email: 'admin@gmail.com', name: 'Admin Acc', password: '1234sS@4321', typeUser: AppConstants.collectionAdmin),
    UserModel(email: 'admin@gmail.com', name: 'Admin Acc', password: '12345678', typeUser: AppConstants.collectionAdmin),

  ];
  static List<UserModel> workersData=[
    UserModel(email: 'worker@gmail.com', name: 'Worker Acc', password: '12345678', typeUser: AppConstants.collectionWorker,state: StateWorker.Accepted.name),
    UserModel(email: 'worker1@gmail.com', name: 'Worker2 Acc', password: '12345678', typeUser: AppConstants.collectionWorker),
    UserModel(email: 'worker2@gmail.com', name: 'Worker3 Acc', password: '12345678', typeUser: AppConstants.collectionWorker,state:StateWorker.Rejected.name ),

  ];
  static List<UserModel> usersData=[
    UserModel(email: 'user@gmail.com', name: 'User Acc', password: '12345678', typeUser: AppConstants.collectionUser),
    UserModel(email: 'guest@gmail.com', name: 'Guest Acc', password: '12345678', typeUser: AppConstants.collectionUser),

    // UserModel(email: 'user@gmail.com', name: 'User T', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user2@gmail.com', name: 'Ahmad T1', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user3@gmail.com', name: 'Ahmad T2', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user4@gmail.com', name: 'Ahmad T3', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user5@gmail.com', name: 'Ahmad T4', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user6@gmail.com', name: 'Ahmad T5', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user7@gmail.com', name: 'Ahmad T6', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user8@gmail.com', name: 'Ahmad T7', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user9@gmail.com', name: 'Ahmad T8', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),
    // UserModel(email: 'user10@gmail.com', name: 'Ahmad T9', password: '12345678',phoneNumber: "0599555440", typeUser: AppConstants.collectionUser),

  ];
  static List<String> problemNames = [

  "Soil collapse under the building",
  "Pothole in the road",
  "Cracked asphalt on the main road",
  "Traffic signal failure",
  "Tree falls on the sidewalk",

  ];
  static List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/Americas.png?alt=media&token=e044fcd7-0f89-4a13-8b7f-239d91fdb268",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/aaa.jpg?alt=media&token=11dda076-2185-485d-a48b-7cbaa8244661",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/d.jpg?alt=media&token=b90fd08b-35b1-4339-bfde-9042e9455d76",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/earth-5660940_960_720.png?alt=media&token=eb5e4f74-179b-4932-93c9-c7da1181744c",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/globe-1348777_1280.webp?alt=media&token=cfff61f7-6aaf-4ce1-b7e3-8aaa35be264d",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/qq.jpg?alt=media&token=db68f16d-4011-43b6-91ff-3f34d41593a0",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/qqq.jpg?alt=media&token=d5a20b83-2a53-4f3d-b639-2f904f2f8cfc",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/ss.jpg?alt=media&token=c6be1bd0-8008-4a58-aecb-74a42ab9d363",
    "https://firebasestorage.googleapis.com/v0/b/enjaz-app-9d39e.firebasestorage.app/o/%D8%B5%D9%88%D8%B1%D8%A9%20%D8%AA%D8%AF%D9%84%20%D8%B9%D9%84%D9%89%20%D8%A7%D9%86%D9%87%20%D9%84%D8%A7%20%D9%8A%D9%88%D8%AC%D8%AF%20%D8%A8%D9%8A%D8%A7%D9%86%D8%A7%D8%AA%20%D9%88%D8%AA%D9%83%D9%88%D9%86%20%D8%A7%D9%84%D8%B5%D9%88%D8%B1%D8%A9%20%D8%B9%D8%B5%D8%B1%D8%A8%D8%A9.png?alt=media&token=924e3c79-df11-4ed2-801b-9cdc8dbdea1f",
  ];
  static List<ProblemModel> problems = [];
  static List<ActivityModel> activities = [];


  static _generateUid(String name){
    // return "$name${Timestamp.now().millisecondsSinceEpoch}";
    return '${name}00000'.substring(0,5)+'${Timestamp.now().microsecondsSinceEpoch}';
  }
  static _getRandomItem(List items){

    return items[Random().nextInt(items.length)];
  }


}