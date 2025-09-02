class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String category;
  final String? brand;
  final String? sku;
  final int weight;
  final String dimensions;
  final List<String> images;
  final bool inStock;
  // Clothing-specific fields
  final List<String> sizes;
  final List<String> colors;
  final String material;
  final String fitType;
  final String careInstructions;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.brand,
    this.sku,
    required this.weight,
    required this.dimensions,
    required this.images,
    required this.inStock,
    required this.sizes,
    required this.colors,
    required this.material,
    required this.fitType,
    required this.careInstructions,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? category,
    String? brand,
    String? sku,
    int? weight,
    String? dimensions,
    List<String>? images,
    bool? inStock,
    List<String>? sizes,
    List<String>? colors,
    String? material,
    String? fitType,
    String? careInstructions,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      images: images ?? this.images,
      inStock: inStock ?? this.inStock,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      material: material ?? this.material,
      fitType: fitType ?? this.fitType,
      careInstructions: careInstructions ?? this.careInstructions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions,
      'images': images,
      'inStock': inStock,
      'sizes': sizes,
      'colors': colors,
      'material': material,
      'fitType': fitType,
      'careInstructions': careInstructions,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      category: json['category'] as String,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      weight: json['weight'] as int,
      dimensions: json['dimensions'] as String,
      images: List<String>.from(json['images'] as List),
      inStock: json['inStock'] as bool,
      sizes: List<String>.from(json['sizes'] as List),
      colors: List<String>.from(json['colors'] as List),
      material: json['material'] as String,
      fitType: json['fitType'] as String,
      careInstructions: json['careInstructions'] as String,
    );
  }

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  double? get discountPercentage {
    if (!isOnSale) return null;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    return '\$${originalPrice!.toStringAsFixed(2)}';
  }

  String get formattedWeight => '${weight}g';

  String get mainImage => images.isNotEmpty ? images.first : '';

  List<String> get additionalImages =>
      images.length > 1 ? images.skip(1).toList() : [];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.originalPrice == originalPrice &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        other.category == category &&
        other.brand == brand &&
        other.sku == sku &&
        other.weight == weight &&
        other.dimensions == dimensions &&
        other.images.length == images.length &&
        other.inStock == inStock &&
        other.sizes.length == sizes.length &&
        other.colors.length == colors.length &&
        other.material == material &&
        other.fitType == fitType &&
        other.careInstructions == careInstructions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        originalPrice.hashCode ^
        rating.hashCode ^
        reviewCount.hashCode ^
        category.hashCode ^
        brand.hashCode ^
        sku.hashCode ^
        weight.hashCode ^
        dimensions.hashCode ^
        images.hashCode ^
        inStock.hashCode ^
        sizes.hashCode ^
        colors.hashCode ^
        material.hashCode ^
        fitType.hashCode ^
        careInstructions.hashCode;
  }
}
