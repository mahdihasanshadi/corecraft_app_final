import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/firebase_auth_controller.dart';
import '../../onboarding/views/splash_view.dart';
import '../../home/views/home_view.dart';
import '../views/login_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(FirebaseAuthController());

    return Obx(() {
      // Show loading while auth controller is initializing
      if (authController.isLoading) {
        return const SplashView();
      }

      // If user is logged in, show home
      if (authController.isLoggedIn) {
        return const HomeView();
      }

      // If user is not logged in, show login directly
      return const LoginView();
    });
  }
}
