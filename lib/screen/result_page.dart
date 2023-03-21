import 'dart:io';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final File image;
  final String response;

  ResultPage(this.image, this.response);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Analysis Result', style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 16),
            Expanded(
              child: Image.file(image),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Text(response, style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
    );
  }
}