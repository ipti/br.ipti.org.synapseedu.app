import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

void callSnackBar(BuildContext context,
    {String text =
        'Não foi possível conectar o Elesson Duo. Verifique a conexão e tente de novo.'}) {
  final snackBar = SnackBar(
    // backgroundColor: Color(0xFF00DC8C),
    backgroundColor: Color.fromRGBO(0, 0, 255, 1),
    content: Text(
      text,
      style: TextStyle(
        fontSize: fonteDaLetra,
      ),
    ),
    action: SnackBarAction(
      textColor: Color.fromRGBO(255, 0, 0, 1),
      label: 'FECHAR',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
