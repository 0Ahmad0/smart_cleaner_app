

import 'package:flutter/material.dart';
import 'package:smart_cleaner_app/app/screens/login_screen.dart';
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
