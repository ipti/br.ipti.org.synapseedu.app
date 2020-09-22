import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';

class PerguntaEResposta extends StatefulWidget {
  @override
  _PerguntaERespostaState createState() => _PerguntaERespostaState();
}

class _PerguntaERespostaState extends State<PerguntaEResposta> {
  @override
  Widget build(BuildContext context) {
    return Template_Slider(
      titulo: Text("teste",textAlign: TextAlign.center,),
      imagem: Image.network('http://1.bp.blogspot.com/-Dk9tb3fDa68/UUN932BEVHI/AAAAAAAABNs/iqm8mdkMoA8/s1600/cubo_magico_montado.png'),
      telaDeAtividade: Container(),
    );
  }
}
