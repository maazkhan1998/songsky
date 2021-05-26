import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {

  final String text;
  final Function onPressed;

  const DrawerItem({ required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18
        ),
      ),
      onPressed:()=> onPressed(),
    );
  }
}
