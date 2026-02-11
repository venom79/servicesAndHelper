import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/provider_dashboard.dart';
import '../screens/customer_dashboard.dart';

// New Screens
import '../screens/service_list_screen.dart';
import '../screens/service_detail_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/my_bookings_screen.dart';
import '../screens/add_service_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String providerDashboard = "/provider-dashboard";
  static const String customerDashboard = "/customer-dashboard";

  // New Routes
  static const String serviceList = "/service-list";
  static const String serviceDetail = "/service-detail";
  static const String booking = "/booking";
  static const String myBookings = "/my-bookings";
  static const String addService = "/add-service";
  static const String profile = "/profile";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),

    // Removed const here
    providerDashboard: (context) => ProviderDashboard(),
    customerDashboard: (context) => CustomerDashboard(),

    // New Screens
    serviceList: (context) => const ServiceListScreen(),
    serviceDetail: (context) => const ServiceDetailScreen(),
    booking: (context) => const BookingScreen(),
    myBookings: (context) => const MyBookingsScreen(),
    addService: (context) => const AddServiceScreen(),
    profile: (context) => const ProfileScreen(),
  };
}
