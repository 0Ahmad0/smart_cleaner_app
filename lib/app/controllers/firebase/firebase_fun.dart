import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cleaner_app/core/models/activity_model.dart';
import 'package:smart_cleaner_app/core/models/problem_model.dart';
import 'package:smart_cleaner_app/core/models/robot_model.dart';

import '../../../core/models/notification_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/color_manager.dart';
import 'firebase_constants.dart';

class FirebaseFun {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static final database= FirebaseDatabase.instance.ref();

  // time for waiting request to done or show error message
  static Duration timeOut = Duration(seconds: 50);

  ///--Signup
  static Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) {
    final result = auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(FirebaseHelperFun.onValueSignup)
        .catchError(FirebaseHelperFun.onError)
        .timeout(timeOut, onTimeout: FirebaseHelperFun.onTimeOut);
    return result;
  }



  static fetchUser( {required String uid,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('uid',isEqualTo: uid)
        .get()
        .then((onValueFetchUser))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static fetchUserByUserName( {required String userName})  async {
    final result=await FirebaseFirestore.instance.collection(FirebaseConstants.collectionUser)
        .where('userName',isEqualTo: userName)
        .get()
        .then((onValueFetchUserByUserName))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUserId( {required String id,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('id',isEqualTo: id)
        .get()
        .then((onValueFetchUserId))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    //  print("${id} ${result}");
    return result;
  }
  static fetchUserUid( {required String uid,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('uid',isEqualTo: uid)
        .get()
        .then((onValueFetchUserId))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static fetchUsers()  async {
    final result=await FirebaseFirestore.instance.collection(FirebaseConstants.collectionUser)
        .get()
        .then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }


  //Problem
  static addProblem( {required ProblemModel problem}) async {
    final result= await FirebaseFirestore.instance.collection(FirebaseConstants.collectionProblem)
        .doc(problem.id)
        .set(problem.toJson()).then(onValueAddProblem).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteProblem( {required String idProblem}) async {
    final result =await FirebaseFirestore.instance
        .collection(FirebaseConstants.collectionProblem)
        .doc(idProblem)
        .delete().then(onValueDeleteProblem)
        .catchError(onError);
    return result;
  }
  static updateProblem( {required ProblemModel problem}) async {
    final result= await FirebaseFirestore.instance.collection(FirebaseConstants.collectionProblem).doc(
        problem.id
    ).update(problem.toJson()).then(onValueUpdateProblem).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchProblemsByIdUser({required String idUser})  async {
    final result=await FirebaseFirestore.instance.collection(FirebaseConstants.collectionProblem)
        .where('idUser',isEqualTo: idUser)
        .get()
        .then((onValueFetchProblems))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }


  static updateRobotReal({required RobotModel robot}) async {

    final result = await database.child(FirebaseConstants.collectionRobot).child(robot?.id??"")
    // set({'${planetModel.id}': planetModel.toJson()})
        .update( robot.toJson())
        .then(onValueUpdateRobotModel)
        .catchError(onError)
        .timeout(timeOut, onTimeout: onTimeOut);
    return result;
  }

  ///Notification
  static addNotification( {required NotificationModel notification}) async {
    final result= await FirebaseFirestore.instance.collection(FirebaseConstants.collectionNotification).add(
        notification.toJson()
    ).then(onValueAddNotification).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static updateNotification({required NotificationModel notification}) async {
    final result = await FirebaseFirestore.instance
        .collection(FirebaseConstants.collectionNotification)
        .doc(notification.id)
        .update(notification.toJson())
        .then(onValueUpdateNotification)
        .catchError(onError)
        .timeout(timeOut, onTimeout: onTimeOut);
    return result;
  }
  ///Activity
  static addActivity( {required ActivityModel activity}) async {
    final result= await FirebaseFirestore.instance.collection(FirebaseConstants.collectionActivity).add(
        activity.toJson()
    ).then(onValueAddActivity).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static updateActivity({required ActivityModel activity}) async {
    final result = await FirebaseFirestore.instance
        .collection(FirebaseConstants.collectionActivity)
        .doc(activity.id)
        .update(activity.toJson())
        .then(onValueUpdateNotification)
        .catchError(onError)
        .timeout(timeOut, onTimeout: onTimeOut);
    return result;
  }



  static Future<Map<String,dynamic>>  onError(error) async {
    return {
      'status':false,
      'message':error,
      // 'body':null
    };
  }
  static Future<Map<String,dynamic>>  onTimeOut() async {
    return {
      'status':false,
      'message':'time out',
      //'body':""
    };
  }
  static Future<Map<String,dynamic>>  errorUser(String messageError) async {
    print(false);
    print(messageError);
    return {
      'status':false,
      'message':messageError,
      //'body':""
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUser(value) async{
    // print(true);
    print('uid ${await (value.docs.length>0)?value.docs[0]['uid']:null}');
    print("user : ${(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null}");
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUserByUserName(value) async{
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUserId(value) async{
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUsers(value) async{
    print("Users count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Users successfully fetch',
      'body':value.docs
    };
  }




  static Future<Map<String,dynamic>>onValueAddProblem(value) async{
    return {
      'status':true,
      'message':'Problem successfully add',
      'body':{},//{'id':value.id}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateProblem(value) async{
    return {
      'status':true,
      'message':'Problem successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchProblems(value) async{
    return {
      'status':true,
      'message':'Problems successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteProblem(value) async{
    return {
      'status':true,
      'message':'Problem successfully delete',
      'body':{}
    };
  }
  static Future<Map<String, dynamic>> onValueUpdateRobotModel(value) async {
    return {
      'status': true,
      'message': 'Robot successfully update',
      'body': {}
    };
  }

  static Future<Map<String,dynamic>>onValueAddNotification(value) async{
    return {
      'status':true,
      'message':'Notification successfully add',
      'body':{}
    };
  }
  static Future<Map<String, dynamic>> onValueUpdateNotification(value) async {
    return {
      'status': true,
      'message': 'Notification successfully update',
      'body': {}
    };
  }
  static Future<Map<String,dynamic>>onValueAddActivity(value) async{
    return {
      'status':true,
      'message':'Activity successfully add',
      'body':{}
    };
  }






  static String findTextToast(String text){
    String errorMessage='';
    print("error:$text");
    switch(text.toLowerCase()){
      // login
      case "user-not-found":
        errorMessage = "No user found with this email.";
        // errorMessage = "لا يوجد مستخدم لهذا البريد.";
        break;
      case "wrong-password":
        errorMessage = "Incorrect password.";
        // errorMessage = "كلمة السر غير صحيحة.";
        break;
      case "invalid-email":
        // errorMessage = "البريد الالكتروني البدخل غير صالح";
        break;
      case "user-disabled":
        // errorMessage = "المستخدم غير مفعل.";
        break;
      case "too-many-requests":
        errorMessage =
        ".حاولت تسجيل الدخول مرات عديدة، حاول لاحقاً";
        errorMessage="Too many requests";
        break;
      // register
      case "email-already-in-use":
        errorMessage = ".هذا البريد موجود مسبقاً";
        errorMessage="email already in use";
        break;
      case "invalid-email":
        errorMessage = "البريد الالكتروني غير صالح.";
        errorMessage = "Invalid email";
        break;
      case "weak-password":
        errorMessage = "Password is too weak. It must be at least 6 characters long, including at least one uppercase letter, one lowercase letter, and one digit.";
        // errorMessage = "كلمة المرور ضعيفة، يجب أن تحوي 6 محارف، وتتضمن حرف كبير وحرف صغير، وأيضا علامة ترقيم";
        break;
      case "invalid email":
        errorMessage = "البريد الالكتروني غير صالح.";
        errorMessage = "Invalid email";
        break;
      case "invalid-credential":
        errorMessage = "المستخدم غير صحيح.";
        errorMessage = "Invalid credential";
        break;

      case "account successfully logged":
        errorMessage =
        "تم تسجيل الدخول بنجاح";
        errorMessage = "Account successfully logged";
        break;
      case "users successfully fetch":
        errorMessage =
        "تم جلب معلومات المستخدمين بنجاح";
        errorMessage = "Users successfully fetch";
        break;
      case "problem successfully add":
        errorMessage =
        "تمت إضافة مشكلة بنجاح";
        break;
      case "problem successfully update":
        errorMessage =
        "تم تحديث المشكلة بنجاح";
        break;
      case "problem successfully fetch":
        errorMessage =
        "تم جلب المشكلة بنجاح";
        break;
      case "account successfully created":
        errorMessage =
        "تم انشاء الحساب بنجاح";
        break;
      case "problem successfully delete":
        errorMessage =
        "تم حذف المشكلة بنجاح";
        break;
      case "":
        errorMessage =
        "";
        break;
      case "":
        errorMessage =
        "";
        break;
      case "":
        errorMessage =
        "";
        break;
      default:
        errorMessage = "An unexpected error occurred. Please try again later.";
        errorMessage = "حصل خطأ، الرجاء المحاولة لاحقاً";
        errorMessage = text;
    }
    print("error trans: $errorMessage");

    // if(text.contains("Password should be at least 6 characters")){
    //   return tr(LocaleKeys.toast_short_password);
    // }else if(text.contains("The email address is already in use by another account")){
    //   return tr(LocaleKeys.toast_email_already_use);
    // }
    // else if(text.contains("Account Unsuccessfully created")){
    //   return tr(LocaleKeys.toast_Unsuccessfully_created);
    // }
    // else if(text.contains("Account successfully created")){
    //    return tr(LocaleKeys.toast_successfully_created);
    // }
    // else if(text.contains("The password is invalid or the user does not have a password")){
    //    return tr(LocaleKeys.toast_password_invalid);
    // }
    // else if(text.contains("There is no user record corresponding to this identifier")){
    //    return tr(LocaleKeys.toast_email_invalid);
    // }
    // else if(text.contains("The email address is badly formatted")){
    //   return tr(LocaleKeys.toast_email_invalid);
    // }
    // else if(text.contains("Account successfully logged")){
    //     return tr(LocaleKeys.toast_successfully_logged);
    // }
    // else if(text.contains("A network error")){
    //    return tr(LocaleKeys.toast_network_error);
    // }
    // else if(text.contains("An internal error has occurred")){
    //   return tr(LocaleKeys.toast_network_error);
    // }else if(text.contains("field does not exist within the DocumentSnapshotPlatform")){
    //   return tr(LocaleKeys.toast_Bad_data_fetch);
    // }else if(text.contains("Given String is empty or null")){
    //   return tr(LocaleKeys.toast_given_empty);
    // }
    // else if(text.contains("time out")){
    //   return tr(LocaleKeys.toast_time_out);
    // }
    // else if(text.contains("Account successfully logged")){
    //   return tr(LocaleKeys.toast);
    // }
    // else if(text.contains("Account not Active")){
    //   return tr(LocaleKeys.toast_account_not_active);
    // }

    return errorMessage;
  }

  static Future uploadImage({required XFile image,  String folder='images'}) async {

    try{
      String path = image.name;
      File file =File(image.path);
      Reference storage = FirebaseStorage.instance.ref().child("${folder}/${path}");
      UploadTask storageUploadTask = storage.putFile(file);
      TaskSnapshot taskSnapshot = await storageUploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    }catch(e){
      String errorMessage;
      errorMessage = "An unexpected error occurred. Please try again later.";
      Get.back();
      Get.snackbar(
          "خطأ",
          errorMessage,
          backgroundColor: ColorManager.errorColor
      );
    }
  }

}

class FirebaseHelperFun {
  static Future<Map<String, dynamic>> onValueSignup(value) async {
    print(true);
    print("uid : ${value.user?.uid}");
    return {
      'status': true,
      'message': 'Account successfully created',
      'body': value.user
    };
  }

  static Future<Map<String, dynamic>> onTimeOut() async {
    print(false);
    return {
      'status': false,
      'message': 'time out',
      //'body':""
    };
  }

  static Future<Map<String, dynamic>> onError(error) async {
    print(false);
    print(error);
    var errorMessage;
    if (error is FirebaseAuthException) {
      errorMessage = error.message ?? "Firebase Authentication Error";
    } else if (error is FirebaseException) {
      errorMessage = error.message ?? "Firebase Error";
    } else {
      errorMessage = error;
    }

    return {
      'status': false,
      'message': errorMessage,
      //'body':""
    };
  }
}
