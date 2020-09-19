import 'package:flutter/material.dart';

class Left_Container extends StatelessWidget {
  final double larguraTela;
  final double alturaTela;

  Left_Container(
    this.larguraTela,
    this.alturaTela,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/img/logo.png'),
              scale: 0.5,
            ),
          ),
          width: larguraTela * 0.6,
          height: alturaTela,
        ),
        Sobre(larguraTela, alturaTela),
      ],
    );
  }

  Widget Sobre(double larguraTela, double alturaTela) {
    return Container(
      height: alturaTela * 0.1,
      width: larguraTela * 0.1,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent[700],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      margin: EdgeInsets.only(left: larguraTela * 0.1),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text('Sobre', style: TextStyle(fontSize: larguraTela * 0.025,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
    );
  }
}
