import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class DatabaseDebug {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Print comprehensive database status
  static Future<void> printDatabaseStatus() async {
    try {
      print('\n🔍 DATABASE STATUS CHECK');
      print('=' * 50);

      // Check Firebase connection
      print('📡 Firebase Connection: ${_firestore.app.name}');

      // Check products
      final productsSnapshot = await _firestore.collection('products').get();
      print('📦 Products: ${productsSnapshot.docs.length}');

      if (productsSnapshot.docs.isNotEmpty) {
        final firstProduct = productsSnapshot.docs.first.data();
        print(
          '   First Product: ${firstProduct['name']} - ৳${firstProduct['price']}',
        );
      }

      // Check categories
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();
      print('📂 Categories: ${categoriesSnapshot.docs.length}');

      if (categoriesSnapshot.docs.isNotEmpty) {
        for (var doc in categoriesSnapshot.docs) {
          final data = doc.data();
          print('   - ${data['name']}');
        }
      }

      // Check products by category
      final streetwearProducts = await _firestore
          .collection('products')
          .where('category', isEqualTo: 'Streetwear')
          .get();
      print('👕 Streetwear Products: ${streetwearProducts.docs.length}');

      final jerseyProducts = await _firestore
          .collection('products')
          .where('category', isEqualTo: 'Jerseys')
          .get();
      print('⚽ Jersey Products: ${jerseyProducts.docs.length}');

      final casualShirtProducts = await _firestore
          .collection('products')
          .where('category', isEqualTo: 'Casual Shirts')
          .get();
      print('👔 Casual Shirt Products: ${casualShirtProducts.docs.length}');

      print('=' * 50);
      print('✅ Database status check completed\n');
    } catch (e) {
      print('❌ Error checking database status: $e');
    }
  }

  /// Test FirestoreService methods
  static Future<void> testFirestoreService() async {
    try {
      print('\n🧪 TESTING FIRESTORE SERVICE');
      print('=' * 50);

      // Test getProducts
      final products = await FirestoreService.getProducts();
      print('📦 FirestoreService.getProducts(): ${products.length} products');

      // Test getCategories
      final categories = await FirestoreService.getCategories();
      print(
        '📂 FirestoreService.getCategories(): ${categories.length} categories',
      );

      // Test getFeaturedProducts
      final featuredProducts = await FirestoreService.getFeaturedProducts();
      print(
        '⭐ FirestoreService.getFeaturedProducts(): ${featuredProducts.length} featured products',
      );

      // Test getProductsByCategory
      final streetwearProducts = await FirestoreService.getProductsByCategory(
        'Streetwear',
      );
      print('👕 Streetwear products: ${streetwearProducts.length}');

      print('=' * 50);
      print('✅ FirestoreService tests completed\n');
    } catch (e) {
      print('❌ Error testing FirestoreService: $e');
    }
  }

  /// Print sample product data
  static Future<void> printSampleProductData() async {
    try {
      print('\n📋 SAMPLE PRODUCT DATA');
      print('=' * 50);

      final products = await FirestoreService.getProducts();
      if (products.isNotEmpty) {
        final product = products.first;
        print('Product ID: ${product.id}');
        print('Name: ${product.name}');
        print('Price: ${product.formattedPrice}');
        print('Category: ${product.category}');
        print('Brand: ${product.brand}');
        print('Stock: ${product.stock}');
        print('Rating: ${product.rating}');
        print('Images: ${product.images.length}');
        print('Sizes: ${product.sizes.join(', ')}');
        print('Colors: ${product.colors.join(', ')}');
      } else {
        print('❌ No products found in database');
      }

      print('=' * 50);
    } catch (e) {
      print('❌ Error printing sample product data: $e');
    }
  }
}


