import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firestore_service.dart';
import '../../features/auth/models/user_profile.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Auth Methods
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
  static Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile
      await result.user?.updateDisplayName(name);

      // Save user profile to Firestore (with error handling)
      try {
        final userProfile = UserProfile.fromFirebaseUser(
          uid: result.user!.uid,
          email: email,
          name: name,
          phone: phone,
        );
        await FirestoreService.saveUserProfile(userProfile);
      } catch (firestoreError) {
        print('Firestore error (non-critical): $firestoreError');
        // Continue even if Firestore fails
      }

      // Log analytics event (with error handling)
      try {
        await _analytics.logSignUp(signUpMethod: 'email');
      } catch (analyticsError) {
        print('Analytics error (non-critical): $analyticsError');
        // Continue even if analytics fails
      }

      return result;
    } catch (e) {
      print('Sign up error: $e');
      // Provide more specific error information
      if (e.toString().contains('CONFIGURATION_NOT_FOUND')) {
        throw FirebaseAuthException(
          code: 'configuration-not-found',
          message:
              'Firebase Authentication is not enabled. Please enable it in Firebase Console.',
        );
      }
      rethrow;
    }
  }

  // Sign In
  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Log analytics event
      await _analytics.logLogin(loginMethod: 'email');

      return result;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign Out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _analytics.logEvent(name: 'user_logout');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Reset Password
  static Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      await _analytics.logEvent(name: 'password_reset_requested');
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Update Profile
  static Future<bool> updateProfile({String? name, String? phone}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Update Firebase Auth profile
      if (name != null) {
        await user.updateDisplayName(name);
      }

      // Update Firestore document
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;

      await _firestore.collection('users').doc(user.uid).update(updateData);
      await _analytics.logEvent(name: 'profile_updated');

      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Firestore Methods
  static Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Products
  static Future<QuerySnapshot?> getProducts() async {
    try {
      return await _firestore.collection('products').get();
    } catch (e) {
      print('Get products error: $e');
      return null;
    }
  }

  static Future<QuerySnapshot?> getProductsByCategory(String category) async {
    try {
      return await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
    } catch (e) {
      print('Get products by category error: $e');
      return null;
    }
  }

  // Cart
  static Future<bool> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .set({
            'productId': productId,
            'quantity': quantity,
            'addedAt': FieldValue.serverTimestamp(),
          });

      await _analytics.logAddToCart(
        currency: 'BDT',
        value: 0.0, // You can calculate this based on product price
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: 'Product',
            itemCategory: 'Clothing',
            quantity: quantity,
          ),
        ],
      );

      return true;
    } catch (e) {
      print('Add to cart error: $e');
      return false;
    }
  }

  static Future<QuerySnapshot?> getCartItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      return await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();
    } catch (e) {
      print('Get cart items error: $e');
      return null;
    }
  }

  static Future<bool> removeFromCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .delete();

      return true;
    } catch (e) {
      print('Remove from cart error: $e');
      return false;
    }
  }

  // Wishlist
  static Future<bool> addToWishlist(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId)
          .set({
            'productId': productId,
            'addedAt': FieldValue.serverTimestamp(),
          });

      await _analytics.logEvent(
        name: 'add_to_wishlist',
        parameters: {'product_id': productId},
      );

      return true;
    } catch (e) {
      print('Add to wishlist error: $e');
      return false;
    }
  }

  static Future<QuerySnapshot?> getWishlistItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      return await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .get();
    } catch (e) {
      print('Get wishlist items error: $e');
      return null;
    }
  }

  static Future<bool> removeFromWishlist(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId)
          .delete();

      return true;
    } catch (e) {
      print('Remove from wishlist error: $e');
      return false;
    }
  }

  // Orders
  static Future<bool> createOrder({
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final orderRef = await _firestore.collection('orders').add({
        'userId': user.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...orderData,
      });

      // Clear cart after successful order
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get()
          .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          });

      await _analytics.logPurchase(
        currency: 'BDT',
        value: orderData['total'] ?? 0.0,
        transactionId: orderRef.id,
      );

      return true;
    } catch (e) {
      print('Create order error: $e');
      return false;
    }
  }

  static Future<QuerySnapshot?> getUserOrders() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      return await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      print('Get user orders error: $e');
      return null;
    }
  }

  // Analytics
  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Log event error: $e');
    }
  }

  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      print('Set user ID error: $e');
    }
  }

  static Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Set user property error: $e');
    }
  }
}
