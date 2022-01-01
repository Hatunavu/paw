import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String data;
  final String content;
  const Header({Key key, @required this.data, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          content,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          data,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
