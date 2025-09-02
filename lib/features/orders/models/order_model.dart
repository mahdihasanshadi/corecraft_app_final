import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final double? salePrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    this.salePrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'size': size,
      'color': color,
      'quantity': quantity,
      'price': price,
      'salePrice': salePrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      size: map['size'] ?? '',
      color: map['color'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      salePrice: map['salePrice']?.toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double vat;
  final double total;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? trackingNumber;
  final Map<String, dynamic> shippingAddress;
  final String paymentMethod;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.vat,
    required this.total,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.trackingNumber,
    required this.shippingAddress,
    required this.paymentMethod,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'vat': vat,
      'total': total,
      'status': status.name,
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryDate': deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'trackingNumber': trackingNumber,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'notes': notes,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel.fromMap(data);
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0.0).toDouble(),
      vat: (map['vat'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryDate: map['deliveryDate'] != null 
          ? (map['deliveryDate'] as Timestamp).toDate() 
          : null,
      trackingNumber: map['trackingNumber'],
      shippingAddress: map['shippingAddress'] ?? {},
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
      notes: map['notes'],
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryCharge,
    double? vat,
    double? total,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? trackingNumber,
    Map<String, dynamic>? shippingAddress,
    String? paymentMethod,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      vat: vat ?? this.vat,
      total: total ?? this.total,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusIcon {
    switch (status) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.confirmed:
        return '✅';
      case OrderStatus.processing:
        return '🔄';
      case OrderStatus.shipped:
        return '🚚';
      case OrderStatus.delivered:
        return '📦';
      case OrderStatus.cancelled:
        return '❌';
    }
  }
}


