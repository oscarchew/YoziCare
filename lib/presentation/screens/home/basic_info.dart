import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/basic_repo.dart';

class MyDataScreen extends StatefulWidget {

  const MyDataScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {

  final firestoreRepository = FirestoreBasicFieldRepository('users');

  Map<String, dynamic> healthData = {};

  @override
  Widget build(BuildContext context) {
    getHealthData();
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(json.encode(healthData, toEncodable: _toDateTime)),
            const SizedBox(height: 20)
          ],
        )
    );
  }

  void getHealthData() async {
    final newHealthData = await firestoreRepository.get(
        dataType: DataType.healthData
    );
    setState(() => healthData = newHealthData);
  }

  String _toDateTime(timeStamp) =>
      (timeStamp as Timestamp).toDate().toString();
}