import 'package:flutter/material.dart';

class myNewText extends StatelessWidget{

myNewText(this.text, this.color);
  final String text;
  //final Function() clickHandler;
  final Color color;
//this.clickHandler, 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text(text),
      color: color,
    );
  }
  
}