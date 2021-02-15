import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class BlockConclusion extends StatelessWidget {
  static const routeName = '/block_conclusion';

  final String studentName = 'FULANO';
  final String module = '1';
  final int year = 1;
  final String subject = 'CIÊNCIAS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PARABÉNS\n$studentName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
            ),
            Image.asset('assets/img/personagem_comemorando_CELESTE_cie.png'),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: headerFontSize,
                    ),
                    text:
                        'VOCÊ COMPLETOU\nO MÓDULO $module DO\n$yearº ANO DE $subject',
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ButtonTheme(
                    height: 48,
                    minWidth: MediaQuery.of(context).size.width - 32,
                    child: OutlineButton(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromRGBO(0, 0, 255, 1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'VOLTAR AO MENU',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context).popAndPushNamed("/"),
                      textTheme: ButtonTextTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
