import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/presentation/screens/home/food_analysis_screen.dart';
import 'image_picker_page.dart';

@RoutePage()
class FoodAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildFeatureCard(
              context,
              'Food composition analysis',
              'https://foodanalysis-z5zukxh7ha-df.a.run.app',
              Icons.analytics
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
              context,
              'Nutrition extraction',
              'https://nutrition-z5zukxh7ha-df.a.run.app',
              Icons.fastfood_rounded
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String cloudRunUrl, IconData icon) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightGreen
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImagePickerPage(cloudRunUrl)),
          ),
          icon: Icon(icon),
          label: Text(title)
      );
}
