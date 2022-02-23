import 'package:flutter/material.dart';

Widget feild(
    Size s, String text, IconData icon, TextEditingController controller) {
  return SizedBox(
    height: s.height / 11,
    width: s.width,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: text,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    ),
  );
}
