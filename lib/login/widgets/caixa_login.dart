import 'package:flutter/material.dart';

class LoginBox extends StatefulWidget {
  final double widthSceenAvailable;

  LoginBox(this.widthSceenAvailable);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

// final exibirErro = StateProvider((ref) => false);

class _LoginBoxState extends State<LoginBox> {
  final user = TextEditingController();
  final password = TextEditingController();

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //<---------LARGURA E ALTURA IGUAIS PRA FORMAR UM QUADRADO--------->
      height: widget.widthSceenAvailable / 1.1,
      width: widget.widthSceenAvailable / 1.1,
      margin: EdgeInsets.only(left: 20, right: 20),
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
              fontSize: widget.widthSceenAvailable * 0.09,
            ),
          ),
          loginInput('Usuário', widget.widthSceenAvailable),
          loginInput('Senha', widget.widthSceenAvailable),
          login(),
          Text(
            showError ? 'Verifique seus dados de acesso' : "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.widthSceenAvailable * 0.04,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget loginInput(String inputString, double availableWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: TextFormField(
        style: TextStyle(fontSize: availableWidth * 0.07),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: inputString,
          hintStyle:
              TextStyle(color: Colors.grey, fontSize: availableWidth * 0.07),
        ),
        controller: inputString == 'Usuário' ? user : password,
      ),
    );
  }

  Widget login() {
    Color letterColor = Colors.orange;
    Color buttonColor = Colors.white;

    return GestureDetector(
      onTap: () {
        validateUser()
            // ignore: unnecessary_statements
            ? null
            : setState(() {
                showError = true;
              });
      }, //adicionar função ao tocar no botão
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(width: 5, color: Colors.orange),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'entrar',
          style: TextStyle(
            color: letterColor,
            fontSize: widget.widthSceenAvailable * 0.09,
          ),
        ),
      ),
    );
  }

  bool validateUser() {
    // enquanto não estamos comunicando com o servidor
    // ignore: unrelated_type_equality_checks
    return user == 'admin' && password == '123456' ? true : false;
  }
}
