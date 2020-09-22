import 'package:flutter/material.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Template_Slider extends StatelessWidget {
  final Widget titulo;
  final Widget telaDeAtividade;
  final Widget imagem;

  const Template_Slider({Key key, this.titulo, this.telaDeAtividade, this.imagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double largura_tela = MediaQuery.of(context).size.width;
    double altura_tela = MediaQuery.of(context).size.height;

    return VerticalTabs(
      tabsWidth: 0.0,
      contentScrollAxis: Axis.vertical,
      // <====Essas TABS nao aparecem, são apenas requisitos do VerticalTabs====>
      tabs: <Tab>[
        Tab(child: Text('')),
        Tab(child: Text('')),
      ],
      // <====Telas====>
      contents: [
        Primeira_Tela(largura_tela, altura_tela),
        Segunda_Tela(largura_tela, altura_tela),
      ],
    );
  }

  Widget Primeira_Tela(double largura_tela, double altura_tela) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: largura_tela,
      height: altura_tela,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: titulo != null ? titulo : Container()),
          imagem != null ? imagem: Container(),
        ],
      ),
    );
  }

  Widget Segunda_Tela(double largura_tela, double altura_tela) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      width: largura_tela,
      height: altura_tela,
      child: telaDeAtividade,
    );
  }
}
