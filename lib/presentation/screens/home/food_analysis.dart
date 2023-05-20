import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/presentation/screens/home/food_analysis_screen.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class FoodAnalysisScreen extends StatefulWidget {

  const FoodAnalysisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {

  final cloudRunUrl = 'https://foodanalysis-z5zukxh7ha-df.a.run.app';
  File? _image;

  @override
  Widget build(BuildContext context) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightGreen,
              minimumSize: Size(200, 50)
          ),
          onPressed: () => getImage(true),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take photo')
      ),
      const SizedBox(height: 30),
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightGreen,
              minimumSize: Size(200, 50)
          ),
          onPressed: () => getImage(false),
          icon: const Icon(Icons.perm_media),
          label: const Text('Select from gallery')
      )
    ],
  ));

  Future getImage(bool isCamera) async {
    final pickedFile = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));

      // Upload image to Cloud Run
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image!.path),
      });

      try {
        final response = await Dio().post(
          cloudRunUrl,
          data: formData,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFoodBody(true, _image!, response.data))
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}

