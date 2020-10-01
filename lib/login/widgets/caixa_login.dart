import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Caixa_Login extends StatefulWidget {
  final double larguraTelaDisponivel;

  Caixa_Login(this.larguraTelaDisponivel);

  @override
  _Caixa_LoginState createState() => _Caixa_LoginState();
}

// final exibirErro = StateProvider((ref) => false);

class _Caixa_LoginState extends State<Caixa_Login> {
  final usuario = TextEditingController();
  final senha = TextEditingController();

  bool exibirErro = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //<---------LARGURA E ALTURA IGUAIS PRA FORMAR UM QUADRADO--------->
      height: widget.larguraTelaDisponivel / 1.1,
      width: widget.larguraTelaDisponivel / 1.1,
      margin: EdgeInsets.only(left: 20,right: 20),
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
              fontSize: widget.larguraTelaDisponivel * 0.09,
            ),
          ),
          Entrada('Usuário', widget.larguraTelaDisponivel),
          Entrada('Senha', widget.larguraTelaDisponivel),
          Entrar(),
          Text(
            exibirErro ? 'Verifique seus dados de acesso' : "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.larguraTelaDisponivel * 0.04,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget Entrada(String Variavel, double LarguraDisponivel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: TextFormField(
        style: TextStyle(fontSize: LarguraDisponivel * 0.07),
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
    Color cor_letra = Colors.orange;
    Color cor_botao = Colors.white;

    return GestureDetector(
      onTap: () {
        ValidarUsuario()
            ? null
            : setState(() {
                exibirErro = true;
              });
      }, // adicionar função ao tocar no botão
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: cor_botao,
          border: Border.all(width: 5, color: Colors.orange),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'entrar',
          style: TextStyle(
            color: cor_letra,
            fontSize: widget.larguraTelaDisponivel * 0.09,
          ),
        ),
      ),
    );
  }

  bool ValidarUsuario() {
    // enquanto não estamos comunicando com o servidor
    return usuario == 'admin' && senha == '123456' ? true : false;
  }
}
