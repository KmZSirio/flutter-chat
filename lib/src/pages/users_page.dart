import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/src/models/user.dart';
import 'package:realtime_chat/src/services/auth_service.dart';

class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  RefreshController _refreshController = RefreshController( initialRefresh: false );

  final List users = [
    User( uid: "1", name: "Pedro", email: "iron@gmail.com", online: true ),
    User( uid: "2", name: "Juan", email: "jesta@gmail.com", online: false ),
    User( uid: "3", name: "Luis", email: "lemon@gmail.com", online: true ),
    User( uid: "4", name: "Jose", email: "commander@gmail.com", online: true ),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
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
            //TODO: Desconectar el socket
            Navigator.pushReplacementNamed(context, "login");
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            // child: Icon( FontAwesomeIcons.solidCheckCircle, color: Colors.green[300] ),
            // child: Icon( FontAwesomeIcons.solidTimesCircle, color: Colors.red[300] ),
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
        child: _userListTile( users[i] ),
        onTap: () => Navigator.pushNamed(context, "chat"),
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
                  ? Icon( FontAwesomeIcons.signal, color: Colors.green[300], size: 20 )
                  : Icon( FontAwesomeIcons.signal, color: Colors.red[300], size: 20 ),
        leading: CircleAvatar(
          child: Text( user.name.substring(0,2) ),
        ),
      );
  }

  _cargarUsuarios() async {

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    
  }

}