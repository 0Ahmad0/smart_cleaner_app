import 'package:flutter/material.dart';
import 'package:smart_cleaner_app/app/screens/check_inbox_screen.dart';
import 'package:smart_cleaner_app/app/screens/forgot_password_screen.dart';
import 'package:smart_cleaner_app/app/screens/guest/home_guest_screen.dart';
import 'package:smart_cleaner_app/app/screens/login_screen.dart';
import 'package:smart_cleaner_app/app/screens/select_role_screen.dart';
import 'package:smart_cleaner_app/app/screens/signup_screen.dart';
import 'package:smart_cleaner_app/app/screens/splash_screen.dart';

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
        ); case Routes.selectRoleRoute:
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
        case Routes.homeGuestRoute:
        return MaterialPageRoute(
          builder: (_) => HomeGuestScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('NO DATA')),
          ),
        );
    }
  }
}
