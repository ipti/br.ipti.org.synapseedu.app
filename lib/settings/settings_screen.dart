import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * Tela de configuração do aplicativo. No momento, é apenas uma tela sem funções lógicas, apenas implementada para o aplicativo entrar na playstore. *
 *
 */

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

Widget backButton(double buttonSize, BuildContext context) {
  return ButtonTheme(
    minWidth: buttonSize,
    height: buttonSize,
    child: MaterialButton(
      padding: EdgeInsets.all(0),
      color: Colors.white,
      textColor: Color(0xFF0000FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: Color.fromRGBO(0, 0, 255, 0.2),
        ),
      ),
      child: Icon(
        Icons.arrow_back,
        color: Color(0xFF0000FF),
        size: 40,
      ),
      onPressed: () {
        // O template de texto não possui a tela inferior, diferente dos outros. O condicional verifica
        // o booleano e fornece o direcionamento adequado. O template de texto permite ao usuário voltar para
        // a tela anterior dentro do mesmo texto, enquanto os outros templates não possuem tal opção.
        Navigator.of(context).pop();
      },
    ),
  );
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool status = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double buttonSize = 48 > size.height * 0.0656 ? 48 : size.height * 0.0656;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            backButton(buttonSize, context),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.15,
            width: size.width,
            alignment: Alignment.center,
            child: Text(
              'Ajustes',
              style: TextStyle(fontWeight: FontWeight.lerp(FontWeight.w100, FontWeight.bold, 1), fontSize: size.height * 0.03, color: Color(0xFF00DC8C)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Text(
              "Fizemos o máximo para explicar de forma clara e simples quais dados pessoais precisaremos de você e o que vamos fazer com cada um deles. Por isso, separamos no link abaixo os pontos mais importantes, que também podem ser lidos de forma bem completa e detalhada no nosso site.",
              style: TextStyle(color: Colors.black54,fontSize: size.height*0.02,fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: RichText(
              text: TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch("https://www.elesson.com.br/privacidade/");
                  },
                text: 'Politicas de privacidade',
                style: TextStyle(color: Color(0xFF00004C), fontWeight: FontWeight.bold, fontSize: size.height * 0.02),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aceito os termos',style: TextStyle(color: Colors.black54,fontSize: size.height*0.02,fontWeight: FontWeight.w600),),
                FlutterSwitch(
                  height: 20.0,
                  width: 40.0,
                  padding: 4.0,
                  toggleSize: 15.0,
                  borderRadius: 10.0,
                  activeColor: Color(0xFF00DC8C),
                  value: status,
                  onToggle: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
