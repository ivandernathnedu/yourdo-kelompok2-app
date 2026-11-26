import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import 'auth_service.dart';

class PostService {
  PostService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestoreOverride = firestore,
        _storageOverride = storage;

  final FirebaseFirestore? _firestoreOverride;
  final FirebaseStorage? _storageOverride;

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;
  FirebaseStorage get _storage =>
      _storageOverride ?? FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _firestore.collection('posts');

  static IconData _getCategoryIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('media') || lower.contains('entertainment') || lower.contains('movie')) {
      return Icons.movie_rounded;
    } else if (lower.contains('learn') || lower.contains('discovery') || lower.contains('book')) {
      return Icons.auto_stories_rounded;
    } else if (lower.contains('health') || lower.contains('fit') || lower.contains('body')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('art') || lower.contains('creative') || lower.contains('design')) {
      return Icons.palette_rounded;
    } else if (lower.contains('outdoor') || lower.contains('adventure') || lower.contains('hike')) {
      return Icons.terrain_rounded;
    } else if (lower.contains('social') || lower.contains('people')) {
      return Icons.people_rounded;
    } else if (lower.contains('food') || lower.contains('dining') || lower.contains('lifestyle')) {
      return Icons.restaurant_rounded;
    }
    return Icons.explore_rounded;
  }

  // ==========================================
  // 1. CREATE: Upload gambar + Simpan post baru
  // ==========================================
  Future<String> createPost({
    required String title,
    required String description,
    required String categoryLabel,
    required Color categoryColor,
    required IconData categoryIcon,
    List<File> imageFiles = const [],
  }) async {
    // Upload gambar ke Firebase Storage dan kumpulkan URL-nya
    // Fallback ke Base64 Data URI jika bucket Storage belum aktif (mis. paket Spark)
    final List<String> imageUrls = [];
    int totalBase64Bytes = 0;
    const int maxBase64Bytes = 800000;

    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child(fileName);
      try {
        final snapshot = await ref.putFile(file);
        final url = await snapshot.ref.getDownloadURL();
        imageUrls.add(url);
      } catch (_) {
        final bytes = await file.readAsBytes();
        final dataUri = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        if (totalBase64Bytes + dataUri.length <= maxBase64Bytes) {
          imageUrls.add(dataUri);
          totalBase64Bytes += dataUri.length;
        } else {
          imageUrls.add(file.path);
        }
      }
    }

    // Simpan data post ke Cloud Firestore
    final currentUser = AuthService().currentUser;
    final currentProfile = AuthService.profileNotifier.value;
    final userId = (currentUser != null && currentUser.id.isNotEmpty)
        ? currentUser.id
        : currentProfile.id;
    if (userId.isEmpty) {
      throw StateError('User harus login sebelum membuat post.');
    }

    final docRef = await _postsRef.add({
      'userId': userId,
      'displayName': currentProfile.displayName,
      'username': currentProfile.username,
      'photoUrl': currentProfile.photoUrl,
      'categoryLabel': categoryLabel,
      'categoryColor': categoryColor.toARGB32(),
      'categoryIconCodePoint': categoryIcon.codePoint,
      'activityTitle': title,
      'caption': description,
      'mediaUrls': imageUrls,
      'likes': 0,
      'comments': 0,
      'shares': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // ==========================================
  // 2. READ: Stream daftar post realtime
  // ==========================================
  Stream<List<ProfilePost>> streamPosts() {
    try {
      return _postsRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        final currentUser = AuthService().currentUser;
        final currentProfile = AuthService.profileNotifier.value;
        final currentUserId = (currentUser != null && currentUser.id.isNotEmpty)
            ? currentUser.id
            : currentProfile.id;

        if (currentUserId.isEmpty) {
          return const <ProfilePost>[];
        }

        return snapshot.docs.where((doc) {
          final rawUserId = doc.data()['userId'] as String? ?? '';
          return rawUserId == currentUserId;
        }).map((doc) {
          final data = doc.data();
          final label = data['categoryLabel'] as String? ?? 'Explorer';
          final rawUserId = data['userId'] as String? ?? '';

          return ProfilePost(
            id: doc.id,
            userId: rawUserId,
            displayName: AuthService.customDisplayName != null
                ? currentProfile.displayName
                : (data['displayName'] as String? ??
                    currentProfile.displayName),
            username: currentProfile.username,
            photoUrl: currentProfile.photoUrl ?? data['photoUrl'] as String?,
            categoryLabel: label,
            categoryColor: Color(data['categoryColor'] as int? ?? 0xFF1F5EFF),
            categoryIcon: _getCategoryIcon(label),
            activityTitle: data['activityTitle'] as String? ?? '',
            date: _formatDate(data['createdAt'] as Timestamp?),
            caption: data['caption'] as String? ?? '',
            mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
            stats: [
              PostStat(
                value: data['likes'] as int? ?? 0,
                icon: Icons.favorite_border_rounded,
              ),
              PostStat(
                value: data['comments'] as int? ?? 0,
                icon: Icons.chat_bubble_outline_rounded,
              ),
              PostStat(
                value: data['shares'] as int? ?? 0,
                icon: Icons.share_outlined,
              ),
            ],
          );
        }).toList();
      });
    } catch (_) {
      return Stream.value(const []);
    }
  }

  // ==========================================
  // 3. UPDATE: Ubah caption atau title post
  // ==========================================
  Future<void> updatePost({
    required String id,
    String? title,
    String? caption,
  }) async {
    final Map<String, dynamic> data = {};
    if (title != null) data['activityTitle'] = title;
    if (caption != null) data['caption'] = caption;
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _postsRef.doc(id).update(data);
  }

  Future<void> updateCurrentUserPostsProfile({
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final currentUser = AuthService().currentUser;
      final currentProfile = AuthService.profileNotifier.value;
      final userId = (currentUser != null && currentUser.id.isNotEmpty)
          ? currentUser.id
          : currentProfile.id;
      if (userId.isEmpty) return;

      final snapshot =
          await _postsRef.where('userId', isEqualTo: userId).get();
      for (final doc in snapshot.docs) {
        final Map<String, dynamic> updates = {
          'displayName': displayName,
          'username': currentProfile.username,
        };
        if (photoUrl != null) {
          updates['photoUrl'] = photoUrl;
        }
        await doc.reference.update(updates);
      }
    } catch (_) {
      // Abaikan jika Firebase belum terinisialisasi atau gagal memperbarui post
    }
  }

  // ==========================================
  // 4. DELETE: Hapus post beserta gambarnya
  // ==========================================
  Future<void> deletePost(String id) async {
    final doc = await _postsRef.doc(id).get();
    if (doc.exists) {
      final data = doc.data();
      final mediaUrls = List<String>.from(data?['mediaUrls'] ?? []);
      for (final url in mediaUrls) {
        if (url.startsWith('http://') ||
            url.startsWith('https://') ||
            url.startsWith('gs://')) {
          try {
            await _storage.refFromURL(url).delete();
          } catch (_) {
            // Abaikan jika file sudah tidak ada
          }
        }
      }
    }
    await _postsRef.doc(id).delete();
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Baru saja';
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
