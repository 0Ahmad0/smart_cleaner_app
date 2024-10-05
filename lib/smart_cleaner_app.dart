import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_cleaner_app/app/screens/admin/home_admin_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/show_activities_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/workers_profiles_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/home_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/home_worker_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/profile_robot_worker_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/setting_screen.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/utils/color_manager.dart';
import 'core/utils/const_value_manager.dart';
import 'core/utils/string_manager.dart';
import 'core/utils/style_manager.dart';

class SmartCleanerApp extends StatelessWidget {
  const SmartCleanerApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(
          ConstValueManager.widthSize,
          ConstValueManager.heightSize,
        ),
        builder: (context, child) {
          return MaterialApp(
            title: StringManager.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              dividerColor: ColorManager.hintTextColor,
              primaryColor: ColorManager.primaryColor,
              primarySwatch: ColorManager.primaryColor.toMaterialColor(),
              colorScheme: ColorScheme.fromSeed(
                seedColor: ColorManager.primaryColor,
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: ColorManager.whiteColor
                ),
                backgroundColor: ColorManager.primaryColor,
                titleTextStyle:
                    StyleManager.font24Medium(color: ColorManager.whiteColor)
                        .copyWith(
                  fontFamily: GoogleFonts.playpenSans().fontFamily,
                ),
                elevation: 0.0,
              ),
              tabBarTheme: TabBarTheme(
                labelColor: ColorManager.whiteColor,
                unselectedLabelColor: ColorManager.blackColor.withOpacity(.5),
                indicatorColor: ColorManager.whiteColor,
                indicatorSize: TabBarIndicatorSize.tab,

              ),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              ),
              scaffoldBackgroundColor: ColorManager.whiteColor,
              fontFamily: GoogleFonts.playpenSans().fontFamily,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                double.maxFinite,
                ConstValueManager.heightButtonSize,
              ))),
            ),
            // home: HomeWorkerScreen(),
            initialRoute: Routes.initialRoute,
            onGenerateRoute: appRouter.generateRoute,
            routes: {
              Routes.profileRobotWorkerRoute: (_)=>ProfileRobotWorkerScreen(),
              Routes.settingWorkerRoute: (_)=>SettingScreen(),
              Routes.workerProfilesRoute: (_)=>WorkerProfilesAdminScreen(),
              Routes.showActivitiesWorkerAdminRoute: (_)=>ShowActivitiesWorkerScreen(),
            },
          );
        });
  }
}
