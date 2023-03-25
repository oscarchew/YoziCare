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
    width: 200,
    child: TextField(
      enableInteractiveSelection: false,
      cursorColor: Colors.white,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.5),
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