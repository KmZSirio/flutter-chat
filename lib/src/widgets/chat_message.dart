import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/src/services/auth_service.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key, 
    @required this.text, 
    @required this.uid, 
    @required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation( parent: animationController, curve: Curves.easeOut ),
        child: Container(
          child: ( this.uid == authService.user.uid )
            ? _myMessages()
            : _notMyMessages(),
        ),
      ),
    );
  }

  Widget _myMessages() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(9),
        margin: EdgeInsets.only(
          top: 5, left: 50, right: 6
        ),
        child: Text( this.text, style: TextStyle( color: Colors.white ) ),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(50)
        ),
      ),
    );
  }

  Widget _notMyMessages() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(9),
        margin: EdgeInsets.only(
          top: 5, left: 6, right: 50
        ),
        child: Text( this.text, style: TextStyle( color: Colors.black87 )  ),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(50)
        ),
      ),
    );
  }
}