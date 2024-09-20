

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
            theme: ThemeData(
                dividerColor: ColorManager.hintTextColor,
                primaryColor: ColorManager.primaryColor,
                primarySwatch: ColorManager.primaryColor.toMaterialColor(),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: ColorManager.primaryColor,
                ),
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  titleTextStyle: StyleManager.font18Medium(),
                  backgroundColor: ColorManager.whiteColor,
                  elevation: 0.0,
                ),
                tabBarTheme: TabBarTheme(
                  labelColor: ColorManager.whiteColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: MaterialStateProperty.all(
                      ColorManager.primaryColor.withOpacity(.1)),
                  unselectedLabelColor: ColorManager.primaryColor,
                  indicator: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                ),
                scaffoldBackgroundColor: ColorManager.whiteColor,
                fontFamily: GoogleFonts.cairo().fontFamily,
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                  double.maxFinite,
                  ConstValueManager.heightButtonSize,
                ))),
            ),
            initialRoute: Routes.initialRoute,
            onGenerateRoute: appRouter.generateRoute,
            routes: {
            },
          );
        });
  }
}
