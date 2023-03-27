import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/database/firestore.dart';

class FirestoreBasicFieldRepository extends FirestoreRepositoryImpl {

  final DocumentReference document;

  FirestoreBasicFieldRepository(String collectionPath)
    : document = FirebaseFirestore.instance
      .collection(collectionPath)
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Future<void> add({
    required DataType dataType,
    required Map<String, Object> json
  }) async => await document.set({
    dataType.name: json
  });

  @override
  Future<void> addMultiple({
    required List<DataType> dataTypes,
    required List<Map<String, Object>> jsons
  }) async => await document.set(
      Map.fromIterables(dataTypes, jsons)
  );

  @override
  Future<void> update({
    required DataType dataType,
    required Map<String, Object> json
  }) async => await document.set({
    dataType.name: json
  }, SetOptions(merge: true));

  @override
  Future<Map<String, dynamic>> get({
    required DataType dataType
  }) async => await document.get().then((snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return data[dataType.name] as Map<String, dynamic>;
  });

  Future<List<dynamic>> getFieldValuesOnly({
    required DataType dataType
  }) async => await get(dataType: dataType)
    .then((map) => map.values.toList());

  @override
  Future<void> deleteType({
    required DataType dataType
  }) async => await document.update({
    dataType.name: FieldValue.delete()
  });
}