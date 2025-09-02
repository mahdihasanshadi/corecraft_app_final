# Firebase Setup Guide for CoreCraft E-commerce App

## Prerequisites
1. A Google account
2. Flutter development environment set up
3. Android Studio or VS Code

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `core-craft-ecommerce`
4. Choose whether to enable Google Analytics (recommended)
5. Click "Create project"

## Step 2: Add Android App to Firebase

1. In your Firebase project, click the Android icon (</>) to add an Android app
2. Enter Android package name: `com.example.core_craft_ecommerce`
3. Enter app nickname: `CoreCraft E-commerce`
4. Click "Register app"
5. Download the `google-services.json` file
6. Place the `google-services.json` file in the `android/app/` directory of your Flutter project

## Step 3: Configure Firebase Options

1. Replace the placeholder values in `lib/shared/services/firebase_options.dart` with your actual Firebase configuration:

```dart
// Replace these values with your actual Firebase project configuration
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

You can find these values in:
- Firebase Console → Project Settings → General → Your apps → Android app

## Step 4: Enable Firebase Services

### Authentication
1. In Firebase Console, go to Authentication → Sign-in method
2. Enable Email/Password authentication
3. Optionally enable Google Sign-in, Facebook, etc.

### Firestore Database
1. Go to Firestore Database → Create database
2. Choose "Start in test mode" for development
3. Select a location close to your users
4. Create the following collections:
   - `users`
   - `products`
   - `categories`
   - `orders`

### Storage
1. Go to Storage → Get started
2. Choose "Start in test mode" for development
3. Select a location

## Step 5: Set Up Firestore Security Rules

Go to Firestore Database → Rules and update with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Users can manage their own wishlist and cart
      match /wishlist/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /cart/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Anyone can read products and categories
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Only admin can write
    }
    
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if false; // Only admin can write
    }
    
    // Users can create and read their own orders
    match /orders/{orderId} {
      allow read, create: if request.auth != null && 
        (resource == null || resource.data.userId == request.auth.uid);
      allow update: if false; // Only admin can update
    }
  }
}
```

## Step 6: Add Sample Data

### Categories Collection
Add documents with fields:
- `name`: "Streetwear", "Jerseys", "Casual Shirts"
- `description`: Category description
- `image`: Category image URL

### Products Collection
Add documents with fields:
- `name`: Product name
- `price`: Product price (number)
- `originalPrice`: Original price (number, optional)
- `category`: Category name
- `image`: Product image URL
- `rating`: Product rating (number)
- `reviews`: Number of reviews (number)
- `description`: Product description
- `sizes`: Available sizes array
- `colors`: Available colors array
- `inStock`: Boolean

## Step 7: Test the Setup

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to test the app
3. Check Firebase Console for any authentication or database activity

## Troubleshooting

### Common Issues:
1. **google-services.json not found**: Make sure the file is in `android/app/`
2. **Firebase initialization failed**: Check your Firebase options configuration
3. **Permission denied**: Check Firestore security rules
4. **Authentication errors**: Ensure Email/Password auth is enabled

### Debug Commands:
```bash
flutter clean
flutter pub get
flutter run
```

## Next Steps

1. Implement user authentication UI
2. Add product management features
3. Implement cart functionality
4. Add order processing
5. Set up admin panel for product management

## Security Notes

- Never commit `google-services.json` to public repositories
- Use environment variables for sensitive data in production
- Regularly review and update Firestore security rules
- Enable Firebase App Check for additional security
