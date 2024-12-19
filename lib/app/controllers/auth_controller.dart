
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

import '../../core/local/storage.dart';
import '../../core/models/user_model.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/app_constant.dart';
import '../../core/utils/string_manager.dart';
import '../../core/widgets/constants_widgets.dart';
import 'firebase/firebase_constants.dart';
import 'firebase/firebase_fun.dart';
import 'profile_controller.dart';

import '../screens/splash_screen.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();

  static AuthController get instance => Get.find();

  //controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String typeUser=AppConstants.collectionUser;

  init() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    typeUser=AppConstants.collectionUser;
  }

  int currentIndex = 0;
  late final PageController pageController;
  final List<String> tabsList = [
    StringManager.loginText,
    StringManager.signUpText
  ];

  final FirebaseAuth auth = FirebaseAuth.instance;

  _initPageView() {
    pageController = PageController(initialPage: 0);
  }

  navigateToPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    currentIndex = index;
    update();
  }

  validatePassword(String value) {
    RegExp regex =
        // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        RegExp(r'^(?=.*).{8,}$');
    if (value.isEmpty) {
      return StringManager.requiredField;
    }
    else if (!regex.hasMatch(value)) {


      return 'Error';
    }
    else {
      return null;
    }
  }
  validateConfirmPassword(String value,String password) {
    if (value.isEmpty) {
      return StringManager.requiredField;
    }
    else if (value!=password) {

      return 'Not Match';
    }
    else {
      return null;
    }
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return StringManager.requiredField;
    } else {
      if (!value.isPhoneNumber) {
        return 'Error';
      } else {
        return null;
      }
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return StringManager.requiredField;
    } else {
      if (!value.isEmail) {
        return 'Error';
      } else {
        return null;
      }
    }
  }

  String? validateFullName(String value) {
    if (value.isEmpty) {
      return StringManager.requiredField;
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    String userName = emailController.value.text;
    String password = passwordController.value.text;
    String email = userName;
    try {
      ConstantsWidgets.showLoading();

      var result = await FirebaseFun.fetchUserByUserName(userName: userName);

      ///handling
      // !result['status']?throw FirebaseAuthException(code: result['message']):'';
      print(result);
      if (result['status'] && result['body'] != null) {
        UserModel? userModel = UserModel.fromJson(result['body']);
        // if(userModel==null)
        //   throw FirebaseAuthException(code: AppString.message_user_name_invalid);
        email = userModel.email ?? userName;
      }

      //,,,,,,,,,,,,,,,,,
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(FirebaseFun.timeOut)
          .then((value) async {
        ConstantsWidgets.TOAST(null,
            textToast: StringManager.message_successful_login, state: true);
        // Get.snackbar(
        //     AppString.message_success,
        //     AppString.message_successful_login,
        //     backgroundColor: ColorManager.successColor
        // );

        await AppStorage.storageWrite(
            key: AppConstants.rememberMe, value: true);
        await AppStorage.storageWrite(
            key: AppConstants.uidKEY, value: auth.currentUser?.uid);
        await AppStorage.storageWrite(
            key: AppConstants.EMAIL_KEY, value: email);
        await AppStorage.storageWrite(
            key: AppConstants.PASSWORD_KEY, value: password);

        //Get.offAll(HomePage());
        ProfileController profileController = Get.put(ProfileController());
        ;
        await profileController.getUser(context);
        // context.pop();
        Get.back();
        if (profileController.currentUser.value?.isAdmin ?? false)
          context.pushAndRemoveUntil(Routes.homeAdminRoute,
              predicate: (Route<dynamic> route) => false);
        else  if (profileController.currentUser.value?.isWorker ?? false)
          context.pushAndRemoveUntil(Routes.homeWorkerRoute,
              predicate: (Route<dynamic> route) => false);

        // Get.offAll(NavbarScreen());
        // Get.offAll(NavBarAdminScreen());
        else
          context.pushAndRemoveUntil(Routes.homeGuestRoute,
              predicate: (Route<dynamic> route) => false);

        // Get.offAll(NavbarScreen());
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      // Get.back();
      context.pop();
      ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      // Get.snackbar(
      //     AppString.message_failure,
      //    errorMessage,
      //     backgroundColor: ColorManager.errorColor
      // );
    }
  }

  Future<void> signUp(BuildContext context) async {
    String name = nameController.value.text;
    String email = emailController.value.text;
    String phoneNumber = phoneController.value.text;
    String password = passwordController.value.text;

    // String name='Ahmad Mriwed';
    // String email='mr.ahmadmriwed@gmail.com';
    // String phoneNumber='0937954969';
    // String password='12345678';
    try {
      ConstantsWidgets.showLoading();
      // String userName = await _getUserNameByName(name);
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(FirebaseFun.timeOut);
      final user = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          // userName: userName,
          password: password,
          typeUser: typeUser,
          photoUrl: '');
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.collectionUser)
          .doc(user.uid)
          .set(user.toJson());
      await AppStorage.storageWrite(key: AppConstants.rememberMe, value: true);
      await AppStorage.storageWrite(key: AppConstants.uidKEY, value: user.uid);

      // ProfileController.instance.getUser();

      ProfileController profileController = Get.put(ProfileController());
      profileController.currentUser.value = user;
      // if(profileController.currentUser.value?.isAdmin??false)
      if (user.isAdmin)
        context.pushAndRemoveUntil(Routes.homeAdminRoute,
            predicate: (Route<dynamic> route) => false);
      else  if (profileController.currentUser.value?.isWorker ?? false)
        context.pushAndRemoveUntil(Routes.homeWorkerRoute,
            predicate: (Route<dynamic> route) => false);

      // Get.offAll(NavbarScreen());
      // Get.offAll(NavBarAdminScreen());
      else
        context.pushAndRemoveUntil(Routes.homeGuestRoute,
            predicate: (Route<dynamic> route) => false);

      // Get.offAll(NavbarScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      context.pop();
      // Get.back();
      ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
      // Get.snackbar(
      //     AppString.message_failure,
      //     errorMessage,
      //     backgroundColor: ColorManager.errorColor
      // );
    }
  }

  _generateUserNameByName(String name) {
    name = name.toLowerCase();
    List<String> names = name.trim().split(' ');
    String firstName = names.isNotEmpty ? names.first : '';
    String? lastName = names.length > 1 ? names.sublist(1, 2).join(' ') : null;
    String userName = '${firstName}';
    if (lastName != null) userName += '_${lastName}';
    return userName;
  }

  _getUserNameByName(String name) async {
    String genUserName = _generateUserNameByName(name);
    String userName = genUserName;
    var result = await FirebaseFun.fetchUsers();
    if (!result['status']) return null;
    Users users = Users.fromJson(result['body']);
    for (int i = 0; i < 10000; i++) {
      bool exists = users.users.any((user) => user.userName == userName);
      if (exists)
        userName = genUserName + '$i';
      else
        break;
    }
    return userName;
  }


  void signOut(BuildContext context, {bool deleteFromAuth = false}) async {
    await auth.signOut().then((value) async {
      if (deleteFromAuth) {
        auth.currentUser?.delete();
      }
      await AppStorage.depose();
      // await AppStorage.storageDelete(key:AppConstants.rememberMe);
      //  await AppStorage.storageDelete(key:AppConstants.uidKEY);
      //  await AppStorage.storageDelete(key:AppConstants.EMAIL_KEY);
      //  await AppStorage.storageDelete(key:AppConstants.PASSWORD_KEY);
      //  await AppStorage.storageDelete(key:AppConstants.USER_NAME_KEY);
    });
    context.pushAndRemoveUntil(Routes.initialRoute,
        predicate: (Route<dynamic> route) => false);

    // Get.offAll(SplashScreen());
  }

  Future<void> seeder() async {
    List<UserModel> users=[
    UserModel(email: 'admin1@gmail.com', name: 'Admin Acc', password: '1234sS@4321', typeUser: AppConstants.collectionAdmin),
    UserModel(email: 'worker1@gmail.com', name: 'Worker Acc', password: '1234sS@4321', typeUser: AppConstants.collectionWorker),
    UserModel(email: 'user1@gmail.com', name: 'User Acc', password: '1234sS@4321', typeUser: AppConstants.collectionUser),
    UserModel(email: 'guest1@gmail.com', name: 'Guest Acc', password: '1234sS@4321', typeUser: AppConstants.collectionUser),
    // UserModel(email: 'mr.ahmadmriwed@gmail.com', name: 'Ahmad Mriwed', password: '12345678', typeUser: AppConstants.collectionUser,phoneNumber: '0937954969'),
    ];
    try {
      ConstantsWidgets.showLoading();
      for(UserModel userModel in users){
        UserCredential userCredential = await auth
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
      ConstantsWidgets.closeDialog();
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseFun.findTextToast(e.code);
      ConstantsWidgets.closeDialog();
      ConstantsWidgets.TOAST(null, textToast: errorMessage, state: false);
    }
  }

  @override
  void onInit() {
    // _initPageView();
    // passwordController.addListener(() {
    //   update();
    // });

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
