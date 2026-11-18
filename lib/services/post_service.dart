import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/profile_post.dart';

class PostService {
  PostService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

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
    final List<String> imageUrls = [];
    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child(fileName);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }

    // Simpan data post ke Cloud Firestore
    final docRef = await _postsRef.add({
      'userId': 'current_user',
      'displayName': 'Ivander',
      'username': '@ivander',
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
    return _postsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final label = data['categoryLabel'] as String? ?? 'Explorer';
        return ProfilePost(
          id: doc.id,
          userId: data['userId'] as String? ?? '',
          displayName: data['displayName'] as String? ?? 'User',
          username: data['username'] as String? ?? '@user',
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

  // ==========================================
  // 4. DELETE: Hapus post beserta gambarnya
  // ==========================================
  Future<void> deletePost(String id) async {
    final doc = await _postsRef.doc(id).get();
    if (doc.exists) {
      final data = doc.data();
      final mediaUrls = List<String>.from(data?['mediaUrls'] ?? []);
      for (final url in mediaUrls) {
        try {
          await _storage.refFromURL(url).delete();
        } catch (_) {
          // Abaikan jika file sudah tidak ada
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
