import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/block_conclusion_arguments_model.dart';
import 'package:flutter/material.dart';

import '../app/feature/qrcode/page/qrcode_page.dart';

class BlockConclusionScreen extends StatelessWidget {
  static const routeName = '/block_conclusion';

  BlockConclusionScreen({Key? key}) : super(key: key);

  String? studentName;
  final String module = '1';

  // final String discipline = 'LINGUAGENS';
  String? discipline;
  String? year;

  Widget disciplineCharacter() {
    Widget imageAsset;
    switch (discipline) {
      case 'Português':
        imageAsset = Image.asset('assets/img/personagem_comemorando_LILA_ling.png');
        break;
      case 'Ciências':
        imageAsset = Image.asset('assets/img/personagem_comemorando_CELESTE_cie.png');
        break;
      default:
        imageAsset = Image.asset('assets/img/personagem_comemorando_MATEUS_mat.png');
    }
    return imageAsset;
  }

  @override
  Widget build(BuildContext context) {
    // final BlockConclusionArguments args = ModalRoute.of(context)!.settings.arguments as BlockConclusionArguments;
    // discipline = args.discipline;
    // studentName = args.studentName ?? 'Aluno(a)';
    // year = args.year;
    studentName = "Kevenny";
    year = "1";
    discipline = "MATEMÁTICA";

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
                style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 255, 1), fontSize: 22),
              ),
            ),
            // Image.asset('assets/img/personagem_comemorando_CELESTE_cie.png'),
            disciplineCharacter(),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Comic', fontSize: 18, color: Colors.black),
                    text: 'VOCÊ COMPLETOU:\n',
                    children: [
                      TextSpan(
                        text: 'MÓDULO $module DO\n$yearº ANO DE $discipline',
                        style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ButtonTheme(
                    height: 48,
                    minWidth: MediaQuery.of(context).size.width - 32,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                        textStyle: TextStyle(color: Color(0xFF0000FF)),
                        backgroundColor: Color.fromRGBO(0, 0, 255, 1),
                        padding: EdgeInsets.all(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Continuar para a próxima aula',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        isAdmin ? Navigator.of(context).pushReplacementNamed(QrCodePage.routeName) : Navigator.of(context).pushReplacementNamed(QrCodePage.routeName);
                        // isAdmin ? Navigator.of(context).pushReplacementNamed("/admin") : Navigator.of(context).pushReplacementNamed("/");
                      },
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
