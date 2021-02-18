import 'package:elesson/share/colors.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class BlockConclusion extends StatelessWidget {
  static const routeName = '/block_conclusion';

  final String studentName = 'JOÃO';
  final String module = '1';
  final int year = 1;
  final String subject = 'LINGUAGENS';

  Widget subjectCharacter() {
    Widget imageAsset;
    switch (subject) {
      case 'CIÊNCIAS':
        imageAsset =
            Image.asset('assets/img/personagem_comemorando_LILA_ling.png');
        break;
      case 'CIÊNCIAS':
        imageAsset =
            Image.asset('assets/img/personagem_comemorando_CELESTE_cie.png');
        break;
      default:
        imageAsset =
            Image.asset('assets/img/personagem_comemorando_MATEUS_mat.png');
    }
    return imageAsset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                'PARABÉNS\n$studentName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 255, 1),
                  fontSize: 22,
                ),
              ),
            ),
            // Image.asset('assets/img/personagem_comemorando_CELESTE_cie.png'),
            subjectCharacter(),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    text: 'VOCÊ COMPLETOU\n',
                    children: [
                      TextSpan(
                        text: 'O MÓDULO $module DO\n$yearº ANO DE $subject',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 255, 0.4),
                        ),
                      ),
                    ],
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
