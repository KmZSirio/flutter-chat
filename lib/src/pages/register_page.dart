import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/src/services/auth_service.dart';
import 'package:realtime_chat/src/helpers/show_alert.dart';
import 'package:realtime_chat/src/services/socket_service.dart';
import 'package:realtime_chat/src/widgets/custom_blue_button.dart';
import 'package:realtime_chat/src/widgets/custom_input.dart';
import 'package:realtime_chat/src/widgets/custom_labels.dart';
import 'package:realtime_chat/src/widgets/custom_logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.96,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Logo(img: AssetImage("assets/tag-logo.png"), text: "Register account"),
                _Form(),
                Labels(text1: "Ya tienes cuenta?", text2: "Ingresa ahora!", route: "login"),
                Text("Terminos y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );

    return Container(
      margin: EdgeInsets.symmetric( horizontal: 30 ),
      child: Column(
        children: [

          CustomInput(
            icon: FontAwesomeIcons.user,
            obscure: false,
            hint: "Name",
            keyboardType: TextInputType.name,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: FontAwesomeIcons.envelope,
            obscure: false,
            hint: "Email",
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: FontAwesomeIcons.lock,
            obscure: true,
            hint: "Password",
            keyboardType: TextInputType.text,
            textController: passCtrl,
          ),
          CustomBlueButton(
            text: "OK",
            onPressed: authService.authenticating ? null : () async {
              
              // TODO: Error al enviar email incorrectamente
              if ( nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty ) {
              
                FocusScope.of(context).unfocus();
                final registerOk = await authService.register( nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim() );

                if ( registerOk == "ok" ) {
                  socketService.connect();
                  Navigator.pushReplacementNamed(context, "users");
                } else if ( registerOk == "sv" ) {
                  showAlert(context, "Error", "Conexion fallida, intente mas tarde");
                  nameCtrl.clear();
                  emailCtrl.clear();
                  passCtrl.clear();
                } else {
                  showAlert(context, "Error", registerOk);
                }

              } else {
                showAlert(context, "Error", "Llene todos los campos!!");
              }
            },
          ),

        ],
      ),
    );
  }
}

