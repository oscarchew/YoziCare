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
          controlAffinity: ListTileControlAffinity.leading,
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
    Color? borderColor = Colors.white,
    bool roundedBorder = false,
    bool filled = false,
    Color? filledColor,
  }) => StatefulBuilder(builder: (BuildContext context, setState) => SizedBox(
    width: 200,
    child: TextField(
      enableInteractiveSelection: false,
      cursorColor: borderColor,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: borderColor),
      decoration: InputDecoration(
          filled: filled,
          fillColor: filledColor,
          contentPadding: const EdgeInsets.all(10),
          labelStyle: TextStyle(color: borderColor),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor!, width: 1.0),
              borderRadius: roundedBorder ? BorderRadius.circular(40.0) : const BorderRadius.all(Radius.circular(4.0))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor!, width: 2.5),
              borderRadius: roundedBorder ? BorderRadius.circular(40.0) : const BorderRadius.all(Radius.circular(4.0))
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor!, width: 1.0),
              borderRadius: roundedBorder ? BorderRadius.circular(40.0) : const BorderRadius.all(Radius.circular(4.0))
          ),
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