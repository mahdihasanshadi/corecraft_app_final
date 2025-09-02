class AppConstants {
  // App Info
  static const String appName = 'Core Craft Clothing';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Premium Clothing Brand';

  // API Constants
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String nameRequired = 'Name is required';
  static const String phoneRequired = 'Phone number is required';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logout successful';
  static const String profileUpdated = 'Profile updated successfully';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unknownError = 'An unknown error occurred';
  static const String invalidCredentials = 'Invalid email or password';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Sizes
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double largeRadius = 12.0;

  // Limits
  static const int maxProductTitleLength = 100;
  static const int maxProductDescriptionLength = 500;
  static const int maxReviewLength = 1000;
}
