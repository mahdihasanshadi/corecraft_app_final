import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> images;
  final String category;
  final String brand;
  final List<String> sizes;
  final List<String> colors;
  final String material;
  final String fitType;
  final List<String> careInstructions;
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isNew;
  final bool isOnSale;
  final double? salePrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirestoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'BDT',
    required this.images,
    required this.category,
    required this.brand,
    required this.sizes,
    required this.colors,
    required this.material,
    required this.fitType,
    required this.careInstructions,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    this.isFeatured = false,
    this.isNew = false,
    this.isOnSale = false,
    this.salePrice,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'careInstructions': careInstructions,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'isOnSale': isOnSale,
      'salePrice': salePrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory FirestoreProduct.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FirestoreProduct(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'BDT',
      images: List<String>.from(data['images'] ?? []),
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      material: data['material'] ?? '',
      fitType: data['fitType'] ?? '',
      careInstructions: List<String>.from(data['careInstructions'] ?? []),
      stock: data['stock'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      isNew: data['isNew'] ?? false,
      isOnSale: data['isOnSale'] ?? false,
      salePrice: data['salePrice']?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'image': images.isNotEmpty ? images.first : '',
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'careInstructions': careInstructions,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'isOnSale': isOnSale,
      'salePrice': salePrice,
    };
  }

  // Convert to old Product model for compatibility
  Map<String, dynamic> toProductMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'image': images.isNotEmpty ? images.first : '',
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'careInstructions': careInstructions,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'isOnSale': isOnSale,
      'salePrice': salePrice,
    };
  }

  // Get display price (sale price if on sale, otherwise regular price)
  double get displayPrice => isOnSale && salePrice != null ? salePrice! : price;

  // Check if product is in stock
  bool get inStock => stock > 0;

  // Get formatted price
  String get formattedPrice => '৳${displayPrice.toStringAsFixed(0)}';

  // Get formatted original price
  String? get formattedOriginalPrice =>
      isOnSale ? '৳${price.toStringAsFixed(0)}' : null;

  // Get discount percentage
  double? get discountPercentage {
    if (isOnSale && salePrice != null) {
      return ((price - salePrice!) / price * 100);
    }
    return null;
  }

  // Get main image
  String get mainImage => images.isNotEmpty ? images.first : '';
}
