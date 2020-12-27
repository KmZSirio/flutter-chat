import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/src/pages/login_page.dart';
import 'package:realtime_chat/src/pages/users_page.dart';
import 'package:realtime_chat/src/services/auth_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState( context ),
        builder: ( context, snapshot ) { 
          return Center(
            child: Text("Espere..."),
          );
        }
      )
    );
  }

  Future checkLoginState( BuildContext context) async {

    final authService = Provider.of<AuthService>( context, listen: false );

    final authenticated = await authService.isLoggedIn();

    if ( authenticated == "true" ) {
      // TODO: Conectar al socket sv
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => UsersPage(),
          transitionDuration: Duration( milliseconds: 0 )
        )
      );
      
    } else if ( authenticated == "false" ) {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage(),
          transitionDuration: Duration( milliseconds: 0 )
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage( authError: authenticated ),
          transitionDuration: Duration( milliseconds: 0 )
        )
      );
    }
  }
}