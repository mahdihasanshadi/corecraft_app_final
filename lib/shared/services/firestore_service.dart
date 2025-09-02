import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../../features/product/models/firestore_product.dart';
import '../../features/auth/models/user_profile.dart';
import '../../features/orders/models/order_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== PRODUCTS ====================

  // Get all products
  static Future<List<FirestoreProduct>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => FirestoreProduct.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Get products by category
  static Future<List<FirestoreProduct>> getProductsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => FirestoreProduct.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  // Get featured products
  static Future<List<FirestoreProduct>> getFeaturedProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();
      return snapshot.docs
          .map((doc) => FirestoreProduct.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting featured products: $e');
      return [];
    }
  }

  // Get product by ID
  static Future<FirestoreProduct?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return FirestoreProduct.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  // Search products
  static Future<List<FirestoreProduct>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      return snapshot.docs
          .map((doc) => FirestoreProduct.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // ==================== USER PROFILES ====================

  // Get user profile
  static Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('userProfiles').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Create or update user profile
  static Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('userProfiles')
          .doc(profile.uid)
          .set(profile.toFirestore());
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore.collection('userProfiles').doc(uid).update(updates);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Upload profile image
  static Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // ==================== CART ====================

  // Add to cart
  static Future<bool> addToCart(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      // First get the product details
      final product = await getProductById(productId);
      if (product == null) {
        print('Product not found: $productId');
        return false;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .set({
            'productId': productId,
            'quantity': quantity,
            'product': product.toMap(), // Store full product data
            'addedAt': Timestamp.fromDate(DateTime.now()),
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Update cart item quantity
  static Future<bool> updateCartQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      if (quantity <= 0) {
        return await removeFromCart(userId, productId);
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .update({
            'quantity': quantity,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
      return true;
    } catch (e) {
      print('Error updating cart quantity: $e');
      throw Exception('Failed to update cart quantity: $e');
    }
  }

  // Listen to cart changes in real-time
  static Stream<List<Map<String, dynamic>>> listenToCart(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> cartItems = [];

          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              final product = await getProductById(data['productId']);
              if (product != null) {
                cartItems.add({
                  'id': doc.id,
                  'productId': data['productId'],
                  'product': product.toMap(),
                  'quantity': data['quantity'],
                  'addedAt': data['addedAt'],
                  'updatedAt': data['updatedAt'],
                });
              }
            } catch (e) {
              print('Error processing cart item: $e');
            }
          }

          return cartItems;
        });
  }

  // Get cart items
  static Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      List<Map<String, dynamic>> cartItems = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final product = await getProductById(data['productId']);
        if (product != null) {
          cartItems.add({
            'id': doc.id,
            'product': product,
            'quantity': data['quantity'],
            'addedAt': data['addedAt'],
          });
        }
      }
      return cartItems;
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  // Remove from cart
  static Future<bool> removeFromCart(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear cart
  static Future<bool> clearCart(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // ==================== WISHLIST ====================

  // Add to wishlist
  static Future<bool> addToWishlist(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .set({
            'productId': productId,
            'addedAt': Timestamp.fromDate(DateTime.now()),
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      throw Exception('Failed to add item to wishlist: $e');
    }
  }

  // Listen to wishlist changes in real-time
  static Stream<List<Map<String, dynamic>>> listenToWishlist(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> wishlistItems = [];

          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              if (data['productData'] != null) {
                // Use the stored product data directly
                final productData = data['productData'] as Map<String, dynamic>;
                wishlistItems.add(productData);
              } else if (data['productId'] != null) {
                // Fallback: fetch product by ID
                final product = await getProductById(data['productId']);
                if (product != null) {
                  wishlistItems.add(product.toMap());
                }
              }
            } catch (e) {
              print('Error processing wishlist item: $e');
            }
          }

          return wishlistItems;
        });
  }

  // Get wishlist items
  static Future<List<FirestoreProduct>> getWishlistItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      List<FirestoreProduct> wishlistItems = [];
      for (var doc in snapshot.docs) {
        final product = await getProductById(doc.data()['productId']);
        if (product != null) {
          wishlistItems.add(product);
        }
      }
      return wishlistItems;
    } catch (e) {
      print('Error getting wishlist items: $e');
      return [];
    }
  }

  // Remove from wishlist
  static Future<bool> removeFromWishlist(
    String userId,
    String productId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .delete();
      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  // Check if product is in wishlist
  static Future<bool> isInWishlist(String userId, String productId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }

  // Get user wishlist as Map<String, dynamic> (for compatibility)
  static Future<List<Map<String, dynamic>>> getUserWishlist(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      List<Map<String, dynamic>> wishlistItems = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['productData'] != null) {
          // Use the stored product data directly
          final productData = data['productData'] as Map<String, dynamic>;
          wishlistItems.add(productData);
        } else if (data['productId'] != null) {
          // Fallback: fetch product by ID
          final product = await getProductById(data['productId']);
          if (product != null) {
            wishlistItems.add(product.toMap());
          }
        }
      }
      return wishlistItems;
    } catch (e) {
      print('Error getting user wishlist: $e');
      return [];
    }
  }

  // Add to wishlist with product data
  static Future<bool> addToWishlistWithProduct(
    String userId,
    Map<String, dynamic> product,
  ) async {
    try {
      final productId = product['id'] ?? '';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .set({
            'productId': productId,
            'productData': product,
            'addedAt': Timestamp.fromDate(DateTime.now()),
          });
      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  // Clear wishlist
  static Future<bool> clearWishlist(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print('Error clearing wishlist: $e');
      return false;
    }
  }

  // ==================== ORDERS ====================

  // Create order
  static Future<String?> createOrder(
    String userId,
    Map<String, dynamic> orderData,
  ) async {
    try {
      final docRef = await _firestore.collection('orders').add({
        'userId': userId,
        'status': 'pending',
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        ...orderData,
      });
      return docRef.id;
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  // Listen to user orders in real-time
  static Stream<List<Map<String, dynamic>>> listenToUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
          // Sort by createdAt in descending order locally
          orders.sort((a, b) {
            final aTime = a['createdAt'] as Timestamp?;
            final bTime = b['createdAt'] as Timestamp?;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          return orders;
        });
  }

  // Get user orders
  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
      // Sort by createdAt in descending order locally
      orders.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
      return orders;
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  // ==================== CATEGORIES ====================

  // Get categories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // ==================== DATA SEEDING ====================

  // Seed initial data
  static Future<void> seedInitialData() async {
    try {
      // Check if data already exists
      final productsSnapshot = await _firestore
          .collection('products')
          .limit(1)
          .get();
      if (productsSnapshot.docs.isNotEmpty) {
        print('Data already exists, skipping seed');
        return;
      }

      print('Seeding initial data...');

      // Seed categories
      await _seedCategories();

      // Seed products
      await _seedProducts();

      print('Initial data seeded successfully!');
    } catch (e) {
      print('Error seeding initial data: $e');
    }
  }

  // Force re-seed data (clears existing and adds new)
  static Future<void> forceReseedData() async {
    try {
      print('🌱 Force re-seeding data...');

      // Test Firestore connection first
      await _testFirestoreConnection();

      // Clear existing data
      await _clearExistingData();

      // Seed categories
      await _seedCategories();

      // Seed products
      await _seedProducts();

      // Verify data was seeded
      await _verifySeededData();

      print('✅ Data force re-seeded successfully!');
    } catch (e) {
      print('❌ Error force re-seeding data: $e');
      rethrow;
    }
  }

  // Test Firestore connection
  static Future<void> _testFirestoreConnection() async {
    try {
      await _firestore.collection('_test').doc('_test').set({'test': true});
      await _firestore.collection('_test').doc('_test').delete();
      print('✅ Firestore connection test successful');
    } catch (e) {
      print('❌ Firestore connection test failed: $e');
      throw Exception('Failed to connect to Firestore: $e');
    }
  }

  // Verify seeded data
  static Future<void> _verifySeededData() async {
    try {
      final productsCount = await _firestore
          .collection('products')
          .get()
          .then((snapshot) => snapshot.docs.length);
      final categoriesCount = await _firestore
          .collection('categories')
          .get()
          .then((snapshot) => snapshot.docs.length);

      print('📊 Seeded data verification:');
      print('   Products: $productsCount');
      print('   Categories: $categoriesCount');

      if (productsCount < 30) {
        throw Exception(
          'Expected at least 30 products, but found $productsCount',
        );
      }

      if (categoriesCount < 3) {
        throw Exception(
          'Expected at least 3 categories, but found $categoriesCount',
        );
      }

      print('✅ Data verification successful');
    } catch (e) {
      print('❌ Data verification failed: $e');
      rethrow;
    }
  }

  // Clear existing data
  static Future<void> _clearExistingData() async {
    try {
      // Clear products
      final productsSnapshot = await _firestore.collection('products').get();
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear categories
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();
      for (var doc in categoriesSnapshot.docs) {
        await doc.reference.delete();
      }

      print('Existing data cleared');
    } catch (e) {
      print('Error clearing existing data: $e');
    }
  }

  static Future<void> _seedCategories() async {
    final categories = [
      {
        'name': 'Streetwear',
        'description': 'Urban and trendy street fashion',
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop',
        'isActive': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Jerseys',
        'description': 'Sports and athletic wear',
        'image':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        'isActive': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Casual Shirts',
        'description': 'Comfortable everyday shirts',
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=300&fit=crop',
        'isActive': true,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
    ];

    for (var category in categories) {
      await _firestore.collection('categories').add(category);
    }
  }

  static Future<void> _seedProducts() async {
    final products = [
      // ==================== STREETWEAR PRODUCTS ====================
      {
        'name': 'Urban Hoodie Black',
        'description':
            'Premium quality black hoodie perfect for street style. Features comfortable fit and modern design.',
        'price': 2500.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Black', 'White', 'Gray'],
        'material': '100% Cotton',
        'fitType': 'Regular Fit',
        'careInstructions': [
          'Machine wash cold',
          'Do not bleach',
          'Tumble dry low',
        ],
        'stock': 50,
        'rating': 4.5,
        'reviewCount': 120,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Street Style T-Shirt',
        'description':
            'Comfortable street style t-shirt with modern design and oversized fit.',
        'price': 1200.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Black', 'Red'],
        'material': '100% Cotton',
        'fitType': 'Oversized',
        'careInstructions': ['Machine wash cold', 'Do not bleach'],
        'stock': 75,
        'rating': 4.3,
        'reviewCount': 89,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1000.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Cargo Streetwear Pants',
        'description':
            'Stylish cargo pants with multiple pockets and comfortable fit for urban lifestyle.',
        'price': 2200.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1506629905607-1b1b1b1b1b1b?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['28x30', '30x30', '32x32', '34x32', '36x32'],
        'colors': ['Black', 'Khaki', 'Olive', 'Gray'],
        'material': 'Cotton Twill',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 35,
        'rating': 4.6,
        'reviewCount': 67,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Oversized Denim Jacket',
        'description':
            'Trendy oversized denim jacket perfect for layering and street style.',
        'price': 3200.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Blue', 'Black', 'Light Blue'],
        'material': '100% Denim',
        'fitType': 'Oversized',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 25,
        'rating': 4.8,
        'reviewCount': 45,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 2800.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Graphic Streetwear Hoodie',
        'description':
            'Bold graphic hoodie with unique street art design and comfortable fit.',
        'price': 2800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Black', 'White', 'Red', 'Navy'],
        'material': 'Cotton/Polyester Blend',
        'fitType': 'Oversized',
        'careInstructions': [
          'Machine wash cold',
          'Do not bleach',
          'Tumble dry low',
        ],
        'stock': 40,
        'rating': 4.4,
        'reviewCount': 78,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },

      // ==================== JERSEY PRODUCTS ====================
      {
        'name': 'Football Jersey Blue',
        'description':
            'Professional quality football jersey for sports enthusiasts with moisture-wicking technology.',
        'price': 1800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Blue', 'White', 'Red'],
        'material': 'Polyester Blend',
        'fitType': 'Athletic Fit',
        'careInstructions': ['Machine wash cold', 'Do not iron on print'],
        'stock': 40,
        'rating': 4.7,
        'reviewCount': 156,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Basketball Jersey Red',
        'description':
            'High-performance basketball jersey with breathable mesh fabric and athletic cut.',
        'price': 2000.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Red', 'Blue', 'Black', 'White'],
        'material': 'Polyester with Dri-FIT technology',
        'fitType': 'Athletic Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 55,
        'rating': 4.6,
        'reviewCount': 89,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1700.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Soccer Team Jersey',
        'description':
            'Authentic soccer jersey with team-inspired design and lightweight fabric.',
        'price': 1600.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['XS', 'S', 'M', 'L', 'XL'],
        'colors': ['Green', 'Yellow', 'Blue', 'Red'],
        'material': 'Polyester Mesh',
        'fitType': 'Slim Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 60,
        'rating': 4.3,
        'reviewCount': 145,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Cricket Jersey White',
        'description':
            'Professional cricket jersey with moisture-wicking technology and comfortable fit.',
        'price': 1900.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['White', 'Blue', 'Green'],
        'material': 'Polyester Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Do not bleach'],
        'stock': 30,
        'rating': 4.5,
        'reviewCount': 67,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1600.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Tennis Jersey',
        'description':
            'Lightweight tennis jersey with UV protection and breathable fabric.',
        'price': 1400.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['White', 'Navy', 'Red'],
        'material': 'Polyester with UV Protection',
        'fitType': 'Slim Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 45,
        'rating': 4.2,
        'reviewCount': 34,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },

      // ==================== CASUAL SHIRTS ====================
      {
        'name': 'Classic Button Down',
        'description':
            'Versatile button-down shirt perfect for casual and semi-formal occasions.',
        'price': 1500.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['White', 'Blue', 'Gray'],
        'material': 'Cotton Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Iron on medium heat'],
        'stock': 60,
        'rating': 4.4,
        'reviewCount': 98,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Linen Summer Shirt',
        'description':
            'Breathable linen shirt perfect for warm weather with relaxed fit.',
        'price': 1800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Beige', 'Light Green', 'Cream', 'Light Blue'],
        'material': '100% Linen',
        'fitType': 'Relaxed Fit',
        'careInstructions': ['Hand wash cold', 'Air dry'],
        'stock': 35,
        'rating': 4.6,
        'reviewCount': 56,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Oxford Cotton Shirt',
        'description':
            'Classic Oxford cotton shirt with timeless style and comfortable fit.',
        'price': 1600.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Light Blue', 'Pink', 'Light Gray'],
        'material': '100% Cotton Oxford',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 70,
        'rating': 4.5,
        'reviewCount': 112,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1300.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Flannel Checkered Shirt',
        'description':
            'Warm and comfortable flannel shirt with classic checkered pattern.',
        'price': 1700.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Red/Black', 'Blue/White', 'Green/Black'],
        'material': 'Cotton Flannel',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 40,
        'rating': 4.3,
        'reviewCount': 78,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Polo Shirt Classic',
        'description':
            'Classic polo shirt with comfortable fit and timeless style.',
        'price': 1200.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Navy', 'Black', 'Red'],
        'material': 'Cotton Pique',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 85,
        'rating': 4.4,
        'reviewCount': 134,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1000.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Chambray Work Shirt',
        'description':
            'Durable chambray work shirt with comfortable fit and professional look.',
        'price': 1400.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Light Blue', 'Gray', 'White'],
        'material': 'Cotton Chambray',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Iron on medium heat'],
        'stock': 50,
        'rating': 4.2,
        'reviewCount': 67,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },

      // ==================== ADDITIONAL STREETWEAR PRODUCTS ====================
      {
        'name': 'Vintage Denim Jacket',
        'description':
            'Classic vintage-style denim jacket with distressed details and comfortable fit.',
        'price': 2800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Blue', 'Black', 'Light Blue'],
        'material': '100% Denim',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 30,
        'rating': 4.6,
        'reviewCount': 89,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Streetwear Track Pants',
        'description':
            'Comfortable track pants with modern street style design and elastic waistband.',
        'price': 1800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1506629905607-1b1b1b1b1b1b?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Black', 'Gray', 'Navy'],
        'material': 'Cotton/Polyester Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 45,
        'rating': 4.3,
        'reviewCount': 67,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1500.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Oversized Streetwear T-Shirt',
        'description':
            'Trendy oversized t-shirt with bold graphics and comfortable street style fit.',
        'price': 1100.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Black', 'Red', 'Yellow'],
        'material': '100% Cotton',
        'fitType': 'Oversized',
        'careInstructions': ['Machine wash cold', 'Do not bleach'],
        'stock': 60,
        'rating': 4.4,
        'reviewCount': 95,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Streetwear Bomber Jacket',
        'description':
            'Stylish bomber jacket with modern streetwear aesthetic and comfortable fit.',
        'price': 3200.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Black', 'Navy', 'Olive'],
        'material': 'Polyester/Nylon Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 25,
        'rating': 4.7,
        'reviewCount': 78,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Streetwear Sweatpants',
        'description':
            'Comfortable sweatpants with modern street style and relaxed fit.',
        'price': 1600.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1506629905607-1b1b1b1b1b1b?w=400&h=500&fit=crop',
        ],
        'category': 'Streetwear',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Black', 'Gray', 'Navy', 'White'],
        'material': 'Cotton/Polyester Blend',
        'fitType': 'Relaxed Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 55,
        'rating': 4.2,
        'reviewCount': 112,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1300.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },

      // ==================== ADDITIONAL JERSEY PRODUCTS ====================
      {
        'name': 'Basketball Jersey White',
        'description':
            'Classic white basketball jersey with team-inspired design and breathable fabric.',
        'price': 1900.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Black', 'Blue'],
        'material': 'Polyester with Dri-FIT technology',
        'fitType': 'Athletic Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 40,
        'rating': 4.5,
        'reviewCount': 89,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Football Jersey Green',
        'description':
            'Professional football jersey in vibrant green with moisture-wicking technology.',
        'price': 1700.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Green', 'White', 'Black'],
        'material': 'Polyester Blend',
        'fitType': 'Athletic Fit',
        'careInstructions': ['Machine wash cold', 'Do not iron on print'],
        'stock': 35,
        'rating': 4.4,
        'reviewCount': 67,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1400.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Volleyball Jersey',
        'description':
            'Lightweight volleyball jersey with breathable mesh fabric and comfortable fit.',
        'price': 1500.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['XS', 'S', 'M', 'L', 'XL'],
        'colors': ['Orange', 'Blue', 'Red', 'Yellow'],
        'material': 'Polyester Mesh',
        'fitType': 'Slim Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 50,
        'rating': 4.3,
        'reviewCount': 45,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Hockey Jersey',
        'description':
            'Durable hockey jersey with reinforced stitching and moisture-wicking fabric.',
        'price': 2100.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Red', 'Blue', 'Black', 'White'],
        'material': 'Polyester with reinforced stitching',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 30,
        'rating': 4.6,
        'reviewCount': 56,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Baseball Jersey',
        'description':
            'Classic baseball jersey with button-up front and comfortable athletic fit.',
        'price': 1800.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=500&fit=crop',
        ],
        'category': 'Jerseys',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Navy', 'White', 'Red', 'Gray'],
        'material': 'Cotton/Polyester Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 40,
        'rating': 4.4,
        'reviewCount': 78,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': true,
        'salePrice': 1500.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },

      // ==================== ADDITIONAL CASUAL SHIRTS ====================
      {
        'name': 'Classic White Dress Shirt',
        'description':
            'Professional white dress shirt perfect for formal occasions and business wear.',
        'price': 1600.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['White', 'Light Blue', 'Pink'],
        'material': 'Cotton Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Iron on medium heat'],
        'stock': 70,
        'rating': 4.5,
        'reviewCount': 134,
        'isFeatured': true,
        'isNew': false,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Casual Plaid Shirt',
        'description':
            'Comfortable plaid shirt with classic pattern and relaxed fit for everyday wear.',
        'price': 1400.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Red/Black', 'Blue/White', 'Green/Black', 'Brown/Beige'],
        'material': 'Cotton Flannel',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 45,
        'rating': 4.3,
        'reviewCount': 89,
        'isFeatured': false,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Long Sleeve Henley Shirt',
        'description':
            'Comfortable long sleeve henley shirt with button placket and modern fit.',
        'price': 1300.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Navy', 'Gray', 'Black', 'White'],
        'material': 'Cotton Jersey',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 60,
        'rating': 4.4,
        'reviewCount': 112,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1100.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Casual Denim Shirt',
        'description':
            'Stylish denim shirt with classic blue wash and comfortable fit.',
        'price': 1700.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL'],
        'colors': ['Light Blue', 'Dark Blue', 'Black'],
        'material': '100% Denim',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Air dry'],
        'stock': 35,
        'rating': 4.6,
        'reviewCount': 78,
        'isFeatured': true,
        'isNew': true,
        'isOnSale': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
      {
        'name': 'Casual Striped Shirt',
        'description':
            'Classic striped shirt with timeless pattern and comfortable everyday fit.',
        'price': 1500.0,
        'currency': 'BDT',
        'images': [
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&h=500&fit=crop',
        ],
        'category': 'Casual Shirts',
        'brand': 'CORECRAFT',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
        'colors': ['Blue/White', 'Red/White', 'Navy/White'],
        'material': 'Cotton Blend',
        'fitType': 'Regular Fit',
        'careInstructions': ['Machine wash cold', 'Tumble dry low'],
        'stock': 55,
        'rating': 4.3,
        'reviewCount': 95,
        'isFeatured': false,
        'isNew': false,
        'isOnSale': true,
        'salePrice': 1200.0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    ];

    for (var product in products) {
      await _firestore.collection('products').add(product);
    }
  }

  // ==================== ORDER METHODS ====================

  /// Create a new order
  static Future<void> createOrderModel(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
      print('Order created successfully: ${order.id}');
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  /// Get all orders for a user
  static Future<List<OrderModel>> getUserOrderModels(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  /// Update order status
  static Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      print('Order status updated: $orderId -> ${status.name}');
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  /// Get order by ID
  static Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();

      if (doc.exists) {
        return OrderModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }
}
