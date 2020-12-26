import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String text1;
  final String text2;
  final String route;

  const Labels({
    @required this.text1, 
    @required this.text2,
    @required this.route,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          
          Text( this.text1, style: TextStyle( color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300 )),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.route);
            },
            child: Text( this.text2, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),)
          ),

        ],
      ),
    );
  }
}