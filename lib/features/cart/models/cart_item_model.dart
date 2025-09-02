import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final double price;
  final double? salePrice;
  final String image;
  final List<String> images;
  final String category;
  final String brand;
  final List<String> sizes;
  final List<String> colors;
  final String material;
  final String fitType;
  final int stock;
  final int quantity;
  final String selectedSize;
  final String selectedColor;
  final DateTime addedAt;
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.salePrice,
    required this.image,
    required this.images,
    required this.category,
    required this.brand,
    required this.sizes,
    required this.colors,
    required this.material,
    required this.fitType,
    required this.stock,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.addedAt,
    required this.updatedAt,
  });

  // Get the effective price (sale price if available, otherwise regular price)
  double get effectivePrice => salePrice ?? price;

  // Get the total price for this cart item
  double get totalPrice => effectivePrice * quantity;

  // Check if the item is on sale
  bool get isOnSale => salePrice != null && salePrice! > 0;

  // Get discount percentage
  double get discountPercentage {
    if (!isOnSale) return 0.0;
    return ((price - salePrice!) / price) * 100;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'image': image,
      'images': images,
      'category': category,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'stock': stock,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'addedAt': Timestamp.fromDate(addedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Map (from Firestore)
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      salePrice: map['salePrice']?.toDouble(),
      image: map['image'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      material: map['material'] ?? '',
      fitType: map['fitType'] ?? '',
      stock: (map['stock'] ?? 0).toInt(),
      quantity: (map['quantity'] ?? 1).toInt(),
      selectedSize: map['selectedSize'] ?? '',
      selectedColor: map['selectedColor'] ?? '',
      addedAt: map['addedAt'] is Timestamp
          ? (map['addedAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Create from Firestore document
  factory CartItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel.fromMap({'id': doc.id, ...data});
  }

  // Create a copy with updated values
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    double? salePrice,
    String? image,
    List<String>? images,
    String? category,
    String? brand,
    List<String>? sizes,
    List<String>? colors,
    String? material,
    String? fitType,
    int? stock,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      image: image ?? this.image,
      images: images ?? this.images,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      material: material ?? this.material,
      fitType: fitType ?? this.fitType,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, name: $name, quantity: $quantity, effectivePrice: $effectivePrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productId == productId &&
        other.selectedSize == selectedSize &&
        other.selectedColor == selectedColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productId.hashCode ^
        selectedSize.hashCode ^
        selectedColor.hashCode;
  }
}
