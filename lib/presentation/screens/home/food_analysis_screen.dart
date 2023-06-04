import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import '../../../model/food_analysis_content/appbar.dart';
import '../../../model/food_analysis_content/calorie-statistics.dart';
import '../../../model/food_analysis_content/change-amount.dart';
import '../../../model/food_analysis_content/food-image.dart';
import '../../../model/food_analysis_content/food_categories.dart';

class AddFoodBody extends StatelessWidget {
  final bool isFood;
  final File image;
  var response;
  // var test_respone = ["food1 positive" ,"food2 negative", "food3 positive", "food4 positive", "food5 negative"];


  AddFoodBody(this.isFood, this.image, this.response);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    print("/////////////////");
    print(this.isFood);
    print("/////////////////");
    if(this.isFood){
      if(this.response['result'] == null){
        this.response['result'] = [];
      }
    }
    else{
      print("####################");
      for (var key in this.response['result'].keys) {
        if (this.response['result'][key] is List) {
          if (this.response['result'][key][1] == 'mg')  {
            this.response['result'][key][0] = this.response['result'][key][0] / 1000;
          }
          this.response['result'][key] = this.response['result'][key][0];
        }
      }
      for (var key in ['Total Carb.', 'Sodium', 'Saturated Fat', 'Protein'])  {
        if (this.response['result'][key] == null) {
          this.response['result'][key] = 0.0;
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: isFood ? Text('food-analysis-result-title'.i18n()): const Text("Nutrition extraction"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.alphaBlend(Colors.green.withOpacity(0.1), Colors.white),
      body: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 15. w),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // AddFoodScreenAppBar(),
            FoodImage(this.image),
            this.isFood ?
            FoodCategories(this.response['result']) // True: 執行食物分析
            :
            CalorieStatistics(
                this.response['result']['Total Carb.'],
                this.response['result']['Sodium'],
                this.response['result']['Saturated Fat'],
                this.response['result']['Protein']),
            // CalorieStatistics(1500,80,5,15), // False: 執行營養素標籤分析
            // CalorieStatistics(this.response['result']),
            // ChangeAmount()
          ],
        ),
      ),
    );
  }


}
