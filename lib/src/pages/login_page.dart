import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/src/helpers/show_alert.dart';
import 'package:realtime_chat/src/services/auth_service.dart';
import 'package:realtime_chat/src/widgets/custom_blue_button.dart';
import 'package:realtime_chat/src/widgets/custom_input.dart';
import 'package:realtime_chat/src/widgets/custom_labels.dart';
import 'package:realtime_chat/src/widgets/custom_logo.dart';

class LoginPage extends StatelessWidget {

  final String authError;

  const LoginPage({
    this.authError = ""
  });

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

                Logo(img: AssetImage("assets/tag-logo.png"), text: "Messenger"),
                Text( authError, style: TextStyle(color: Colors.red[400], fontSize: 15, fontWeight: FontWeight.w400) ),
                _Form(),
                Labels(text1: "¿No tienes cuenta?", text2: "Crea una ahora!", route: "register"),
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

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );

    return Container(
      margin: EdgeInsets.symmetric( horizontal: 30 ),
      child: Column(
        children: [

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

              if ( emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty ) {

                FocusScope.of(context).unfocus();
                final loginOk = await authService.login( emailCtrl.text.trim(), passCtrl.text.trim() );

                if ( loginOk == "ok" ) {
                  // TODO: Conectar a nuestro socket server
                  Navigator.pushReplacementNamed(context, "users");
                } else if ( loginOk == "sv" ) {
                  showAlert(context, "Error", "Conexion fallida, intente mas tarde");
                  emailCtrl.clear();
                  passCtrl.clear();
                } else {
                  showAlert(context, "Error", loginOk);
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

