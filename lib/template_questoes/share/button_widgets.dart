import 'package:flutter/material.dart';

Widget bottomNavigationBar(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;

  return BottomAppBar(
    // color: Color.fromRGBO(255, 255, 255, 0),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonTheme(
            minWidth: buttonHeight,
            height: buttonHeight,
            child: OutlineButton(
              padding: EdgeInsets.all(8),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
              color: Colors.white,
              textColor: Color(0xFF0000FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                Icons.settings,
                size: 32,
                color: Color(0xFF0000FF),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
              },
            ),
          ),
          if (false == false)
            ButtonTheme(
              minWidth: 259,
              height: buttonHeight,
              child: OutlineButton(
                padding: EdgeInsets.all(8),
                borderSide: BorderSide(
                  color: Color(0xFF00DC8C),
                ),
                color: Colors.white,
                textColor: Color(0xFF00DC8C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
              ),
            ),
          ButtonTheme(
            minWidth: buttonHeight,
            height: buttonHeight,
            child: OutlineButton(
              padding: EdgeInsets.all(0),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
              color: Colors.white,
              textColor: Color(0xFF0000FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: true != true
                  ? Row(
                      children: [
                        Text(
                          'VER MAIS',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    )
                  : Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(0xFF0000FF),
                      size: 40,
                    ),
              onPressed: () => {
                // Navigator.of(context).pop(),
              },
            ),
          ),
        ],
      ),
    ),
  );
}
