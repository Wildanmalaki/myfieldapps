import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Service level rendah untuk akses Firebase.
class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Helper untuk mengambil collection Firestore.
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  /// Upload file lalu ambil download URL dari Firebase Storage.
  Future<String> _uploadAndResolveUrl({
    required Reference ref,
    required Uint8List bytes,
    required SettableMetadata metadata,
  }) async {
    await ref.putData(bytes, metadata);

    FirebaseException? lastError;

    for (var attempt = 0; attempt < 8; attempt++) {
      try {
        return await ref.getDownloadURL();
      } on FirebaseException catch (e) {
        lastError = e;
        if (e.code != 'object-not-found' || attempt == 7) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 350 * (attempt + 1)));
      }
    }

    throw lastError ??
        FirebaseException(
          plugin: 'firebase_storage',
          code: 'unknown',
          message: 'Tidak berhasil mendapatkan URL file upload.',
        );
  }

  /// Menentukan bucket kandidat jika bucket utama gagal dipakai.
  List<String> _candidateBuckets() {
    final options = Firebase.app().options;
    final configuredBucket = options.storageBucket?.trim() ?? '';
    final projectId = options.projectId.trim();
    final candidates = <String>[
      if (configuredBucket.endsWith('.firebasestorage.app'))
        configuredBucket.replaceFirst(
          '.firebasestorage.app',
          '.appspot.com',
        ),
      if (configuredBucket.isNotEmpty) configuredBucket,
      if (configuredBucket.startsWith('gs://')) configuredBucket.substring(5),
      if (configuredBucket.endsWith('.appspot.com'))
        configuredBucket.replaceFirst(
          '.appspot.com',
          '.firebasestorage.app',
        ),
      if (projectId.isNotEmpty) '$projectId.appspot.com',
      if (projectId.isNotEmpty) '$projectId.firebasestorage.app',
    ];

    return candidates
        .map((bucket) => bucket.trim().replaceFirst('gs://', ''))
        .where((bucket) => bucket.isNotEmpty)
        .toSet()
        .toList();
  }

  /// Membuat document baru di collection tertentu.
  Future<int> createDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
    int? id,
  }) async {
    final documentId = id ?? DateTime.now().millisecondsSinceEpoch;
    await collection(collectionPath).doc(documentId.toString()).set({
      ...data,
      'id': documentId,
    });
    return documentId;
  }

  /// Mengambil seluruh document dari collection.
  Future<List<Map<String, dynamic>>> getDocuments(
    String collectionPath, {
    String? orderBy,
    bool descending = false,
  }) async {
    Query<Map<String, dynamic>> query = collection(collectionPath);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Mengambil document berdasarkan beberapa field filter.
  Future<List<Map<String, dynamic>>> getDocumentsByFields({
    required String collectionPath,
    required Map<String, Object> filters,
  }) async {
    Query<Map<String, dynamic>> query = collection(collectionPath);

    for (final entry in filters.entries) {
      query = query.where(entry.key, isEqualTo: entry.value);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Mengambil satu document berdasarkan satu field.
  Future<Map<String, dynamic>?> getDocumentByField({
    required String collectionPath,
    required String field,
    required Object value,
  }) async {
    final snapshot = await collection(collectionPath)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first.data();
  }

  /// Mengambil satu document berdasarkan kombinasi beberapa field.
  Future<Map<String, dynamic>?> getDocumentByFields({
    required String collectionPath,
    required Map<String, Object> filters,
  }) async {
    Query<Map<String, dynamic>> query = collection(collectionPath);

    for (final entry in filters.entries) {
      query = query.where(entry.key, isEqualTo: entry.value);
    }

    final snapshot = await query.limit(1).get();
    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first.data();
  }

  /// Mengambil document berdasarkan id.
  Future<Map<String, dynamic>?> getDocumentById({
    required String collectionPath,
    required int id,
  }) async {
    final snapshot = await collection(collectionPath).doc(id.toString()).get();

    return snapshot.data();
  }

  /// Menghapus document berdasarkan id.
  Future<void> deleteDocument({
    required String collectionPath,
    required int id,
  }) async {
    await collection(collectionPath).doc(id.toString()).delete();
  }

  /// Memperbarui document dengan merge.
  Future<void> updateDocument({
    required String collectionPath,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await collection(collectionPath)
        .doc(id.toString())
        .set(data, SetOptions(merge: true));
  }

  /// Upload foto profile user ke Firebase Storage.
  Future<String> uploadProfileImage({
    required int userId,
    required File file,
  }) async {
    final extension = file.path.split('.').last.toLowerCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final objectPath = 'profile_images/user_${userId}_$timestamp.$extension';
    final contentType = switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'application/octet-stream',
    };
    final metadata = SettableMetadata(contentType: contentType);
    final bytes = await file.readAsBytes();

    try {
      final ref = FirebaseStorage.instance.ref().child(objectPath);
      return await _uploadAndResolveUrl(
        ref: ref,
        bytes: bytes,
        metadata: metadata,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'bucket-not-found' && e.code != 'object-not-found') {
        rethrow;
      }
    }

    FirebaseException? lastBucketError;

    for (final bucket in _candidateBuckets()) {
      final storage = FirebaseStorage.instanceFor(bucket: 'gs://$bucket');
      final ref = storage.ref().child(objectPath);

      try {
        return await _uploadAndResolveUrl(
          ref: ref,
          bytes: bytes,
          metadata: metadata,
        );
      } on FirebaseException catch (e) {
        if (e.code == 'bucket-not-found' || e.code == 'object-not-found') {
          lastBucketError = e;
          continue;
        }
        rethrow;
      }
    }

    if (lastBucketError != null) {
      throw lastBucketError;
    }

    throw FirebaseException(
      plugin: 'firebase_storage',
      code: 'bucket-not-found',
      message: 'Tidak ada bucket Firebase Storage yang valid untuk dipakai.',
    );
  }
}
