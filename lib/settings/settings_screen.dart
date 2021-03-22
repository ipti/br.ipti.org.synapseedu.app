import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonSize = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
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
      body: Center(
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                  text: 'hey', style: TextStyle(color: Color(0xFF0000FF))),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
