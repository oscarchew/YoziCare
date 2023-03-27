import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gdsc/presentation/screens/home/food_analysis_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'result_page.dart';

class ImagePickerPage extends StatefulWidget {
  final String cloudRunUrl;

  ImagePickerPage(this.cloudRunUrl);

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _image;


  Future getImage(bool isCamera) async {
      bool isFood;
      final pickedFile = await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

      // 上傳圖片到 Cloud Run
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image!.path),
      });

      // URL決定是哪個服務
      if (widget.cloudRunUrl == 'https://foodanalysis-z5zukxh7ha-df.a.run.app'){
        isFood = true; // 食物成分分析
      }
      else{
        isFood = false; // 食物營養成分標籤
      }


    try {
      final response = await Dio().post(
        widget.cloudRunUrl,
        data: formData,
      );

      // 跳轉到結果頁面 command for testing
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddFoodBody(isFood, _image!, response.data)), // 修改跳轉頁面
      );
      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text('Select Image Source', style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Take a picture', style: Theme.of(context).textTheme.bodyText1),
              onPressed: () {
                getImage(true);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('Select from gallery', style: Theme.of(context).textTheme.bodyText1),
              onPressed: () {
                getImage(false);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
