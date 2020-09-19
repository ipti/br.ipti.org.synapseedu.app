import 'package:flutter/material.dart';

class Caixa_Login extends StatelessWidget {
  final double larguraTelaDisponivel;

  Caixa_Login(this.larguraTelaDisponivel);

  double error_message_opacity = 1.0;

  final usuario = TextEditingController();
  final senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //<---------LARGURA E ALTURA IGUAIS PRA FORMAR UM QUADRADO--------->
      height: larguraTelaDisponivel / 1.3,
      width: larguraTelaDisponivel / 1.3,
      decoration: BoxDecoration(
          color: Colors.lightGreenAccent[700],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'acesso',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: larguraTelaDisponivel * 0.09,
            ),
          ),
          Entrada('Usuário', larguraTelaDisponivel),
          Entrada('Senha', larguraTelaDisponivel),
          Entrar(),
          Text(
            'Verifique seus dados de acesso',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: larguraTelaDisponivel * 0.04,
              color: Colors.red.withOpacity(error_message_opacity),
            ),
          ),
        ],
      ),
    );
  }

  Widget Entrada(String Variavel, double LarguraDisponivel) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: Variavel,
          hintStyle:
              TextStyle(color: Colors.grey, fontSize: LarguraDisponivel * 0.07),
        ),
        controller: Variavel == 'Usuário' ? usuario : senha,
      ),
    );
  }

  Widget Entrar() {
    return GestureDetector(
      onTap: () {}, // adicionar função ao tocar no botão
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 5, color: Colors.orange),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'entrar',
          style: TextStyle(
            color: Colors.orange,
            fontSize: larguraTelaDisponivel * 0.09,
          ),
        ),
      ),
    );
  }
}
