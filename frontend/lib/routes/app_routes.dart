import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/provider_dashboard.dart';
import '../screens/customer_dashboard.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String providerDashboard = "/provider-dashboard";
  static const String customerDashboard = "/customer-dashboard";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    providerDashboard: (context) => ProviderDashboard(),
    customerDashboard: (context) => CustomerDashboard(),
  };
}
