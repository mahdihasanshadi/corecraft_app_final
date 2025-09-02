import 'package:get/get.dart';
import '../../../shared/services/storage_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  final _currentUser = Rxn<User>();
  User? get currentUser => _currentUser.value;

  final _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storageService.getToken();
      if (token != null) {
        // TODO: Validate token with backend
        _isAuthenticated.value = true;
        await _loadUserProfile();
        // User authenticated from stored token
      }
    } catch (e) {
      // Failed to check auth status
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      // TODO: Load user profile from backend or local storage
      final userData = _storageService.getUserData();
      if (userData != null) {
        _currentUser.value = User.fromJson(
          Map<String, dynamic>.from(userData as Map),
        );
      }
    } catch (e) {
      // Failed to load user profile
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _isLoading.value = true;
      // Attempting login for: $email

      // TODO: Implement actual API call to backend
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // For demo purposes, accept any email/password combination
      if (email.isNotEmpty && password.isNotEmpty) {
        final user = User(
          id: '1',
          email: email,
          name: email.split('@')[0],
          avatar: null,
        );

        _currentUser.value = user;
        _isAuthenticated.value = true;

        // Save user data
        await _storageService.setUserData(user.toJson().toString());
        await _storageService.setToken(
          'demo_token_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (rememberMe) {
          await _storageService.setBool('remember_me', true);
        }

        // Login successful for: $email
        return true;
      } else {
        // Login failed: Invalid credentials
        return false;
      }
    } catch (e) {
      // Login error occurred
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Logging out user: ${currentUser?.email}

      _isLoading.value = true;

      // TODO: Call logout API if needed
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear local data
      await _storageService.clear();

      // Reset state
      _isAuthenticated.value = false;
      _currentUser.value = null;

      // Logout successful
    } catch (e) {
      // Logout error occurred
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? confirmPassword,
  }) async {
    try {
      _isLoading.value = true;
      // Attempting registration for: $email

      // TODO: Implement actual registration API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // For demo purposes, accept any valid registration
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        if (confirmPassword != null && password != confirmPassword) {
          // Registration failed: Passwords do not match
          return;
        }

        final user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: name,
          avatar: null,
        );

        _currentUser.value = user;
        _isAuthenticated.value = true;

        // Save user data
        await _storageService.setUserData(user.toJson().toString());
        await _storageService.setToken(
          'demo_token_${DateTime.now().millisecondsSinceEpoch}',
        );

        // Registration successful for: $email
      } else {
        // Registration failed: Invalid input data
      }
    } catch (e) {
      // Registration error occurred
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      // Forgot password requested for: $email

      // TODO: Implement forgot password API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Forgot password email sent to: $email
    } catch (e) {
      // Forgot password error occurred
    }
  }

  Future<void> updateProfile({String? name, String? avatar}) async {
    try {
      if (currentUser == null) return;

      // Updating profile for user: ${currentUser!.email}

      final updatedUser = currentUser!.copyWith(
        name: name ?? currentUser!.name,
        avatar: avatar ?? currentUser!.avatar,
      );

      _currentUser.value = updatedUser;

      // Save updated user data
      await _storageService.setUserData(updatedUser.toJson().toString());

      // Profile updated successfully
    } catch (e) {
      // Profile update error occurred
    }
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  User copyWith({String? id, String? email, String? name, String? avatar}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatar': avatar};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ avatar.hashCode;
  }
}
