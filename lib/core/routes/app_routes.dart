import 'package:get/get.dart';
import '../../features/onboarding/views/splash_view.dart';
import '../../features/home/views/home_view.dart';

import '../../features/categories/views/categories_view.dart';
import '../../features/products/views/products_view.dart';
import '../../features/cart/views/cart_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/scanner/views/scanner_view.dart';
import '../../features/categories/views/streetwear_view.dart';
import '../../features/categories/views/jerseys_view.dart';
import '../../features/categories/views/casual_shirts_view.dart';
import '../../features/product/views/simple_product_detail_view.dart';
import '../../features/checkout/views/checkout_view.dart';
import '../../features/wishlist/views/wishlist_view.dart';
import '../../features/profile/views/account_info_view.dart';
import '../../features/orders/views/orders_view.dart';
import '../../features/help/views/help_support_view.dart';
import '../../features/help/views/privacy_policy_view.dart';
import '../../features/terms_of_service/views/terms_of_service_view.dart';
import '../../features/products/views/all_products_view.dart';
import '../../features/auth/views/auth_wrapper.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';

import '../../features/profile/views/edit_profile_view.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';

  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String accountInfo = '/account-info';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String allProducts = '/all-products';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String scanner = '/scanner';
  static const String streetwear = '/streetwear';
  static const String jerseys = '/jerseys';
  static const String casualShirts = '/casual-shirts';
  static const String simpleProductDetail = '/simple-product';
  static const String checkout = '/checkout';
  static const String adminPanel = '/admin-panel';
  static const String editProfile = '/edit-profile';

  // Route pages
  static final List<GetPage> pages = [
    GetPage(
      name: initial,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: home,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: categories,
      page: () => const CategoriesView(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: cart,
      page: () => const CartView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: wishlist,
      page: () => const WishlistView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: accountInfo,
      page: () => const AccountInfoView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: scanner,
      page: () => const ScannerView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: streetwear,
      page: () => const StreetwearView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: jerseys,
      page: () => const JerseysView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: casualShirts,
      page: () => const CasualShirtsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: simpleProductDetail,
      page: () => const SimpleProductDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: checkout,
      page: () => const CheckoutView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orders,
      page: () => const OrdersView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: help,
      page: () => const HelpSupportView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacyPolicy,
      page: () => const PrivacyPolicyView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: allProducts,
      page: () => const AllProductsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: termsOfService,
      page: () => const TermsOfServiceView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signup,
      page: () => const SignupView(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
      transition: Transition.rightToLeft,
    ),
  ];

  // Navigation methods
  static void goToHome() => Get.offAllNamed(home);
  static void goToLogin() => Get.toNamed(login);
  static void goToSignup() => Get.toNamed(signup);

  static void goToProductDetail({required String productId}) =>
      Get.toNamed('/simple-product', arguments: {'productId': productId});

  // Go back
  static void goBack() => Get.back();

  // Clear and navigate
  static void clearAndGoTo(String route) => Get.offAllNamed(route);
}
