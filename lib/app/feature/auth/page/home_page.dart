import 'package:elesson/app/feature/auth/controller/auth_controller.dart';
import 'package:elesson/app/feature/shared/widgets/init_title.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

import '../../../util/config.dart';

class AuthScreen extends StatelessWidget {
  final AuthController authController;

  const AuthScreen({Key? key, required this.authController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authController.authLoginEntity.username.text = "convidado";
    authController.authLoginEntity.password.text = "convidado";

    Size size = MediaQuery.of(context).size;

    if(webRender){
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/img/cover.png", height: size.height * 0.5, fit: BoxFit.cover),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            initTitle(text: "Acesse seu espaço (A)", heightScreen: size.height, bottomMargin: 36),
            SizedBox(height: 36.0),
            elessonCard(backgroundImage: "assets/img/cover.png", text: "ACESSO COM QR CODE", screenWidth: size.width, onTap: scan, context: context),
            SizedBox(height: size.height * 0.05),
            authController.showLoading ? CircularProgressIndicator(): GestureDetector(
              onTap: () => authController.getAcessToken(context),
              child: Text("USAR COMO CONVIDADO", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
