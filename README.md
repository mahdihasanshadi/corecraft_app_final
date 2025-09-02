# Core Craft Clothing

A modern, feature-rich Flutter e-commerce application for a premium clothing brand, built with clean architecture principles and GetX state management.

## 🚀 Features

### Clothing Categories
- **Streetwear**: Trendy urban fashion including hoodies, cargo pants, and street-style clothing
- **Casual Shirts**: Comfortable everyday wear including Oxford shirts, linen shirts, and casual tops
- **Jerseys**: Athletic wear including basketball jerseys, soccer jerseys, and sports apparel

### Product Management
- **Product Catalog**: Comprehensive clothing listings with search and filtering
- **Product Details**: Rich product information with size selection, color options, and care instructions
- **Category Management**: Organized product categorization by clothing type
- **Search & Filters**: Advanced search with multiple filter options

### User Experience
- **Modern UI/UX**: Material Design 3 with smooth animations
- **Dark/Light Theme**: Theme switching with system preference detection
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Navigation**: Intuitive app navigation with transitions

### Technical Features
- **Comprehensive Logging**: Multi-level logging system with file rotation
- **State Management**: GetX for reactive state management
- **Local Storage**: Secure data persistence
- **API Integration**: Ready for backend integration
- **Error Handling**: Robust error handling and user feedback

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/                    # Core application components
│   ├── constants/          # App constants and configuration
│   ├── routes/             # Navigation and routing
│   ├── services/           # Core services (logging, etc.)
│   └── theme/              # App theming and styling
├── features/               # Feature-based modules
│   ├── auth/              # Authentication feature
│   ├── home/              # Home screen feature
│   ├── onboarding/        # Splash and onboarding
│   └── product/           # Product management feature
└── shared/                 # Shared components and services
    ├── services/           # Shared services (API, storage)
    └── widgets/            # Reusable UI components
```

### Design Patterns
- **Feature-First Architecture**: Organized by business features
- **Dependency Injection**: GetX service locator pattern
- **Repository Pattern**: Data access abstraction
- **Observer Pattern**: Reactive state management
- **Factory Pattern**: Object creation patterns

## 🛠️ Technology Stack

### Core Technologies
- **Flutter**: 3.8.1+ (Dart SDK)
- **GetX**: State management and dependency injection
- **Material Design 3**: Modern UI components

### Dependencies
```yaml
# State Management
get: ^4.6.6

# HTTP Client
dio: ^5.4.0

# Local Storage
shared_preferences: ^2.2.2
path_provider: ^2.1.1

# Image Loading
cached_network_image: ^3.3.0

# Form Validation
form_validator: ^2.1.1
```

## 📱 Screenshots

### Authentication Flow
- **Splash Screen**: Animated logo with smooth transitions
- **Login Screen**: Modern form design with social login options
- **Registration Screen**: Comprehensive signup with validation

### Main App
- **Home Screen**: Featured products and categories
- **Product List**: Grid/List view with search and filters
- **Product Detail**: Rich product information with image gallery

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/core_craft_ecommerce.git
   cd core_craft_ecommerce
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **Update app constants** in `lib/core/constants/app_constants.dart`
2. **Configure API endpoints** for your backend
3. **Set up social login** credentials
4. **Customize theme colors** in `lib/core/theme/app_theme.dart`

## 📊 Logging System

### Log Levels
- **DEBUG**: Detailed debugging information
- **INFO**: General information messages
- **WARNING**: Warning messages for potential issues
- **ERROR**: Error messages with stack traces
- **FATAL**: Critical error messages

### Features
- **File Logging**: Persistent log storage with rotation
- **Console Output**: Real-time log viewing
- **Log Management**: Automatic cleanup and size management
- **Configurable Levels**: Runtime log level adjustment

### Usage
```dart
// Basic logging
LoggerService.to.info('User logged in successfully', tag: 'Auth');
LoggerService.to.error('API call failed', tag: 'API', error: e);

// With tags for organization
LoggerService.to.debug('Processing user data', tag: 'UserService');
LoggerService.to.warning('Low memory detected', tag: 'System');
```

## 🔐 Authentication

### Features
- **Secure Storage**: Encrypted local storage for sensitive data
- **Token Management**: JWT token handling and refresh
- **Social Integration**: OAuth 2.0 for social platforms
- **Biometric Auth**: Fingerprint/Face ID support (planned)

### Implementation
```dart
// Login
final success = await authController.login(
  email: 'user@example.com',
  password: 'password123',
  rememberMe: true,
);

// Check auth status
if (authController.isAuthenticated) {
  // User is logged in
}
```

## 🛍️ Product Management

### Product Model
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> images;
  final bool inStock;
  // ... additional properties
}
```

### Features
- **Search & Filter**: Text search and category filtering
- **Sorting**: Multiple sort options (price, rating, name)
- **Pagination**: Efficient data loading for large catalogs
- **Image Management**: Multiple product images with galleries

## 🎨 Theming System

### Theme Features
- **Material Design 3**: Latest design system
- **Dark/Light Modes**: Automatic theme switching
- **Custom Colors**: Brand-specific color schemes
- **Responsive Typography**: Adaptive text sizing

### Customization
```dart
// Custom theme colors
static final ThemeData customTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
  ),
);
```

## 📱 Platform Support

### Mobile
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+

### Desktop (Planned)
- **Windows**: Windows 10+
- **macOS**: macOS 10.14+
- **Linux**: Ubuntu 18.04+

### Web (Planned)
- **Modern Browsers**: Chrome, Firefox, Safari, Edge

## 🧪 Testing

### Test Structure
```
test/
├── unit/           # Unit tests
├── widget/         # Widget tests
└── integration/    # Integration tests
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

## 📦 Building & Deployment

### Android Build
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### iOS Build
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 🔧 Development

### Code Style
- **Dart Analysis**: Strict linting rules
- **Formatting**: Automatic code formatting
- **Documentation**: Comprehensive code documentation
- **Naming Conventions**: Consistent naming patterns

### Best Practices
- **Feature Organization**: Logical feature grouping
- **State Management**: Reactive state updates
- **Error Handling**: Graceful error handling
- **Performance**: Efficient widget rebuilding

## 🤝 Contributing

### Contribution Guidelines
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

### Code Review Process
- All changes require review
- Tests must pass
- Code style compliance
- Documentation updates

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **GetX Community**: For the excellent state management solution
- **Material Design**: For the design system
- **Open Source Contributors**: For various packages and tools

## 📞 Support

### Getting Help
- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions
- **Documentation**: Check the docs folder
- **Community**: Join our community channels

### Contact
- **Email**: support@corecraft.com
- **Website**: https://corecraft.com
- **Twitter**: @CoreCraftApp

---

**Built with ❤️ by the Core Craft Team**
