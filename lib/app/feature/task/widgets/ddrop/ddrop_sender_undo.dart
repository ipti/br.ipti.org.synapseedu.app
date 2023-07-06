import 'package:elesson/share/question_widgets.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';

class DdropSenderUndo extends StatelessWidget {
  final Function callback;
  const DdropSenderUndo({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ()=> callback(),
      child: Container(
        child: FDottedLine(
          child: Container(
            width: size.width > size.height ? (size.width / 2.6) / 3 : size.width / 2.6,
            height: size.width > size.height ? (size.width / 2.6) / 3 : size.width / 2.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/undoIcon.png",
                  color: Color.fromRGBO(189, 0, 255, 0.4),
                ),
                Text(
                  'DESFAZER',
                  style: TextStyle(color: Color.fromRGBO(189, 0, 255, 0.4), fontWeight: FontWeight.bold, fontSize: fonteDaLetra),
                ),
              ],
            ),
          ),
          color: Color.fromRGBO(189, 0, 255, 0.4),
          strokeWidth: 4,
          corner: FDottedLineCorner.all(12),
          dottedLength: 6,
        ),
      ),
    );
  }
}
