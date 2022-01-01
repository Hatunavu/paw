import 'package:flutter/material.dart';

class LeadingBack extends StatelessWidget {
  const LeadingBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 20,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
