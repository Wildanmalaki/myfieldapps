import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

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
      if (configuredBucket.startsWith('gs://'))
        configuredBucket.substring(5),
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

  Future<void> deleteDocument({
    required String collectionPath,
    required int id,
  }) async {
    await collection(collectionPath).doc(id.toString()).delete();
  }

  Future<void> updateDocument({
    required String collectionPath,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await collection(collectionPath)
        .doc(id.toString())
        .set(data, SetOptions(merge: true));
  }

  Future<String> uploadProfileImage({
    required int userId,
    required File file,
  }) async {
    final extension = file.path.split('.').last.toLowerCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final objectPath = 'profile_images/user_${userId}_$timestamp.$extension';

    FirebaseException? lastBucketError;

    for (final bucket in _candidateBuckets()) {
      final storage = FirebaseStorage.instanceFor(bucket: 'gs://$bucket');
      final ref = storage.ref().child(objectPath);

      try {
        final snapshot = await ref.putFile(
          file,
          SettableMetadata(contentType: 'image/$extension'),
        );
        final uploadedRef = snapshot.ref;

        for (var attempt = 0; attempt < 3; attempt++) {
          try {
            await uploadedRef.getMetadata();
            return await uploadedRef.getDownloadURL();
          } on FirebaseException catch (e) {
            if (e.code != 'object-not-found' || attempt == 2) {
              rethrow;
            }
            await Future<void>.delayed(const Duration(milliseconds: 400));
          }
        }
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
