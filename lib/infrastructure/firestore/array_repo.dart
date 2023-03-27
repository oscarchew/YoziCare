import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/database/firestore.dart';

class FirestoreArrayFieldRepository extends FirestoreRepositoryImpl {

  final DocumentReference document;

  FirestoreArrayFieldRepository(String collectionPath)
      : document = FirebaseFirestore.instance
      .collection(collectionPath)
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Future<void> add({
    required DataType dataType,
    Map<String, Object> json = const {}
  }) async => await document.set({
    dataType.name: []
  });

  @override
  Future<void> addMultiple({
    required List<DataType> dataTypes,
    required List<Map<String, Object>> jsons
  }) async => await document.set({
    for (var dataType in dataTypes) dataType.name: []
  });

  @override
  Future<void> deleteType({
    required DataType dataType
  }) async => await document.update({
    dataType.name: FieldValue.delete()
  });

  @override
  Future<List<dynamic>> get({
    required DataType dataType
  }) async => await document.get().then((snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return data[dataType.name] as List<dynamic>;
  });

  @override
  Future<void> update({
    required DataType dataType,
    Map<String, Object> json = const {}
  }) async => await document.update({
    dataType.name: await get(dataType: dataType)
      ..addAll(json.values.toList())
  });
}