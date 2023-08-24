import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

Widget formatDescription(String text) {
  List<String> formattedText;
  if (!text.contains(RegExp("<[a-zA-Z]>"))) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: fonteDaLetra,
        fontFamily: 'Mulish',
      ),
      // recognizer: TapGestureRecognizer()
      //   ..onTap = () {
      //     ;
      //   },
      // ),
    );
  } else {
    List<String> openingTagFormat = text.split(RegExp("<[a-zA-Z]>"));
    // print(openingTagFormat);
    formattedText = openingTagFormat[1].split(RegExp(r"<\/[a-zA-Z]>"));
    formattedText.insert(0, openingTagFormat[0]);
    // print(formattedText);

    return RichText(
      maxLines: 3,
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: formattedText[0],
        // text: widget.title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fonteDaLetra,
          fontFamily: 'Mulish',
        ),
        children: [
          TextSpan(
            text: formattedText[1],
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: formattedText[2],
          ),
        ],
        // recognizer: TapGestureRecognizer()
        //   ..onTap = () {
        //     playSound(cobjectList[0].descriptionSound);
        //   },
      ),
    );
  }
}
