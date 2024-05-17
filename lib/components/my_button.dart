import 'package:flutter/material.dart';

import '../constants/colors.dart';
class MYButton extends StatelessWidget {
   final String text;
   final VoidCallback onPressed;
   final Size fixedSize;
   final Color color;
  const MYButton({super.key,required this.text,required this.onPressed,required this.fixedSize,required this.color});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(onPressed:onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: fixedSize,
          backgroundColor:color,
        ),
        child: Text(text,style: TextStyle(color: normal,fontSize: 15),));
  }
}
