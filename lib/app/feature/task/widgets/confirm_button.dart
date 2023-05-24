import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatelessWidget {
  ConfirmButtonWidget({Key? key}) : super(key: key);

  String confirmButtonText = 'CONFIRMAR';
  bool confirmButtonBorder = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        elevation: 0,padding: EdgeInsets.symmetric(horizontal: 12),
        height: double.maxFinite,
        // color: confirmButtonColor ? Color.fromRGBO(0, 220, 140, confirmButtonBackgroundOpacity) : Color.fromRGBO(255, 51, 0, confirmButtonBackgroundOpacity),
        textColor: Color.fromRGBO(0, 220, 140, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: confirmButtonBorder ? Color.fromRGBO(0, 220, 140, 1) : Color.fromRGBO(255, 51, 0, 1),
          ),
        ),
        child: Text(
          confirmButtonText,
          style: TextStyle(
            color: confirmButtonBorder ? Color.fromRGBO(0, 220, 140, 1) : Color.fromRGBO(255, 51, 0, 1),
            fontWeight: FontWeight.w900,
            // fontSize: fonteDaLetra,
            fontSize: 16,
          ),
        ),

        onPressed: () {
        },
      ),
    );
  }
}
