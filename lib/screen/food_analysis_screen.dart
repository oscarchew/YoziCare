import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/food_analysis_content/appbar.dart';
import '../model/food_analysis_content/calorie-statistics.dart';
import '../model/food_analysis_content/change-amount.dart';
import '../model/food_analysis_content/food-image.dart';

class AddFoodBody extends StatelessWidget {

  const AddFoodBody({
    Key ? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812)); // 要有初始化螢幕尺寸
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin:  EdgeInsets.only(right: 15. w, left: 15. w),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // AddFoodScreenAppBar(),
            FoodImage('assets/images/goodpasta.jpg'),
            // Nutrient
            CalorieStatistics(1500,80,5,15),
            // ChangeAmount()
          ],
        ),
      ),
    );
  }
}
