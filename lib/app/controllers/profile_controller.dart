import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

import '../../core/local/storage.dart';
import '../../core/models/user_model.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/app_constant.dart';
import '../../core/utils/color_manager.dart';
import '../../core/utils/string_manager.dart';
import '../../core/widgets/constants_widgets.dart';
import 'firebase/firebase_fun.dart';

class ProfileController extends GetxController {
  late final ImagePicker _imagePicker;
  File? profileImage;
  String?  imagePath;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final genders= [StringManager.male, StringManager.female];
  // static ProfileController?   _instance;
  // static ProfileController  get instance =>init();
  // static init(){
  //   if(_instance!=null)
  //     _instance=Get.put(ProfileController());
  //   return _instance!;
  // }
  // static ProfileController  get instance => Get.find<ProfileController>();
  final Rx<UserModel?> currentUser = Rx(null);
  final timeLimit = Duration(seconds: 60);
  //controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? gender;

  Future<void> updateImage(XFile? image) async {
    try {
      // ConstantsWidgets.showLoading(context);
      String? imagePath;
      if(image!=null){
        imagePath=await FirebaseFun.uploadImage(image: image);
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
          .update({'photoUrl':imagePath}).timeout(timeLimit)
          .then((value){
        Get.back();
        Get.snackbar(
            "Success",
            'Successful update image',
            backgroundColor: ColorManager.successColor
        );
        // Get.offAll(HomePage());
      });

    } catch (e) {
      String errorMessage;
      // errorMessage = "An unexpected error occurred. Please try again later.";
      errorMessage = "An unexpected error occurred. Please try again later.";
      Get.back();
      Get.snackbar(
          "خطأ",
          errorMessage,
          backgroundColor: ColorManager.errorColor
      );
    }
  }
  Future<void> updateUser(
      ) async {
    String name=nameController.value.text;
        String email=emailController.value.text;
    try {
      // ConstantsWidgets.showLoading(context);
      if(profileImage!=null){
        imagePath=await FirebaseFun.uploadImage(image: XFile(profileImage!.path));
        profileImage=null;
      }
      if(email!=currentUser.value?.email)
        auth.currentUser?.verifyBeforeUpdateEmail(email);
        // auth.currentUser?.updateEmail();
      // if(password!=''&&password!=null)
      //   auth.currentUser?.updatePassword(password!);

      UserModel? userModel=UserModel(
        name: name,
        email: email,
        phoneNumber: phoneController.value.text,
        userName: userNameController.value.text,
        gender: gender,
        photoUrl: imagePath,
        typeUser: currentUser.value?.typeUser,
        uid:currentUser.value?.uid ,
        id: currentUser.value?.id,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
          .update(userModel.toJson()).timeout(timeLimit)
          .then((value){
        currentUser.value=userModel;
        update();

        Get.back();
        Get.snackbar(
            StringManager.message_success,
            StringManager.message_successfully_update,
            backgroundColor: ColorManager.successColor
        );
        // if(email!=currentUser.value?.email||(password!=''&&password!=null))
        //    Get.offAll(SplashScreen());

      });

    } catch (e) {
      String errorMessage;
      // errorMessage = "An unexpected error occurred. Please try again later.";
      errorMessage = "An unexpected error occurred. Please try again later.";

      Get.back();
      Get.snackbar(
          StringManager.message_failure,
          errorMessage,
          backgroundColor: ColorManager.errorColor
      );
    }
  }
  Future<void> getUser(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid ??
          '${await AppStorage.storageRead(key: AppConstants.uidKEY)}'??'')
          .get()
          .then((value){
        currentUser.value=UserModel.fromJson(value);
        update();
        // Get.snackbar(
        //     AppString.message_success,
        //     AppString.message_successful_get_user,
        //     backgroundColor: ColorManager.successColor
        // );
      });
      // if(currentUser.value?.isAdmin??false)
      //   Get.offAll(NavBarAdminScreen());
      // else
      //   Get.offAll(NavbarUserScreen());



    } catch (e) {
      String errorMessage;
      // errorMessage = "An unexpected error occurred. Please try again later.";
      errorMessage = "An unexpected error occurred. Please try again later.";
      Get.snackbar(
          StringManager.message_failure,
          errorMessage,
          backgroundColor: ColorManager.errorColor
      );
      context.pushAndRemoveUntil(Routes.loginRoute, predicate: (Route<dynamic> route) =>false);

      // Get.offAll(LoginScreen());
    }
  }



  ///image local
  void deletePhoto() {
    Get.back();
    profileImage = null;
    imagePath=null;

    update();
  }

  Future<void> pickPhoto(ImageSource source) async {
    Get.back();
    final XFile? result = await _imagePicker.pickImage(source: source);
    if (result != null) {
      profileImage = File(result.path);
      update();
    }
  }


  void refresh(){
    nameController = TextEditingController(text: currentUser.value?.name);
    userNameController = TextEditingController(text: currentUser.value?.userName);
    emailController = TextEditingController(text: currentUser.value?.email);
    phoneController = TextEditingController(text: currentUser.value?.phoneNumber);

    // gender=genders.firstWhereOrNull((element)=>element==currentUser.value?.gender);
    // genderController = TextEditingController();
    imagePath=currentUser.value?.photoUrl;
  }
  @override
  void onInit() {
    _imagePicker = ImagePicker();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
