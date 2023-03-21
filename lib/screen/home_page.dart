import 'package:flutter/material.dart';
import 'image_picker_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food composition analysis'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text('kevin', style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildFeatureCard(context, 'Food composition analysis', 'https://ana-z5zukxh7ha-df.a.run.app'),
                  SizedBox(height: 16),
                  _buildFeatureCard(context, 'Nutrition extraction', 'https://nutrition-z5zukxh7ha-df.a.run.app'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String cloudRunUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImagePickerPage(cloudRunUrl)),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(title, style: Theme.of(context).textTheme.bodyText1),
        ),
      ),
    );
  }
}
