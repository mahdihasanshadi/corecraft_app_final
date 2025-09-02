import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user_profile.dart';
import '../../../shared/services/firestore_service.dart';

class UserProfileController extends GetxController {
  static UserProfileController get to => Get.find();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _userProfile = Rxn<UserProfile>();
  UserProfile? get userProfile => _userProfile.value;

  final _isUploadingImage = false.obs;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await loadUserProfile(user.uid);
    }
  }

  Future<void> loadUserProfile(String uid) async {
    try {
      _isLoading.value = true;
      final profile = await FirestoreService.getUserProfile(uid);
      _userProfile.value = profile;
    } catch (e) {
      print('Error loading user profile: $e');
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    List<String>? preferences,
    Map<String, dynamic>? sizes,
    String? profileImageUrl,
  }) async {
    try {
      _isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (bio != null) updates['bio'] = bio;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (gender != null) updates['gender'] = gender;
      if (address != null) updates['address'] = address;
      if (city != null) updates['city'] = city;
      if (country != null) updates['country'] = country;
      if (postalCode != null) updates['postalCode'] = postalCode;
      if (preferences != null) updates['preferences'] = preferences;
      if (sizes != null) updates['sizes'] = sizes;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

      final success = await FirestoreService.updateUserProfile(
        user.uid,
        updates,
      );

      if (success) {
        await loadUserProfile(user.uid);
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      _isUploadingImage.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final imageFile = File(pickedFile.path);
      final imageUrl = await FirestoreService.uploadProfileImage(
        user.uid,
        imageFile,
      );

      if (imageUrl != null) {
        await updateProfile(profileImageUrl: imageUrl);
        Get.snackbar('Success', 'Profile image updated');
      } else {
        Get.snackbar('Error', 'Failed to upload image');
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      Get.snackbar('Error', 'Failed to upload image');
    } finally {
      _isUploadingImage.value = false;
    }
  }

  Future<void> takeProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      _isUploadingImage.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final imageFile = File(pickedFile.path);
      final imageUrl = await FirestoreService.uploadProfileImage(
        user.uid,
        imageFile,
      );

      if (imageUrl != null) {
        await updateProfile(profileImageUrl: imageUrl);
        Get.snackbar('Success', 'Profile photo updated');
      } else {
        Get.snackbar('Error', 'Failed to upload photo');
      }
    } catch (e) {
      print('Error taking profile photo: $e');
      Get.snackbar('Error', 'Failed to take photo');
    } finally {
      _isUploadingImage.value = false;
    }
  }

  Future<void> updateLastLogin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirestoreService.updateUserProfile(user.uid, {
          'lastLoginAt': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  // Get user display name
  String get displayName {
    if (userProfile != null) {
      return userProfile!.displayName;
    }
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'User';
  }

  // Get user initials
  String get initials {
    if (userProfile != null) {
      return userProfile!.initials;
    }
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email?.split('@').first ?? 'U';
    return name[0].toUpperCase();
  }

  // Get profile image URL
  String? get profileImageUrl {
    if (userProfile?.profileImageUrl != null) {
      return userProfile!.profileImageUrl;
    }
    return FirebaseAuth.instance.currentUser?.photoURL;
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return userProfile?.isProfileComplete ?? false;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    if (userProfile == null) return 0.0;

    int completedFields = 0;
    int totalFields = 8;

    if (userProfile!.name.isNotEmpty) completedFields++;
    if (userProfile!.phone != null && userProfile!.phone!.isNotEmpty)
      completedFields++;
    if (userProfile!.bio != null && userProfile!.bio!.isNotEmpty)
      completedFields++;
    if (userProfile!.address != null && userProfile!.address!.isNotEmpty)
      completedFields++;
    if (userProfile!.city != null && userProfile!.city!.isNotEmpty)
      completedFields++;
    if (userProfile!.country != null && userProfile!.country!.isNotEmpty)
      completedFields++;
    if (userProfile!.gender != 'Not specified') completedFields++;
    if (userProfile!.profileImageUrl != null) completedFields++;

    return completedFields / totalFields;
  }
}
