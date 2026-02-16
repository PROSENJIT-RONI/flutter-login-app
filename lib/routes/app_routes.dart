import 'package:get/get.dart';
import 'package:flutter_login/features/splash/splash_page.dart';
import 'package:flutter_login/features/auth/login_page.dart';
import 'package:flutter_login/features/auth/register_page.dart';
import 'package:flutter_login/features/auth/forgot_password_page.dart';
import 'package:flutter_login/features/auth/otp_page.dart';
import 'package:flutter_login/features/auth/change_password_page.dart';
import 'package:flutter_login/features/home/home_page.dart';
import 'package:flutter_login/features/profile/profile_page.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => MyLogin()),
    GetPage(name: '/register', page: () => MyRegister()),
    GetPage(name: '/home', page: () => MyHomePage()),
    GetPage(name: '/forgotpassword', page: () => MyForgotPass()),
    GetPage(name: '/otp', page: () => OtpVerificationPage()),
    GetPage(name: '/changepassword', page: () => MyPasswordChange()),
    GetPage(name: '/profile', page: () => MyProfilePage()),
  ];
}