import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_constants.dart';
import 'features/home/controllers/home_controller.dart';
import 'features/product/controllers/product_controller.dart';
import 'features/wishlist/controllers/wishlist_controller.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/checkout/controllers/checkout_controller.dart';
import 'features/auth/controllers/firebase_auth_controller.dart';
import 'features/auth/controllers/user_profile_controller.dart';
import 'features/auth/views/auth_wrapper.dart';
import 'features/product/controllers/firestore_product_controller.dart';
import 'features/orders/controllers/orders_controller.dart';
import 'shared/services/api_service.dart';
import 'shared/services/storage_service.dart';
import 'shared/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize services first
    await Get.putAsync(() => StorageService().onInit());
    Get.put(ApiService());

    // Initialize controllers after services
    Get.put(FirebaseAuthController());
    Get.put(UserProfileController());
    Get.put(WishlistController());
    Get.put(CartController());
    Get.put(CheckoutController());
    Get.put(OrdersController());

    // Firestore service is automatically initialized with Firebase

    // Initialize FirestoreProductController first as it's needed by HomeController
    final firestoreController = Get.put(FirestoreProductController());

    // Wait for FirestoreProductController to load data
    await firestoreController.loadProducts();

    Get.put(HomeController());
    Get.put(ProductController());

    runApp(const MyApp());
  } catch (e) {
    print('Error during initialization: $e');
    // Fallback initialization - still try to initialize controllers
    try {
      // Firestore service is automatically initialized with Firebase

      // Initialize FirestoreProductController first
      final firestoreController = Get.put(FirestoreProductController());
      await firestoreController.loadProducts();

      Get.put(HomeController());
      Get.put(ProductController());
      Get.put(UserProfileController());
      Get.put(WishlistController());
      Get.put(CartController());
      Get.put(CheckoutController());
      Get.put(OrdersController());
    } catch (controllerError) {
      print('Controller initialization error: $controllerError');
    }
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
