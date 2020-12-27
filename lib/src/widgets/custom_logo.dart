import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final ImageProvider<Object> img;
  final String text;

  const Logo({
    @required this.img, 
    @required this.text
  });  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        child: Column(
          children: [

            Image(image: this.img),
            SizedBox(height: 20),
            Text( this.text, style: TextStyle(fontSize: 30), textAlign: TextAlign.center, )

          ],
        ),
      ),
    );
  }
}