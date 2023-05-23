import 'package:elesson/app/feature/auth/controller/auth_controller.dart';
import 'package:elesson/app/feature/shared/widgets/init_title.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  final AuthController authController;

  const AuthScreen({Key? key, required this.authController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authController.authLoginEntity.username.text = "kevenny_adm";
    authController.authLoginEntity.password.text = "senhasupersecreta";

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(text: "Acesse seu espaço (A)", heightScreen: size.height, bottomMargin: 36),
            SizedBox(height: 36.0),
            elessonCard(backgroundImage: "assets/img/cover.png", text: "ACESSO COM QR CODE", screenWidth: size.width, onTap: scan, context: context),
            elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "ACESSO POR TELEFONE CELULAR",
              screenWidth: size.width,
              onTap: (value) => Navigator.of(context).pushNamed(SmsRegisterView.routeName),
              context: context,
            ),
            SizedBox(height: size.height * 0.05),
            GestureDetector(
              onTap: () => authController.getAcessToken(context),
              child: Text("USAR COMO CONVIDADO", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
