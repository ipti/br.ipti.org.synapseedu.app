import 'package:elesson/share/general_widgets.dart';
import 'package:flutter/material.dart';

class SpaceSelection extends StatefulWidget {
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
      body: Column(
        children: [
          initTitle(text: "Acesse seu espaço",heightScreen: heightScreen,bottomMargin: 36),
          SizedBox(height: 36.0),
          elessonCard(backgroundImage: "assets/img/cover.png", text: "USAR QR CODE", screenWidth: widthScreen),
          elessonCard(backgroundImage: "assets/img/cover.png", text: "DIGITAR CÓDIGO", screenWidth: widthScreen),
        ],
      ),
    );
  }
}
