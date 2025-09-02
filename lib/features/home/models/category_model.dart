import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: _getIconFromString(json['icon'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon.codePoint};
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'phone_android':
        return Icons.phone_android;
      case 'checkroom':
        return Icons.checkroom;
      case 'home':
        return Icons.home;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'book':
        return Icons.book;
      default:
        return Icons.category;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name)';
  }
}
