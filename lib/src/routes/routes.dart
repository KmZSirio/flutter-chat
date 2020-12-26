

import 'package:flutter/cupertino.dart';
import 'package:realtime_chat/src/pages/chat_page.dart';
import 'package:realtime_chat/src/pages/loading_page.dart';
import 'package:realtime_chat/src/pages/login_page.dart';
import 'package:realtime_chat/src/pages/register_page.dart';
import 'package:realtime_chat/src/pages/users_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  "users" : (_) => UsersPage(),
  "chat" : (_) => ChatPage(),
  "login" : (_) => LoginPage(),
  "register" : (_) => RegisterPage(),
  "loading" : (_) => LoadingPage(),

};