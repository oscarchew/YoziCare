import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdsc/model/food_analysis_content/statistics-tile.dart';
// import 'package:nutrition/widget/widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gdsc/model/food_analysis_content/theme.dart';

class CalorieStatistics extends StatelessWidget {
  // const CalorieStatistics({
  //   Key ? key
  // }): super(key: key);

  //final double calories;
  final double carbs;
  final double sodium;
  final double fat;
  final double protein;
  var response;

  // 如果為空設為0
  CalorieStatistics(this.carbs, this.sodium, this.fat, this.protein);


  // CalorieStatistics(this.response);

  // 設定一日攝取總量
  final double nor_carbs = 300;
  final double nor_sodium = 2;
  final double nor_fat = 70;
  final double nor_protein = 84;
  //final double nor_cal = 2500;

  @override
  Widget build(BuildContext context) {

    // if(fat == null){
    //   fat = 0;
    // }
    // if(protein == null){
    //   protein = 0;
    // }
    // if(carbs == null){
    //   carbs = 0;
    // }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: Container(
            margin: EdgeInsets.only(top: 18. w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _calorieStatistics(),
                SizedBox(width: 15. w, ),
                statisticsTile(
                  title: 'Carbs',
                  icon: FaIcon(
                    FontAwesomeIcons.pizzaSlice,
                    color: Colors.amber,
                  ),
                  progressColor: Colors.amber,
                  unitName: 'grams',
                  value: this.carbs,  //23.50,
                  progressPercent: this.carbs/ nor_carbs,//0.8
                ),
              ],
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Container(
            margin: EdgeInsets.only(top: 18. w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                statisticsTile(
                  title: 'Proteins',
                  icon: FaIcon(
                    FontAwesomeIcons.cloudMeatball,
                    color: Colors.blue,
                  ),
                  progressColor: Colors.blue,
                  unitName: 'grams',
                  value: this.protein, //10.0,
                  progressPercent:  this.protein/nor_protein,  // 0.4
                ),
                SizedBox(width: 15. w, ),
                statisticsTile(
                    title: 'Fats',
                    icon: FaIcon(
                      FontAwesomeIcons.fire,
                      color: Colors.red,
                    ),
                    progressColor: Colors.red,
                    unitName: 'grams',
                    value: this.fat, //4.1,
                    progressPercent: this.fat/nor_fat //0.2
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _calorieStatistics() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.colorPrimary,
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
                  'Sodium',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18. sp
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.fire,
                  color: Colors.orange,
                ),
              ],
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: LinearPercentIndicator(
                    width: 60. w,
                    animation: true,
                    lineHeight: 6,
                    animationDuration: 2500,
                    percent: this.sodium/nor_sodium, //0.6,
                    barRadius: Radius.circular(3),
                    progressColor: Colors.white,
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.colorTint400.withOpacity(0.4),
                  ),
                ),
                SizedBox(width: 20. w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.sodium.toString(), //'149',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20. sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5. w),
                    Text(
                      'kcal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12. sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}