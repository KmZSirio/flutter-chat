import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final String hint;
  final TextEditingController textController;

  const CustomInput({
    @required this.icon, 
    this.keyboardType = TextInputType.text, 
    this.obscure = false, 
    @required this.hint,
    @required this.textController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(right: 20, top: 5, left: 5,bottom: 5),
      child: TextField(
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyboardType,
        obscureText: this.obscure,
        decoration: InputDecoration(
          prefixIcon: Icon( this.icon ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.hint
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.05),
            offset: Offset(0,5),
            blurRadius: 5
          )
        ]
      ),
    );
  }
}