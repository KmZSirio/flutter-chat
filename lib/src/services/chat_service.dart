import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/src/global/environment.dart';
import 'package:realtime_chat/src/models/messages_response.dart';
import 'package:realtime_chat/src/models/user.dart';
import 'package:realtime_chat/src/services/auth_service.dart';

class ChatService with ChangeNotifier {

  User targetUser;

  Future<List<Message>> getChat( String userId ) async {
    
    final resp = await http.get( '${ Environment.apiUrl }/messages/$userId',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    // Aqui se podria verificar que la respuesta este correcta
    final messagesResponse = messagesResponseFromJson( resp.body );

    return messagesResponse.messages;
  }  
}