import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../shared/services/firebase_service.dart';

class FirebaseAuthController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  User? get user => _user.value;
  User? get currentUser => _user.value; // Alias for compatibility
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      _isLoading.value = true;

      // Check if there's a current user with valid token
      final currentUser = FirebaseService.currentUser;
      if (currentUser != null) {
        // Verify token is still valid
        try {
          final token = await currentUser.getIdToken(
            true,
          ); // Force refresh to check validity
          if (token != null && token.isNotEmpty) {
            _user.value = currentUser;
            FirebaseService.setUserId(currentUser.uid);
            FirebaseService.setUserProperty('user_type', 'customer');
            print('✅ User session restored: ${currentUser.email}');
            return;
          }
        } catch (tokenError) {
          print('❌ Token validation failed: $tokenError');
          // Token is invalid, sign out and clear user
          await FirebaseService.signOut();
          _user.value = null;
        }
      }

      // Listen to auth state changes for future updates
      FirebaseService.authStateChanges.listen((User? user) {
        _user.value = user;
        if (user != null) {
          FirebaseService.setUserId(user.uid);
          FirebaseService.setUserProperty('user_type', 'customer');
          print('✅ Auth state changed - User logged in: ${user.email}');
        } else {
          print('ℹ️ Auth state changed - User logged out');
        }
      });
    } catch (e) {
      print('❌ Error initializing auth: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final result = await FirebaseService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      if (result != null) {
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to create account. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign In
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final result = await FirebaseService.signIn(
        email: email,
        password: password,
      );

      if (result != null) {
        Get.snackbar(
          'Success',
          'Welcome back!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        _errorMessage.value = 'Invalid email or password.';
        return false;
      }
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await FirebaseService.signOut();
      Get.snackbar(
        'Success',
        'Signed out successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final success = await FirebaseService.resetPassword(email);

      if (success) {
        Get.snackbar(
          'Success',
          'Password reset email sent!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to send reset email. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update Profile
  Future<bool> updateProfile({String? name, String? phone}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final success = await FirebaseService.updateProfile(
        name: name,
        phone: phone,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to update profile. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get User Data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (_user.value == null) return null;

      final doc = await FirebaseService.getUserData(_user.value!.uid);
      if (doc != null && doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Clear Error
  void clearError() {
    _errorMessage.value = '';
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(String error) {
    if (error.contains('weak-password')) {
      return 'The password provided is too weak.';
    } else if (error.contains('email-already-in-use')) {
      return 'An account already exists for this email.';
    } else if (error.contains('user-not-found')) {
      return 'No user found with this email.';
    } else if (error.contains('wrong-password')) {
      return 'Wrong password provided.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (error.contains('user-disabled')) {
      return 'This user account has been disabled.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (error.contains('operation-not-allowed')) {
      return 'Email/password accounts are not enabled.';
    } else if (error.contains('CONFIGURATION_NOT_FOUND') ||
        error.contains('configuration-not-found')) {
      return 'Firebase Authentication is not enabled. Please enable it in Firebase Console.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}
