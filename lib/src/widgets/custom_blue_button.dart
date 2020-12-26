import 'package:flutter/material.dart';

class CustomBlueButton extends StatelessWidget {

  final String text;
  final Color color;
  final Color textColor;
  final double elevation;
  final double highlightElevation;
  final Function onPressed;

  const CustomBlueButton({
    @required this.text, 
    this.color = Colors.blue, 
    this.textColor = Colors.white, 
    this.elevation = 2, 
    this.highlightElevation = 5, 
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        elevation: this.elevation,
        highlightElevation: this.highlightElevation,
        color: this.color,
        shape: StadiumBorder(),
        onPressed: this.onPressed,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 45,
          child: Text(this.text, style: TextStyle(color: this.textColor, fontSize: 16)),
        ),
      ),
    );
  }
}