import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdsc/model/food_analysis_content/theme.dart';
import 'package:gdsc/model/food_analysis_content/health_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/basic_repo.dart';
import '../../../infrastructure/google_auth/google_auth_repo.dart';
import 'package:intl/intl.dart';

@RoutePage()
class MyDataScreen extends StatefulWidget {

  const MyDataScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {

  final authorizationRepository = GoogleAuthenticationRepository();
  final firestoreRepository = FirestoreBasicFieldRepository('users');
  final colorstheme = Colors.lightGreen;
  Map<String, dynamic> healthData = {};

  @override
  Widget build(BuildContext context) {
    getHealthData();

    String fdatetime = DateFormat('yyyy-MMM-dd').format(healthData["birthday"].toDate());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Personal Information',
            style: TextStyle(fontSize: 27, color: colorstheme),
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(4),
                  // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColors.colorTint400), borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 3.8,
                        child: Container(
                          // margin: EdgeInsets.only(top: 5. w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: AppColors.colorTint400),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ' Personal Information',
                                            style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                          ),
                                          // FaIcon( FontAwesomeIcons.user, color: Colors.lightGreen),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          birthday(birthday: fdatetime),
                                          weight(weight: healthData["weight"]),
                                          FaIcon( healthData["gender"] == "Female" ? FontAwesomeIcons.venus : FontAwesomeIcons.mars, color: healthData["gender"] == "Female" ? Colors.red : Colors.blue),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColors.colorTint400), borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      // Family History
                      AspectRatio(
                        aspectRatio: 3.2,
                        child: Container(
                          margin: EdgeInsets.only(top: 10. w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: AppColors.colorTint400),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ' Family History',
                                            style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                          ),
                                          FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          symptom(healthData: healthData["proteinuria"],symtom_name: 'Polycystic KD'),
                                          symptom(healthData: healthData["igAN"],symtom_name: 'IgAN'),
                                          symptom(healthData: healthData["liddle"],symtom_name: 'Liddle'),
                                          symptom(healthData: healthData["others"],symtom_name: 'Others'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Personal History
                      AspectRatio(
                        aspectRatio: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 10. w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: AppColors.colorTint400),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ' Personal History',
                                            style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                          ),
                                          FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          symptom(healthData: healthData["diabetes"],symtom_name: 'Diabetes'),
                                          symptom(healthData: healthData["gout"],symtom_name: 'Metabolic Arthritis, Gout'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          symptom(healthData: healthData["hypertension"],symtom_name: 'Hypertension'),
                                          symptom(healthData: healthData["hyperuricemia"],symtom_name: 'Hyperuricemia'),
                                          symptom(healthData: healthData["proteinuria"],symtom_name: 'Proteinuria'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          symptom(healthData: healthData["renalColic"],symtom_name: 'Renal colic'),
                                          symptom(healthData: healthData["frequentUrination"],symtom_name: 'Frequent urination'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Family History
                      AspectRatio(
                        aspectRatio: 3.2,
                        child: Container(
                          margin: EdgeInsets.only(top: 10. w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: AppColors.colorTint400),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ' Personal Habits',
                                            style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                          ),
                                          FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                        ],
                                      ),
                                      // TODO: 這邊引數要改一下
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          symptom(healthData: healthData["painkillerAbuse"],symtom_name: 'Painkiller'),
                                          symptom(healthData: healthData["drinking"],symtom_name: 'Drinking'),
                                          symptom(healthData: healthData["antibioticsAbuse"],symtom_name: 'Antibiotics'),
                                          symptom(healthData: healthData["smoking"],symtom_name: 'Smoking'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.all(13),
                  child:
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightGreen
                      ),
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out')
                  ),
                )

            ),
            // const SizedBox(height: 20),

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
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen
            ),
            child: const Text('Yes'),
            onPressed: () {
              authorizationRepository.signOut();
              context.router.replaceNamed('/login');
            }
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen
            ),
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
          backgroundColor: Colors.lightGreen[200],
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(content, style: const TextStyle(color: Colors.white)),
          actions: actions
      )
  );
}