import 'package:bookingapp/ui/home_screen/home_screen.dart';
import 'package:bookingapp/ui/intro_screen/intro_screen.dart';
import 'package:bookingapp/ui/login_screen/login_screen.dart';
import 'package:bookingapp/ui/mybooking_screen/mybooking_screen.dart';
import 'package:bookingapp/ui/signup_screen/signup_screen.dart';
import 'package:bookingapp/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String login_screen = "/login_screen";
  static const String signup_screen = "/signup_screen";
  static const String home_screen = "/home_screen";
  static const String mybooking_screen = "/mybooking_screen";
  static const String intro_screen = "/intro_screen";

  static Route animateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case login_screen:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: routeSettings,
        );
      case signup_screen:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
          settings: routeSettings,
        );
      case home_screen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: routeSettings,
        );
      case mybooking_screen:
        return MaterialPageRoute(
          builder: (_) => MybookingScreen(),
          settings: routeSettings,
        );
      case intro_screen:
        return MaterialPageRoute(
          builder: (_) => IntroScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: routeSettings,
        );
    }
  }
}
