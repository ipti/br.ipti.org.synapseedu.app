import 'package:elesson/login/widgets/left_container.dart';
import 'package:elesson/login/widgets/right_container.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Left_Container(larguraTela, alturaTela),
          Right_Container(larguraTela, alturaTela),
        ],
      ),
    );
  }
}
