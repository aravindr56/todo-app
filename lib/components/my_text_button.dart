import 'package:flutter/material.dart';

import '../constants/colors.dart';
class MyTextButton extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;

  const MyTextButton({super.key,required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return   TextButton(onPressed: onPressed,
      child:Text(text,style: TextStyle(color: normal,fontSize: 15),),
    );
  }
}
