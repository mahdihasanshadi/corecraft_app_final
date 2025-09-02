import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final String? bio;
  final DateTime dateOfBirth;
  final String gender;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final List<String> preferences;
  final Map<String, dynamic> sizes;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastLoginAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.profileImageUrl,
    this.bio,
    required this.dateOfBirth,
    required this.gender,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.preferences = const [],
    this.sizes = const {},
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'preferences': preferences,
      'sizes': sizes,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }

  // Create from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      gender: data['gender'] ?? 'Not specified',
      address: data['address'],
      city: data['city'],
      country: data['country'],
      postalCode: data['postalCode'],
      preferences: List<String>.from(data['preferences'] ?? []),
      sizes: Map<String, dynamic>.from(data['sizes'] ?? {}),
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPhoneVerified: data['isPhoneVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firebase User
  factory UserProfile.fromFirebaseUser({
    required String uid,
    required String email,
    required String name,
    String? phone,
    String? profileImageUrl,
  }) {
    final now = DateTime.now();
    return UserProfile(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      profileImageUrl: profileImageUrl,
      dateOfBirth: DateTime(1990, 1, 1), // Default date
      gender: 'Not specified',
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
    );
  }

  // Copy with method for updates
  UserProfile copyWith({
    String? name,
    String? phone,
    String? profileImageUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    List<String>? preferences,
    Map<String, dynamic>? sizes,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      preferences: preferences ?? this.preferences,
      sizes: sizes ?? this.sizes,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // Get display name (fallback to email if name is empty)
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  // Get initials for avatar
  String get initials {
    if (name.isNotEmpty) {
      final words = name.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return name.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty &&
        city != null &&
        city!.isNotEmpty;
  }

  // Get full address
  String get fullAddress {
    final parts = [
      address,
      city,
      country,
      postalCode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }
}
