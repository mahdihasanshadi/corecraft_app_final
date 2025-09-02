import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/firestore_service.dart';
import '../../auth/controllers/firebase_auth_controller.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final _cartItems = <Map<String, dynamic>>[].obs;
  final _isLoading = false.obs;
  final _error = RxnString();
  final _isProcessing = false.obs;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isProcessing => _isProcessing.value;

  // Computed properties
  int get itemCount =>
      _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 1));
  double get subtotal => _cartItems.fold(0.0, (sum, item) {
    final price =
        (item['salePrice'] as double? ?? item['price'] as double? ?? 0.0);
    final quantity = (item['quantity'] as int? ?? 1);
    return sum + (price * quantity);
  });
  double get deliveryCharge => 150.0; // Fixed delivery charge in BDT
  double get vat => subtotal * 0.05; // 5% VAT
  double get total => subtotal + deliveryCharge + vat;

  @override
  void onInit() {
    super.onInit();
    // Load cart from Firebase if user is logged in
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadCartItems();
      _setupRealtimeListener();
    });
  }

  void _setupRealtimeListener() {
    // DISABLED - Real-time listeners are causing conflicts
    // We'll use manual refresh instead
    print('Real-time listener setup skipped to prevent conflicts');
  }

  Future<void> _loadCartItems() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      // Check if FirebaseAuthController is available
      if (!Get.isRegistered<FirebaseAuthController>()) {
        print('FirebaseAuthController not registered yet, skipping cart load');
        _cartItems.clear();
        return;
      }

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Load cart from Firestore
        final cartData = await FirestoreService.getCartItems(user.uid);

        // Validate and clean the data
        final cleanedData = cartData
            .map((item) => _cleanCartItem(item))
            .toList();
        _cartItems.value = cleanedData;

        print('Loaded ${cartData.length} cart items for user ${user.uid}');
      } else {
        // User not logged in, clear cart
        _cartItems.clear();
      }
    } catch (e) {
      print('Error loading cart: $e');
      _error.value = e.toString();
      _cartItems.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // Clean and validate cart item data
  Map<String, dynamic> _cleanCartItem(Map<String, dynamic> item) {
    return {
      'id': item['id']?.toString() ?? '',
      'productId': item['productId']?.toString() ?? '',
      'name': item['product']?['name']?.toString() ?? 'Unknown Product',
      'price': _parseDouble(item['product']?['price']) ?? 0.0,
      'salePrice': _parseDouble(item['product']?['salePrice']),
      'image': item['product']?['images']?[0]?.toString() ?? '',
      'images': (item['product']?['images'] is List)
          ? (item['product']?['images'] as List)
          : [],
      'category':
          item['product']?['category']?.toString() ?? 'Unknown Category',
      'brand': item['product']?['brand']?.toString() ?? '',
      'sizes': (item['product']?['sizes'] is List)
          ? (item['product']?['sizes'] as List)
          : [],
      'colors': (item['product']?['colors'] is List)
          ? (item['product']?['colors'] as List)
          : [],
      'material': item['product']?['material']?.toString() ?? '',
      'fitType': item['product']?['fitType']?.toString() ?? '',
      'stock': _parseInt(item['product']?['stock']) ?? 0,
      'quantity': _parseInt(item['quantity']) ?? 1,
      'selectedSize': item['selectedSize']?.toString() ?? '',
      'selectedColor': item['selectedColor']?.toString() ?? '',
      'addedAt': item['addedAt'],
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

  Future<void> addToCart(
    Map<String, dynamic> product, {
    String? selectedSize,
    String? selectedColor,
    int quantity = 1,
  }) async {
    try {
      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user == null) {
        Get.snackbar(
          'Login Required',
          'Please login to add items to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      final productId = product['id']?.toString() ?? '';

      // Check if item already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) =>
            item['productId'] == productId &&
            item['selectedSize'] == selectedSize &&
            item['selectedColor'] == selectedColor,
      );

      if (existingIndex != -1) {
        // Update quantity of existing item
        await updateQuantity(
          existingIndex,
          _cartItems[existingIndex]['quantity'] + quantity,
        );
      } else {
        // Add to local list FIRST
        final cleanedProduct = _cleanCartItem({
          'id': productId,
          'productId': productId,
          'product': product,
          'quantity': quantity,
          'selectedSize': selectedSize ?? '',
          'selectedColor': selectedColor ?? '',
          'addedAt': DateTime.now().toIso8601String(),
        });

        _cartItems.add(cleanedProduct);
        print('Added to cart locally: ${cleanedProduct['name']}');
        print('Cart items count: ${_cartItems.length}');

        // Then add to Firestore
        print('Attempting to save to Firestore...');
        final success = await FirestoreService.addToCart(
          user.uid,
          productId,
          quantity,
        );
        print('Firestore save result: $success');

        if (!success) {
          // If Firestore fails, remove from local list
          _cartItems.removeWhere((item) => item['productId'] == productId);
          print('Removed from local cart due to Firestore failure');
          throw Exception('Failed to save to database');
        }

        // Reload cart from Firestore to ensure UI is up to date
        await _loadCartItems();

        Get.snackbar(
          'Added to Cart',
          '${product['name'] ?? 'Product'} has been added to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    try {
      _isProcessing.value = true;

      if (newQuantity <= 0) {
        await removeFromCart(index);
        return;
      }

      final item = _cartItems[index];
      final productId = item['productId'];

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Update in Firestore
        await FirestoreService.updateCartQuantity(
          user.uid,
          productId,
          newQuantity,
        );
      }

      // Update local list
      _cartItems[index]['quantity'] = newQuantity;
      _cartItems.refresh();
    } catch (e) {
      print('Error updating quantity: $e');
      Get.snackbar(
        'Error',
        'Failed to update quantity',
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

  Future<void> removeFromCart(int index) async {
    try {
      _isProcessing.value = true;

      final item = _cartItems[index];
      final productId = item['productId'];

      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Remove from Firestore
        await FirestoreService.removeFromCart(user.uid, productId);
      }

      // Remove from local list
      _cartItems.removeAt(index);
      // Force reload from Firestore to ensure UI is up to date
      await _loadCartItems();

      Get.snackbar(
        'Removed from Cart',
        '${item['name'] ?? 'Product'} has been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  Future<void> clearCart() async {
    try {
      // Get current user
      final authController = Get.find<FirebaseAuthController>();
      final user = authController.currentUser;

      if (user != null) {
        // Clear from Firestore
        await FirestoreService.clearCart(user.uid);
      }

      // Clear local list
      _cartItems.clear();

      Get.snackbar(
        'Cart Cleared',
        'All items have been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error clearing cart: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cart',
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

  bool isInCart(String productId, {String? size, String? color}) {
    return _cartItems.any(
      (item) =>
          item['productId'] == productId &&
          item['selectedSize'] == (size ?? '') &&
          item['selectedColor'] == (color ?? ''),
    );
  }

  int getCartQuantity(String productId, {String? size, String? color}) {
    final item = _cartItems.firstWhereOrNull(
      (item) =>
          item['productId'] == productId &&
          item['selectedSize'] == (size ?? '') &&
          item['selectedColor'] == (color ?? ''),
    );
    return item?['quantity'] ?? 0;
  }

  // Refresh cart data from database
  Future<void> refreshCart() async {
    await _loadCartItems();
  }

  // Get cart items for checkout
  List<Map<String, dynamic>> getCartItemsForCheckout() {
    return _cartItems
        .map(
          (item) => {
            'id': item['productId'],
            'name': item['name'],
            'price': item['price'],
            'salePrice': item['salePrice'],
            'quantity': item['quantity'],
            'selectedSize': item['selectedSize'],
            'selectedColor': item['selectedColor'],
            'image': item['image'],
          },
        )
        .toList();
  }
}
