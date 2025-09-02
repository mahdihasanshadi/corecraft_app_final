import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Error state
  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // Success state
  final _successMessage = ''.obs;
  String get successMessage => _successMessage.value;

  // Set loading state
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  // Set error message
  void setError(String message) {
    _errorMessage.value = message;
    // Auto clear error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _errorMessage.value = '';
    });
  }

  // Set success message
  void setSuccess(String message) {
    _successMessage.value = message;
    // Auto clear success after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _successMessage.value = '';
    });
  }

  // Clear messages
  void clearMessages() {
    _errorMessage.value = '';
    _successMessage.value = '';
  }

  // Show loading
  void showLoading() {
    setLoading(true);
  }

  // Hide loading
  void hideLoading() {
    setLoading(false);
  }

  // Handle API calls with loading state
  Future<T?> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      showLoading();
      clearMessages();
      final result = await apiCall();
      hideLoading();
      return result;
    } catch (e) {
      hideLoading();
      setError(e.toString());
      return null;
    }
  }

  // Show snackbar
  void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? Get.theme.colorScheme.error
          : Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 3),
    );
  }

  // Show error snackbar
  void showErrorSnackbar(String message) {
    showSnackbar('Error', message, isError: true);
  }

  // Show success snackbar
  void showSuccessSnackbar(String message) {
    showSnackbar('Success', message);
  }

  // Show info snackbar
  void showInfoSnackbar(String message) {
    showSnackbar('Info', message);
  }

  // Navigate to page
  void navigateTo(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }

  // Navigate and replace current page
  void navigateAndReplace(String route, {dynamic arguments}) {
    Get.offNamed(route, arguments: arguments);
  }

  // Navigate and clear all previous pages
  void navigateAndClear(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }

  // Go back
  void goBack() {
    Get.back();
  }

  // Close current page
  void closePage() {
    Get.back();
  }

  // Show dialog
  void showDialog(Widget dialog) {
    Get.dialog(dialog);
  }

  // Show bottom sheet
  void showBottomSheet(Widget bottomSheet) {
    Get.bottomSheet(bottomSheet);
  }

  // Show loading dialog
  void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  @override
  void onClose() {
    clearMessages();
    super.onClose();
  }
}
