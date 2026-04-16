import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
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
}
