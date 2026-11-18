import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quest.dart';
import '../models/quest_glyph.dart';

class QuestService {
  QuestService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _questsRef =>
      _firestore.collection('quests');

  // ==========================================
  // 1. CREATE: Tambah Quest Baru ke Firestore
  // ==========================================
  Future<String> addQuest({
    required String title,
    required String description,
    String categoryId = 'general',
    String achievementLabel = 'New Quest',
    QuestGlyph glyph = QuestGlyph.brain,
  }) async {
    final docRef = await _questsRef.add({
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'achievementLabel': achievementLabel,
      'glyph': glyph.name,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // ==========================================
  // 2. READ: Mendapatkan Daftar Quest Realtime
  // ==========================================
  Stream<List<Quest>> streamQuests() {
    return _questsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Quest.fromFirestore(doc)).toList();
    });
  }

  // Ambil quest tunggal berdasarkan ID
  Future<Quest?> getQuestById(String id) async {
    final doc = await _questsRef.doc(id).get();
    if (!doc.exists) return null;
    return Quest.fromFirestore(doc);
  }

  // ==========================================
  // 3. UPDATE: Mengubah Data atau Status Quest
  // ==========================================
  Future<void> updateQuest({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
    String? categoryId,
    String? achievementLabel,
  }) async {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (isCompleted != null) data['isCompleted'] = isCompleted;
    if (categoryId != null) data['categoryId'] = categoryId;
    if (achievementLabel != null) data['achievementLabel'] = achievementLabel;
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _questsRef.doc(id).update(data);
  }

  // Toggle status checklist (selesai / belum selesai)
  Future<void> toggleQuestCompletion(String id, bool currentStatus) async {
    await _questsRef.doc(id).update({
      'isCompleted': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================
  // 4. DELETE: Menghapus Quest
  // ==========================================
  Future<void> deleteQuest(String id) async {
    await _questsRef.doc(id).delete();
  }

  // Helper opsional: Isi data awal jika Firestore masih kosong
  Future<void> seedInitialQuests(List<Quest> initialQuests) async {
    final existing = await _questsRef.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    for (final q in initialQuests) {
      final doc = _questsRef.doc(q.id);
      batch.set(doc, q.toMap());
    }
    await batch.commit();
  }
}
