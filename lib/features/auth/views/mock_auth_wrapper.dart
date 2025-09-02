import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mock_auth_controller.dart';
import '../../onboarding/views/splash_view.dart';
import '../../home/views/home_view.dart';
import 'login_view.dart';

class MockAuthWrapper extends StatelessWidget {
  const MockAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<MockAuthController>();

    return Obx(() {
      // Show loading while checking authentication state
      if (authController.isLoading) {
        return const SplashView();
      }

      // If user is authenticated, show home screen
      if (authController.isLoggedIn) {
        return const HomeView();
      }

      // If user is not authenticated, show login screen
      return const LoginView();
    });
  }
}
