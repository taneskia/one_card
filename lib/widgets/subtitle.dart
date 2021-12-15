import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String subtitleText;

  const Subtitle({Key? key, required this.subtitleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text(subtitleText, style: const TextStyle(fontSize: 20))),
        const Divider(thickness: 1, height: 0, indent: 10, endIndent: 10),
      ],
    );
  }
}
