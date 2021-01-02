import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/src/models/user.dart';
import 'package:realtime_chat/src/pages/chat_page.dart';
import 'package:realtime_chat/src/services/auth_service.dart';
import 'package:realtime_chat/src/services/chat_service.dart';
import 'package:realtime_chat/src/services/socket_service.dart';
import 'package:realtime_chat/src/services/users_service.dart';

class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final usersService = new UsersService();
  RefreshController _refreshController = RefreshController( initialRefresh: false );

  List<User> users = [];

  // final List users = [
  //   User( uid: "1", name: "Iron", email: "iron@gmail.com", online: true ),
  //   User( uid: "2", name: "Jesta", email: "jesta@gmail.com", online: false ),
  //   User( uid: "3", name: "Lemon", email: "lemon@gmail.com", online: true ),
  //   User( uid: "4", name: "Commander", email: "commander@gmail.com", online: true ),
  // ];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>( context );
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text( user.name, style: TextStyle(color: Colors.black87) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( FontAwesomeIcons.signOutAlt, color: Colors.blue, ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, "login");
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ( socketService.serverStatus == ServerStatus.Online )
              ? Icon( FontAwesomeIcons.solidCheckCircle, color: Colors.green[300], size: 20 )
              : Icon( FontAwesomeIcons.solidTimesCircle, color: Colors.red[300], size: 20 )
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( FontAwesomeIcons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsers(),
      ),

    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_ , i) => GestureDetector(
        child: _userListTile( users[i] )
      ), 
      separatorBuilder: (_ , i) => Divider(),
      itemCount: users.length
    );
  }

  ListTile _userListTile( User user ) {
    return ListTile(
        title: Text( user.name ),
        subtitle: Text( user.email ),
        trailing: ( user.online )
                  ? Container( width: 10, height: 10, decoration: BoxDecoration( shape: BoxShape.circle, color: Colors.green[300] ) )
                  : Container( width: 10, height: 10, decoration: BoxDecoration( shape: BoxShape.circle, color: Colors.red[300] ) ),
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue[200],
          child: Text( user.name.substring(0,2) ),
        ),
        onTap: () {

          final chatService = Provider.of<ChatService>( context, listen: false );
          chatService.targetUser = user;
          Navigator.pushNamed(context, "chat");
                  
        }
      );
  }

  _cargarUsuarios() async {

    this.users = await usersService.getUsers();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}