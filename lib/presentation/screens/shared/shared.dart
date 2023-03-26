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
          title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.lightGreen)),
          value: state[field],
          activeColor: Colors.lightGreen,
          checkColor: Colors.white,
          onChanged: (newVal) { setState(() { state[field] = newVal!; }); }
      )
  ));

  static StatefulBuilder addSizedOutlinedTextField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    void Function()? onTap,
    Color? color = Colors.white
  }) => StatefulBuilder(builder: (BuildContext context, setState) => SizedBox(
    width: 200,
    child: TextField(
      enableInteractiveSelection: false,
      cursorColor: color,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: color),
      decoration: InputDecoration(
          labelStyle: TextStyle(color: color),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color!, width: 2.5),
          ),
          border: const OutlineInputBorder(),
          labelText: labelText
      ),
    ),
  )
  );
}

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(message))
    );
  }
}