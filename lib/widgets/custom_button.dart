import 'package:flutter/material.dart';

Widget customButton(Size s, String txt) {
  return Container(
    height: s.height / 14,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.blue),
    width: s.width / 1.2,
    child: Text(
      txt,
      style: TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
