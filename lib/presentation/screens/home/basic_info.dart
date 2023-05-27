import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/model/food_analysis_content/health_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localization/localization.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.lightGreen,),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'basic-info-title'.i18n(),
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
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
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColors.colorTint400), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              // Family History
              AspectRatio(
                aspectRatio: 2.6,
                child: Container(
                  // margin: EdgeInsets.only(top: 10. w),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.lightGreen,),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'family-history-title'.i18n(),
                                    // style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["proteinuria"],symtom_name: 'polycystic-abbrev'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["igAN"],symtom_name: 'igan-abbrev'.i18n()),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["liddle"],symtom_name: 'liddle'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["others"],symtom_name: 'others'.i18n()),
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
                  // margin: EdgeInsets.only(top: 10. w),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.lightGreen,),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'personal-history-title'.i18n(),
                                    // style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["diabetes"],symtom_name: 'diabetes'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["proteinuria"],symtom_name: 'proteinuria'.i18n()),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["hypertension"],symtom_name: 'hypertension'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["hyperuricemia"],symtom_name: 'hyperuricemia'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["gout"],symtom_name: 'gout-abbrev'.i18n()),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["renalColic"],symtom_name: 'renal-colic'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["frequentUrination"],symtom_name: 'frequent-urination'.i18n()),
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
                aspectRatio: 2.6,
                child: Container(
                  // margin: EdgeInsets.only(top: 10. w),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.lightGreen,),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'personal-habits-title'.i18n(),
                                    // style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 16. sp),
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  FaIcon( FontAwesomeIcons.userDoctor, color: Colors.lightGreen),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["painkillerAbuse"],symtom_name: 'painkiller-abuse'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["drinking"],symtom_name: 'drinking'.i18n()),
                                ],
                              ),
                              Row(
                                children: [
                                  symptom(healthData: healthData["antibioticsAbuse"],symtom_name: 'antibiotics-abuse'.i18n()),
                                  SizedBox(width: 10,),
                                  symptom(healthData: healthData["smoking"],symtom_name: 'smoking'.i18n()),
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
        ,
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen
            ),
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: Text('sign-out'.i18n())
        )
      ],
    );
  }

  void getHealthData() async {
    final newHealthData = await firestoreRepository.get(
        dataType: DataType.healthData
    );
    setState(() => healthData = newHealthData);
  }

  void _signOut() async => await createDialog(
      title: 'sign-out-title'.i18n(),
      content: 'sign-out-warning'.i18n(),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen
            ),
            child: Text('yes'.i18n()),
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
            child: Text('no'.i18n()),
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