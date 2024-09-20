import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/smart_cleaner_app.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// To Fix Bug In Text Showing In Release Mode
  await ScreenUtil.ensureScreenSize();

  runApp(SmartCleanerApp(
    appRouter: AppRouter(),
  ));
}

