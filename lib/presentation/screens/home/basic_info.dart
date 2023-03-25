import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/basic_repo.dart';
import '../../../infrastructure/google_auth/google_auth_repo.dart';

class MyDataScreen extends StatefulWidget {

  const MyDataScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {

  final authorizationRepository = GoogleAuthenticationRepository();
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue[200]
                ),
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign out')
            )
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

  void _signOut() async => await createDialog(
      title: 'Signing Out',
      content: 'Do you really want to sign out?',
      actions: [
        ElevatedButton(
            child: const Text('Yes'),
            onPressed: () {
              authorizationRepository.signOut();
              context.router.replaceNamed('/login');
            }
        ),
        ElevatedButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context)
        ),
      ]
  );

  Future<void> createDialog({
    required String title,
    required String content,
    required List<Widget> actions
  }) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
      )
  );
}