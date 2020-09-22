import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';

class QuestionAndAnswer extends StatefulWidget {
  @override
  _QuestionAndAnswerState createState() => _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateSlider(
        titulo: Text(
          "teste",
          textAlign: TextAlign.center,
        ),
        imagem: Image.network(
            'http://1.bp.blogspot.com/-Dk9tb3fDa68/UUN932BEVHI/AAAAAAAABNs/iqm8mdkMoA8/s1600/cubo_magico_montado.png'),
        activityScreen: Container(
          child: Center(child: Text('hey')),
        ),
      ),
    );
  }
}
