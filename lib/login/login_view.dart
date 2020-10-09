import 'package:elesson/recover_password/recover_password_view.dart';
import 'package:flutter/material.dart';
import 'package:elesson/login/widgets/caixa_login.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int showAbout = 0;
  double bottomAboutBox = 0.0;
  double topAboutBox = 0.0;

  //<==========DEFINIR AQUI O QUE APARECERÁ NA TELA DE SOBRE=============>
  String aboutText = "";

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: larguraTela,
              height: alturaTela,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  logo(larguraTela),
                  LoginBox(larguraTela),
                  recoverPassword(alturaTela),
                ],
              ),
            ),
          ),
          aboutButton(larguraTela, alturaTela),
          about(larguraTela, alturaTela),
        ],
      ),
    );
  }

  Widget aboutButton(double larguraTela, double alturaTela) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAbout = 1;
        });
      },
      child: Container(
        height: alturaTela * 0.06,
        width: larguraTela * 0.2,
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent[700],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        margin: EdgeInsets.only(
          left: larguraTela * 0.06,
        ),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            'Sobre',
            style: TextStyle(
                fontSize: larguraTela * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget about(double larguraTela, double alturaTela) {
    switch (showAbout) {
      case 0:
        bottomAboutBox = alturaTela;
        topAboutBox = 0;
        break;
      case 1:
        bottomAboutBox = 0;
        topAboutBox = alturaTela * 0.2;
        break;
    }

    return AnimatedContainer(
      margin: EdgeInsets.only(
          left: larguraTela * 0.05,
          right: larguraTela * 0.05,
          bottom: bottomAboutBox,
          top: topAboutBox),
      duration: Duration(milliseconds: 500),
      width: larguraTela * 0.9,
      height: alturaTela * 0.6,
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showAbout = 0;
                  });
                },
              )
            ],
          ),
          Container(
            child: Text(aboutText),
          ),
        ],
      ),
    );
  }

  Widget logo(double larguraTela) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://avatars2.githubusercontent.com/u/64334312?s=200&v=4'),
          scale: 0.4,
        ),
      ),
      width: larguraTela,
      height: larguraTela / 2,
    );
  }

  Widget recoverPassword(double alturaTela) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecoverPassword()),
        );
      },
      child: Text(
        'Recuperar senha',
        style: TextStyle(
            color: Colors.red,
            fontSize: alturaTela * 0.025,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
