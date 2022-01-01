import 'package:flutter/material.dart';

class Infor extends StatelessWidget {
  final String data;
  final String content;
  const Infor({Key key, @required this.data, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          content,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const Text(': '),
        Text(
          data,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
      ],
    );
  }
}
