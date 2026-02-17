import 'package:get/get.dart';
import 'package:flutter_login/features/splash/splash_page.dart';
import 'package:flutter_login/features/auth/login_page.dart';
import 'package:flutter_login/features/auth/register_page.dart';
import 'package:flutter_login/features/auth/forgot_password_page.dart';
import 'package:flutter_login/features/auth/otp_page.dart';
import 'package:flutter_login/features/auth/change_password_page.dart';
import 'package:flutter_login/features/home/home_page.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/splash', page: () => const SplashScreen()),
    GetPage(name: '/login', page: () => const MyLogin()),
    GetPage(name: '/register', page: () => const MyRegister()),
    GetPage(name: '/home', page: () => const MyHomePage()),
    GetPage(name: '/forgotpassword', page: () => const MyForgotPass()),
    GetPage(name: '/otp', page: () => const OtpVerificationPage()),
    GetPage(name: '/changepassword', page: () => const MyPasswordChange()),
  ];
}
