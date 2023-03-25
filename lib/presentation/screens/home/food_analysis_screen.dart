import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if(this.response['result']['Calories from Fat'] == null){
      this.response['result']['Calories from Fat'] = 0.0;
    }
    if(this.response['result']['Carbohydrate'] == null){
      this.response['result']['Carbohydrate'] = 0.0;
    }
    if(this.response['result']['Saturated Fat'] == null){
      this.response['result']['Saturated Fat'] = 0.0;
    }
    if(this.response['result']['Protein'] == null){
      this.response['result']['Protein'] = 0.0;
    }


    return Scaffold(
      appBar: AppBar(
        title: this.isFood ? const Text("Food composition analysis"): const Text("Nutrition extraction"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(right: 15. w, left: 15. w),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // AddFoodScreenAppBar(),
            FoodImage(this.image),
            this.isFood ?
            FoodCategories(this.response['result']) // True: 執行食物分析
            :
            CalorieStatistics(
                this.response['result']['Calories from Fat'],
                this.response['result']['Carbohydrate'],
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
