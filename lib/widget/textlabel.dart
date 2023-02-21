import 'package:flutter/material.dart';

Widget labelText(
    {required String fieldLabel,
    required TextEditingController? textController,
    required double size}) {
  return Row(
    children: [
      Text(fieldLabel),
      Text(" : "),
      SizedBox(
        width: size,
        child: TextFormField(
          controller: textController,
        ),
      ),
    ],
  );
}
