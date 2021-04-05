import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

void callSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Color(0xFF00DC8C),
    content: Text(
      'Não foi possível conectar o Elesson Duo. Verifique a conexão e tente de novo.',
      style: TextStyle(
        fontSize: fonteDaLetra,
      ),
    ),
    action: SnackBarAction(
      textColor: Color.fromRGBO(0, 0, 255, 1),
      label: 'Fechar',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
