import 'package:flutter/material.dart';

import '../constants/colors.dart';
class MYTextField extends StatelessWidget {
   final String text;
    final TextEditingController controller;
  const MYTextField({super.key,required this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller:controller ,
        decoration: InputDecoration(
        hintText: text,
        contentPadding: EdgeInsets.all(15),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
    color: normal
    ),
    ),
    ),
    );
  }
}
