enum DataType {
  healthData, eGFR, hydration, urination
}

abstract class FirestoreRepositoryImpl {

  Future<void> add({
    required DataType dataType,
    required Map<String, Object> json
  });

  Future<void> addMultiple({
    required List<DataType> dataTypes,
    required List<Map<String, Object>> jsons
  });

  Future<void> update({
    required DataType dataType,
    required Map<String, Object> json
  });

  Future<dynamic> get({
    required DataType dataType
  });

  Future<void> deleteType({
    required DataType dataType
  });
}