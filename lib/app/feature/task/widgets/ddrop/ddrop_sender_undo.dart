import 'dart:math';

import 'package:elesson/share/question_widgets.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';

class DdropSenderUndo extends StatelessWidget {
  final Function callback;
  const DdropSenderUndo({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isHorizontal = size.width > size.height;
    double heightWidth = 200;
    double horizontalWidth = size.width / 2;
    if (isHorizontal) {
      heightWidth = horizontalWidth / 2.5;
    } else {
      heightWidth = size.width / 3;
    }
    heightWidth = min(size.height/3.5 , heightWidth);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ()=> callback(),
      child: Container(
        child: FDottedLine(
          child: Container(
            width:heightWidth,
            height: heightWidth,
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
