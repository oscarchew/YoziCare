import 'package:flutter/material.dart';

import 'food_analysis_screen.dart';


class AddFoodScreen extends StatelessWidget {

  static String routeName = '/addfood';
  const AddFoodScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddFoodBody();
  }
}