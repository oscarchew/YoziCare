import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdsc/model/food_analysis_content/statistics-tile.dart';
import 'package:gdsc/model/food_analysis_content/theme.dart';
import 'package:localization/localization.dart';
// 做食物成分分析
class FoodCategories extends StatelessWidget {
  // const FoodCategories({Key? key}) : super(key: key);
  var response;
  FoodCategories(this.response);

  @override
  Widget build(BuildContext context) {
    var food_result;
    food_result = Response_analysis();
    print(food_result[0]);
    print(food_result[1]);
    return Container(
      margin: EdgeInsets.only(top: 18. w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:  Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.colorTint400),
                borderRadius: BorderRadius.circular(25)
            ),
            child: Column(
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      'suitable'.i18n(),
                      style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18. sp
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  width: 200.w,
                  height: 300.h,
                  child: Column(
                    children: [
                      for (var i in food_result[0])
                        Text(i.toString().i18n() == i.toString() ? i.toString().replaceAll('_', ' ') : i.toString().i18n())
                    ],
                  ),
                )
              ],
            ),
          ),
          ),

          SizedBox(width: 15. w, ),

          Expanded(child:  Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.colorTint400),
                borderRadius: BorderRadius.circular(25)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'caution'.i18n(),
                      style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18. sp
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.bomb,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  width: 200.w,
                  height: 300.h,
                  child: Column(
                    children: [
                      for (var i in food_result[1]) Text(i.toString().i18n()),
                    ],
                  ),
                )

              ],
            ),
          ),
          ),

        ],
      ),
    );
  }

  Response_analysis() {
    var available_food = [];
    var caution_food = [];
    for(var item in response){
      List<String> foodContent = item.split(" ");
      if(foodContent[1] == "positive"){
        available_food.add(foodContent[0]);
      }
      else if(foodContent[1] == "negative"){
        caution_food.add(foodContent[0]);
      }
    }
    // print(available_food);
    return [available_food, caution_food];

  }
}
