import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SharedStatefulWidget {
  static StatefulBuilder addSizedCheckBox({
    required String title,
    required Map<String, bool> state,
    required String field,
  }) => StatefulBuilder(builder: (BuildContext context, setState) => SizedBox(
      width: 300,
      child: CheckboxListTile(
          title: Text(title, style: const TextStyle(fontSize: 16),),
          value: state[field],
          onChanged: (newVal) { setState(() { state[field] = newVal!; }); }
      )
  ));

  static StatefulBuilder addSizedOutlinedTextField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    void Function()? onTap
  }) => StatefulBuilder(builder: (BuildContext context, setState) => SizedBox(
    width: 100,
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText
      ),
    ),
  ));
}

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(message))
    );
  }
}