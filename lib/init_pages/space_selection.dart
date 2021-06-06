import 'package:elesson/degree_selection/degree_selection_view.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/register/student_model.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class SpaceSelection extends StatefulWidget {
  static const routeName = '/login-qr-text';

  @override
  _SpaceSelectionState createState() => _SpaceSelectionState();
}

class _SpaceSelectionState extends State<SpaceSelection> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(
                text: "Acesse seu espaço",
                heightScreen: heightScreen,
                bottomMargin: 36),
            SizedBox(height: 36.0),
            elessonCard(
                backgroundImage: "assets/img/cover.png",
                text: "ACESSO COM QR CODE",
                screenWidth: widthScreen,
                onTap: scan,
                context: context),
            elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "ACESSO POR TELEFONE CELULAR",
              screenWidth: widthScreen,
              onTap: (value) {
                Navigator.of(context).pushNamed(SmsRegisterView.routeName);
              },
              context: context,
            ),
            SizedBox(height: heightScreen*0.05,),
            GestureDetector(
              onTap: () => LoginQuery().getLoginTrial(context),
                child: Text("USAR COMO CONVIDADO",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue,fontWeight: FontWeight.bold),)),
            // elessonCard(
            //   backgroundImage: "assets/img/cover.png",
            //   text: "TESTAR APLICATIVO",
            //   screenWidth: widthScreen,
            //   onTap: (value) {
            //     LoginQuery().getLoginTrial(context);
            //     // Navigator.of(context).pushNamed(DegreeSelectionView.routeName);
            //   },
            //   context: context,
            // ),
          ],
        ),
      ),
    );
  }
}
