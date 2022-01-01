import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputInfor extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  InputInfor({Key key, @required this.label, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).enter_something;
        }
        return null;
      },
      controller: controller,
      cursorColor: primaryColor,
      style: const TextStyle(fontSize: 15, color: Colors.black),
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          fontSize: 10,
        ),
        focusColor: primaryColor,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(color: Colors.grey[400]),
        floatingLabelStyle: TextStyle(color: primaryColor),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
