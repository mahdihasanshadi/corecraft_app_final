import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService {
  static final List<Map<String, String>> _users = [];

  // Mock Sign Up
  static Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Check if user already exists
      if (_users.any((user) => user['email'] == email)) {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'An account already exists for this email.',
        );
      }

      // Add user to mock database
      _users.add({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'uid': 'mock_${DateTime.now().millisecondsSinceEpoch}',
      });

      // Create mock user credential
      final mockUser = MockUser(
        uid: 'mock_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
      );

      return MockUserCredential(mockUser);
    } catch (e) {
      print('Mock sign up error: $e');
      return null;
    }
  }

  // Mock Sign In
  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => throw Exception('User not found'),
      );

      final mockUser = MockUser(
        uid: user['uid']!,
        email: email,
        displayName: user['name'],
      );

      return MockUserCredential(mockUser);
    } catch (e) {
      print('Mock sign in error: $e');
      return null;
    }
  }

  // Mock Sign Out
  static Future<void> signOut() async {
    // Mock implementation - just print
    print('Mock sign out');
  }

  // Mock Reset Password
  static Future<bool> resetPassword(String email) async {
    try {
      final userExists = _users.any((user) => user['email'] == email);
      if (userExists) {
        print('Mock password reset email sent to: $email');
        return true;
      }
      return false;
    } catch (e) {
      print('Mock reset password error: $e');
      return false;
    }
  }
}

// Mock User class
class MockUser extends User {
  MockUser({required String uid, required String email, String? displayName})
    : super(
        uid: uid,
        email: email,
        displayName: displayName,
        isEmailVerified: true,
        photoURL: null,
        phoneNumber: null,
        metadata: UserMetadata(
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
        ),
      );

  @override
  Future<void> updateDisplayName(String? displayName) async {
    // Mock implementation
    print('Mock update display name: $displayName');
  }
}

// Mock UserCredential class
class MockUserCredential extends UserCredential {
  MockUserCredential(User user)
    : super(user: user, additionalUserInfo: null, credential: null);
}
