import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  // Show loading dialog
  static void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Show success snackbar
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Show info snackbar
  static void showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  // Format price
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  // Format date
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final names = name.trim().split(' ');
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    }

    return '${names[0].substring(0, 1)}${names[names.length - 1].substring(0, 1)}'
        .toUpperCase();
  }

  // Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Check if string is empty or null
  static bool isEmptyOrNull(String? text) {
    return text == null || text.trim().isEmpty;
  }

  // Get screen size
  static Size getScreenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  // Get screen width
  static double getScreenWidth() {
    return getScreenSize().width;
  }

  // Get screen height
  static double getScreenHeight() {
    return getScreenSize().height;
  }

  // Check if device is tablet
  static bool isTablet() {
    return getScreenWidth() > 600;
  }

  // Check if device is mobile
  static bool isMobile() {
    return getScreenWidth() <= 600;
  }
}
