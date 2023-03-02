import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SharedStatefulWidget {
  static StatefulBuilder addSizedCheckBox({
    required String title,
    required List<bool> state,
    required int index,
  }) => StatefulBuilder(builder: (BuildContext context, setState) => SizedBox(
      width: 300,
      child: CheckboxListTile(
          title: Text(title, style: const TextStyle(fontSize: 16),),
          value: state[index],
          onChanged: (newVal) { setState(() { state[index] = newVal!; }); }
      )
  ));
}