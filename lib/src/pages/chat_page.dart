import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/src/models/messages_response.dart';
import 'package:realtime_chat/src/services/auth_service.dart';
import 'package:realtime_chat/src/services/chat_service.dart';
import 'package:realtime_chat/src/services/socket_service.dart';

import 'package:realtime_chat/src/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
  
    this.socketService.socket.on("personal-message", _listenMessage );

    _loadHistorial( this.chatService.targetUser.uid );
  }

  void _loadHistorial( String userId ) async {
    List<Message> chat = await this.chatService.getChat( userId );

    final history = chat.map((m) => new ChatMessage(
      text: m.message, 
      uid: m.from, 
      animationController: new AnimationController( vsync: this, duration: Duration(milliseconds: 0) )..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage( dynamic payload ) {

    ChatMessage message = new ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationController: new AnimationController( vsync: this, duration: Duration(milliseconds: 400) ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final targetUser = chatService.targetUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 60,
        centerTitle: true,
        title: Column(

          children: [
            SizedBox( height: 3 ),
            CircleAvatar(
              child: Text( targetUser.name.substring(0, 2), style: TextStyle( fontSize: 13 ) ),
              backgroundColor: Colors.black.withOpacity(0.75),
              maxRadius: 16,
            ),
            SizedBox( height: 3 ),
            Text( targetUser.name, style: TextStyle( color: Colors.black87, fontSize: 15 ))
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

    if ( text.length > 0 ) {
      final _newMessage = new ChatMessage( 
            uid: authService.user.uid, 
            text: text,
            animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 400) ),
          );
          _messages.insert(0, _newMessage);
          _newMessage.animationController.forward();
    }    

    setState(() {
      _isWriting = false;
    });

    socketService.emit("personal-message", {
      "from": this.authService.user.uid,
      "to"  : this.chatService.targetUser.uid,
      "message" : text
    });
  }

  @override
  void dispose() {

    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }

    this.socketService.socket.off("personal-message");
    super.dispose();
  }
}