import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cleaner_app/app/screens/admin/activities_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/home_admin_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/other_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/show_activities_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/track_the_robot_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/workers_profiles_screen.dart';
import 'package:smart_cleaner_app/app/screens/check_inbox_screen.dart';
import 'package:smart_cleaner_app/app/screens/forgot_password_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/home_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/pick_location_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/report_problem_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/login_screen.dart';
import 'package:smart_cleaner_app/app/screens/problems_chart_screen.dart';
import 'package:smart_cleaner_app/app/screens/select_role_screen.dart';
import 'package:smart_cleaner_app/app/screens/signup_screen.dart';
import 'package:smart_cleaner_app/app/screens/splash_screen.dart';
import 'package:smart_cleaner_app/app/screens/weather_chart_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/cancel_trip_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/robot_on_duty_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/home_worker_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/notification_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/problems_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/profile_robot_worker_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/robot_path_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/setting_screen.dart';

import '../../app/screens/weather/ui/widgets/main_screen/weather_screen.dart';
import '../../app/screens/weather/ui/widgets/main_screen/weather_screen_model.dart';
import '../../app/screens/worker/select_path_robot_screen.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
    case Routes.initialRoute:
      return MaterialPageRoute(
        builder: (_) => SplashScreen(),
      );

      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
        );
      case Routes.selectRoleRoute:
        return MaterialPageRoute(
          builder: (_) => SelectRoleScreen(),
        );
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case Routes.checkInboxRoute:
        return MaterialPageRoute(
          builder: (_) => CheckInboxScreen(),
        );

      case Routes.weatherRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ChangeNotifierProvider(
            child: const WeatherScreen(),
            create: (_) => WeatherScreenModel(),
            lazy: false,
          );
        });
      case Routes.weatherChartRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return WeatherChartScreen();
        });
      case Routes.problemsChartRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ProblemsChartScreen();
        });


    ///Admin
      case Routes.homeAdminRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return HomeAdminScreen();
        });
      case Routes.activitiesRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ActivitiesScreen();
        });
      case Routes.workerProfilesRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return WorkerProfilesAdminScreen();
        });
      case Routes.trackTheRobotRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return TrackTheRobotScreen();
        });
        case Routes.showActivitiesWorkerAdminRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ShowActivitiesWorkerScreen();
        });
        case Routes.otherAdminRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return OtherAdminScreen();
        });

    ///Worker
      case Routes.homeWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return HomeWorkerScreen();
        });
      case Routes.notificationWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return NotificationScreen();
        });
      case Routes.problemsWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ProblemsScreen();
        });
      case Routes.settingWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return SettingScreen();
        });
      case Routes.robotOnDutyWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return RobotOnDutyScreen();
        });case Routes.cancelTripWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return CancelTripScreen();
        });
      case Routes.profileRobotWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ProfileRobotWorkerScreen();
        });
        case Routes.robotPathWorkerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return RobotPathWorkerScreen();
        });

    ///Guest

      case Routes.homeGuestRoute:
        return MaterialPageRoute(
          builder: (_) => HomeGuestScreen(),
        );
      case Routes.reportProblemGuestRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return ReportProblemGuestScreen();
        });
      case Routes.pickLocationGuestRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return PickLocationScreen();
        });
      case Routes.selectPathRobotRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return SelectPathRobotScreen();
        });
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(
                body: Center(child: Text('NO DATA')),
              ),
        );
    }
  }
}
