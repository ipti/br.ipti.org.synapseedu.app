import 'package:flutter/material.dart';

Widget bottomNavBar(BuildContext context) {
  return BottomAppBar(
    // color: Color.fromRGBO(255, 255, 255, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: OutlineButton(
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
              color: Color(0xFF0000FF),
            ),
            onPressed: () => {
              Navigator.of(context).pop(),
            },
          ),
        ),
        if (false == false)
          OutlineButton(
            borderSide: BorderSide(
              color: Color(0xFF00DC8C),
            ),
            color: Colors.white,
            textColor: Color(0xFF00DC8C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            onPressed: () => {
              Navigator.of(context).pop(),
            },
          ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: OutlineButton(
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
                    Icons.settings,
                    color: Color(0xFF0000FF),
                  ),
            onPressed: () => {
              // Navigator.of(context).pop(),
            },
          ),
        ),
      ],
    ),
  );
}
