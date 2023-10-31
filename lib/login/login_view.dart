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
    double widthSceen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: widthSceen,
              height: heightScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  logo(widthSceen),
                  LoginBox(widthSceen),
                  recoverPassword(heightScreen),
                ],
              ),
            ),
          ),
          aboutButton(widthSceen, heightScreen),
          about(widthSceen, heightScreen),
        ],
      ),
    );
  }

  Widget aboutButton(double widthSceen, double heightScreen) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAbout = 1;
        });
      },
      child: Container(
        height: heightScreen * 0.06,
        width: widthSceen * 0.2,
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent[700],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        margin: EdgeInsets.only(
          left: widthSceen * 0.06,
        ),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            'Sobre',
            style: TextStyle(fontSize: widthSceen * 0.04, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget about(double widthScreen, double heightScreen) {
    switch (showAbout) {
      case 0:
        bottomAboutBox = heightScreen;
        topAboutBox = 0;
        break;
      case 1:
        bottomAboutBox = 0;
        topAboutBox = heightScreen * 0.2;
        break;
    }

    return AnimatedContainer(
      margin: EdgeInsets.only(left: widthScreen * 0.05, right: widthScreen * 0.05, bottom: bottomAboutBox, top: topAboutBox),
      duration: Duration(milliseconds: 500),
      width: widthScreen * 0.9,
      height: heightScreen * 0.6,
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
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

  Widget logo(double widthScreen) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://avatars2.githubusercontent.com/u/64334312?s=200&v=4'),
          scale: 0.4,
        ),
      ),
      width: widthScreen,
      height: widthScreen / 2,
    );
  }

  Widget recoverPassword(double heightScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecoverPassword()),
        );
      },
      child: Text(
        'Recuperar senha',
        style: TextStyle(color: Colors.red, fontSize: heightScreen * 0.025, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
      ),
    );
  }
}
