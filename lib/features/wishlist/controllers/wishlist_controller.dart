import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/firestore_service.dart';
import '../../auth/controllers/firebase_auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  final _wishlistItems = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _isProcessing = false.obs;

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading.value;
  bool get isProcessing => _isProcessing.value;

  @override
  void onInit() {
    super.onInit();
    // Load wishlist from Firebase if user is logged in
    // Add a small delay to ensure FirebaseAuthController is initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadWishlistItems();
      _setupRealtimeListener();
    });
  }

  void _setupRealtimeListener() {
    // DISABLED - Real-time listeners are causing conflicts
    // We'll use manual refresh instead
    print('Real-time listener setup skipped to prevent conflicts');
  }

  Future<void> _loadWishlistItems() async {
    try {
      _isLoading.value = true;

      // Check if FirebaseAuthController is available
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print(
          'FirebaseAuthController not registered yet, skipping wishlist load',
        );
        _wishlistItems.clear();
        return;
      }

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Load wishlist from Firestore
        final wishlistData = await FirestoreService.getUserWishlist(user.uid);

        // Validate and clean the data
        final cleanedData = wishlistData
            .map((item) => _cleanWishlistItem(item))
            .toList();
        _wishlistItems.value = cleanedData;
      } else {
        // User not logged in, clear wishlist
        _wishlistItems.clear();
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      _wishlistItems.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // Clean and validate wishlist item data
  Map<String, dynamic> _cleanWishlistItem(Map<String, dynamic> item) {
    return {
      'id': item['id']?.toString() ?? '',
      'name': item['name']?.toString() ?? 'Unknown Product',
      'price': _parseDouble(item['price']) ?? 0.0,
      'image': item['image']?.toString() ?? '',
      'images': item['images'] is List ? item['images'] : [],
      'category': item['category']?.toString() ?? 'Unknown Category',
      'brand': item['brand']?.toString() ?? '',
      'sizes': item['sizes'] is List ? item['sizes'] : [],
      'colors': item['colors'] is List ? item['colors'] : [],
      'material': item['material']?.toString() ?? '',
      'fitType': item['fitType']?.toString() ?? '',
      'careInstructions': item['careInstructions'] is List
          ? item['careInstructions']
          : [],
      'stock': _parseInt(item['stock']) ?? 0,
      'rating': _parseDouble(item['rating']) ?? 0.0,
      'reviewCount': _parseInt(item['reviewCount']) ?? 0,
      'isFeatured': _parseBool(item['isFeatured']) ?? false,
      'isNew': _parseBool(item['isNew']) ?? false,
      'isOnSale': _parseBool(item['isOnSale']) ?? false,
      'salePrice': _parseDouble(item['salePrice']),
    };
  }

  // Helper methods for safe type conversion
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true') return true;
      if (lowerValue == 'false') return false;
    }
    return null;
  }

  Future<void> addToWishlist(Map<String, dynamic> product) async {
    try {
      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        Get.snackbar(
          'Login Required',
          'Please login to add items to wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      // Check if item already exists in wishlist
      final existingIndex = _wishlistItems.indexWhere(
        (item) => item['id'] == product['id'],
      );

      if (existingIndex == -1) {
        // Clean the product data before adding
        final cleanedProduct = _cleanWishlistItem(product);

        // Add to local list FIRST
        _wishlistItems.add(cleanedProduct);
        print('Added to wishlist locally: ${cleanedProduct['name']}');

        // Then add to Firestore
        final success = await FirestoreService.addToWishlistWithProduct(
          user.uid,
          cleanedProduct,
        );
        print('Firestore addToWishlistWithProduct result: $success');
        // Force reload from Firestore to ensure UI is up to date
        await _loadWishlistItems();

        if (!success) {
          // If Firestore fails, remove from local list
          _wishlistItems.removeWhere((item) => item['id'] == product['id']);
          throw Exception('Failed to save to database');
        }

        Get.snackbar(
          'Added to Wishlist',
          '${product['name'] ?? 'Product'} has been added to your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE74C3C),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      } else {
        Get.snackbar(
          'Already in Wishlist',
          '${product['name'] ?? 'Product'} is already in your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      _isProcessing.value = true;

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        Get.snackbar(
          'Login Required',
          'Please login to manage wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      final index = _wishlistItems.indexWhere(
        (item) => item['id'] == productId,
      );
      if (index != -1) {
        final productName = _wishlistItems[index]['name'] ?? 'Product';

        // Remove from Firestore
        await FirestoreService.removeFromWishlist(user.uid, productId);
        print('Removed from Firestore: $productId');
        // Force reload from Firestore to ensure UI is up to date
        await _loadWishlistItems();

        // Remove from local list
        _wishlistItems.removeAt(index);

        Get.snackbar(
          'Removed from Wishlist',
          '$productName has been removed from your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800],
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item['id'] == productId);
  }

  Future<void> clearWishlist() async {
    try {
      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        Get.snackbar(
          'Login Required',
          'Please login to manage wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      // Clear from Firestore
      await FirestoreService.clearWishlist(user.uid);

      // Clear local list
      _wishlistItems.clear();

      Get.snackbar(
        'Wishlist Cleared',
        'All items have been removed from your wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error clearing wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to clear wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void addToCart(Map<String, dynamic> product) {
    // Use CartController to add to cart and sync with database
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
  }
}
