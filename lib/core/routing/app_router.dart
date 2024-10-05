import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cleaner_app/app/screens/admin/activities_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/home_admin_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/track_the_robot_screen.dart';
import 'package:smart_cleaner_app/app/screens/admin/workers_profiles_screen.dart';
import 'package:smart_cleaner_app/app/screens/check_inbox_screen.dart';
import 'package:smart_cleaner_app/app/screens/forgot_password_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/home_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/pick_location_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/report_problem_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/login_screen.dart';
import 'package:smart_cleaner_app/app/screens/select_role_screen.dart';
import 'package:smart_cleaner_app/app/screens/signup_screen.dart';
import 'package:smart_cleaner_app/app/screens/splash_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/home_worker_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/notification_screen.dart';
import 'package:smart_cleaner_app/app/screens/worker/problems_screen.dart';

import '../../app/screens/weather/ui/widgets/main_screen/weather_screen.dart';
import '../../app/screens/weather/ui/widgets/main_screen/weather_screen_model.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case Routes.initialRoute:
      //   return MaterialPageRoute(
      //     builder: (_) => SplashScreen(),
      //   );

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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('NO DATA')),
          ),
        );
    }
  }
}
