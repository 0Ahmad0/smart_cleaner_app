import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/firebase_options.dart';
import 'package:smart_cleaner_app/smart_cleaner_app.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //set
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  /// To Fix Bug In Text Showing In Release Mode
  await ScreenUtil.ensureScreenSize();

  runApp(SmartCleanerApp(
    appRouter: AppRouter(),
  ));
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
