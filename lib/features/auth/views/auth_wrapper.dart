import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/firebase_auth_controller.dart';
import '../../onboarding/views/splash_view.dart';
import '../../home/views/home_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(FirebaseAuthController());

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashView();
        }

        // If user is logged in, show home
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeView();
        }

        // If user is not logged in, show splash (which will redirect to login)
        return const SplashView();
      },
    );
  }
}
