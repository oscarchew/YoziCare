import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/google_auth/google_auth_repo.dart';

class MyDataScreen extends StatefulWidget {

  const MyDataScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {

  // Map<String, >
  //
  // final data = FirebaseFirestore.instance
  //   .collection('users')
  //   .doc(FirebaseAuth.instance.currentUser!.uid)
  //   .get()

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Home page'),
    ),
    body: const Center(
        child: Text(
            'Signed in successfully!'
        )
    )
  );

  String printEFGR(num eFGR) => eFGR > 60 ? "over 60" : "$eFGR";

  num eGFR({
    required bool isMale,
    required int age,
    required int weight,
    required int cr
  }) {
    if (age > 60 || weight > 85) {
      return mdrd(isMale, age, cr);
    } else {
      return cockcroftGault(isMale, age, weight, cr);
    }
  }

  num mdrd(bool isMale, int age, int cr) {
    final c = isMale ? 1 : 0.742;
    return 186 * pow(cr, -1.154) * pow(age, -0.203) * c;
  }

  num cockcroftGault(bool isMale, int age, int weight, int cr) {
    final c = isMale ? 1 : 0.85;
    return (140 - age) * weight * c / (72 * cr);
  }

  CKDStage stageOf(num eFGR) {
    if (eFGR < 15) {
      return CKDStage.g5;
    } else if (eFGR < 30) {
      return CKDStage.g4;
    } else if (eFGR < 60) {
      return CKDStage.g3;
    } else if (eFGR < 90) {
      return CKDStage.g2;
    } else {
      return CKDStage.g1;
    }
  }
}

enum CKDStage {
  g1, g2, g3, g4, g5
}