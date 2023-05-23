  import 'package:dialogflow_grpc/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:gdsc/model/food_analysis_content/theme.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:percent_indicator/linear_percent_indicator.dart';

  Widget symptom({ bool ? healthData, String ? symtom_name}) {
    return  Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:  healthData! ? Colors.transparent: Colors.lightGreen, //
        border: Border.all(color: AppColors.colorTint400),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 3, height: 1,),
          Text(symtom_name!, style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 14. sp),),
          SizedBox(width: 3, height: 1,),
          // FaIcon( FontAwesomeIcons.userDoctor, color: Colors.amber),
        ],
      ),
    );
  }
  Widget weight({ double ? weight}) {
    return  Container(
      padding: EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //     color:  Colors.transparent, //
      //     border: Border.all(color: AppColors.colorTint400),
      //     borderRadius: BorderRadius.circular(20)
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Weight: ", style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 14. sp),),
          SizedBox(width: 3, height: 1,),
          SizedBox(width: 3, height: 1,),
          Text(weight.toString()!, style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 14. sp),),
          SizedBox(width: 3, height: 1,),
          // FaIcon( FontAwesomeIcons.userDoctor, color: Colors.amber),
        ],
      ),
    );
  }
  Widget birthday({ String ? birthday}) {
    return  Container(
      padding: EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //     color:  Colors.transparent, //
      //     border: Border.all(color: AppColors.colorTint400),
      //     borderRadius: BorderRadius.circular(20)
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Birth: ", style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 14. sp),),
          SizedBox(width: 3, height: 1,),
          Text(birthday!, style: TextStyle(color: AppColors.colorTint700, fontWeight: FontWeight.bold, fontSize: 14. sp),),
          SizedBox(width: 3, height: 1,),
          // FaIcon( FontAwesomeIcons.userDoctor, color: Colors.amber),
        ],
      ),
    );
  }
  Widget healthInfo({ Color ? progressColor, String ? title, FaIcon ? icon }) {
    return Expanded(
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
                  title!,
                  style: TextStyle(
                    color: AppColors.colorTint700,
                    fontWeight: FontWeight.bold,
                    fontSize: 15. sp
                  ),
                ),
                icon!,
              ],
            ),
          ],
        ),
      ),
    );
  }