import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realtime_chat/src/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Column(

          children: [
            CircleAvatar(
              child: Text("Us", style: TextStyle( fontSize: 12 ),),
              backgroundColor: Colors.black.withOpacity(0.75),
              maxRadius: 15,
            ),
            SizedBox( height: 3 ),
            Text("Usuario destino", style: TextStyle( color: Colors.black87, fontSize: 13 ))
          ],

        )
      ),
      body: Container(
        child: Column(
          children: [

            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: ( _, i) => _messages[i],
              )
            ),

            Container(
              margin: EdgeInsets.only( top: 10 ),
              child: Divider( height: 1 )
            ),
            
            Container(
              color: Colors.white,
              child: _inputChat(),
            )

          ],
        )
      ),
    );
  }

  Widget _inputChat() {
    
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric( horizontal: 8 ),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textCtrl,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: _handleSubmit,
                onChanged: ( String text ){
                  setState(() {
                    if( text.length > 0 ){
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enviar mensaje",
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
                focusNode: _focusNode,
              )
            ), 
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4 ),
              child: ( Platform.isIOS) 
                      ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: ( _isWriting )
                              ? () => _handleSubmit( _textCtrl.text.trim() )
                              : null,
                      )
                      : Container(
                        child: IconTheme(
                          data: IconThemeData(
                            color: Colors.blue
                          ),
                          child: IconButton( 
                            icon: Icon( FontAwesomeIcons.solidPaperPlane ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: ( _isWriting )
                              ? () => _handleSubmit( _textCtrl.text.trim() )
                              : null,
                          ),
                        ),
                      ),
            )

          ],
        ),
      ),
    );
  }

  _handleSubmit( String text ) {

    // print( text );
    _textCtrl.clear();
    _focusNode.requestFocus();

    if ( text.length == 0 ) {
      final _newMessage = new ChatMessage( 
            uid: "123", 
            text: text,
            animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 400) ),
          );
          _messages.insert(0, _newMessage);
          _newMessage.animationController.forward();
    }    

    setState(() {
      _isWriting = false;
    });

  }

  @override
  void dispose() {

    // Off del socket

    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    super.dispose();
  }

}