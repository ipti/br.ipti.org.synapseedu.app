import 'package:flutter/material.dart';
import 'package:elesson/login/widgets/caixa_login.dart';

class Right_Container extends StatelessWidget {
  final double larguraTela;
  final double alturaTela;

  const Right_Container(this.larguraTela, this.alturaTela);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: larguraTela * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Caixa_Login(larguraTela * 0.4),
        ],
      ),
    );
  }
}
