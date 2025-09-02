import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MockAuthController extends GetxController {
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<Map<String, dynamic>>();

  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  Map<String, dynamic>? get currentUser => _currentUser.value;

  // Mock user database
  final List<Map<String, dynamic>> _mockUsers = [
    {'email': 'test@example.com', 'password': '123456', 'name': 'Test User'},
  ];

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user exists
      final user = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        _currentUser.value = {
          'uid': 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
          'email': user['email'],
          'name': user['name'],
        };
        _isLoggedIn.value = true;

        Get.snackbar(
          'Success',
          'Welcome back, ${user['name']}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    try {
      _isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user already exists
      final existingUser = _mockUsers.any((user) => user['email'] == email);

      if (existingUser) {
        Get.snackbar(
          'Error',
          'User with this email already exists',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Create new user
      final newUser = {
        'email': email,
        'password': password,
        'name': userData['name'],
      };

      _mockUsers.add(newUser);

      _currentUser.value = {
        'uid': 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': userData['name'],
      };
      _isLoggedIn.value = true;

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create account: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser.value = null;
      _isLoggedIn.value = false;

      Get.snackbar(
        'Success',
        'Signed out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    return _currentUser.value;
  }

  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      if (_currentUser.value != null) {
        _currentUser.value = {..._currentUser.value!, ...userData};
      }

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
