import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'elesson_icon_lib_icons.dart';
import 'global_variables.dart';

Widget elessonCard(
    {required String backgroundImage,
    required String text,
    double? screenWidth,
    Function? onTap,
    BuildContext? context,
    bool? blockDone}) {
  return GestureDetector(
    onTap: () {
      Future<String>? retorno = onTap!(context);
    },
    child: Container(
      margin: EdgeInsets.all(2),
      height: 166,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          // side: BorderSide(
          //   width: blockDone ? 4 : 0,
          //   color: Color.fromRGBO(0, 220, 140, 0.4),
          // ),
        ),
        elevation: 5,
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Stack(
          children: [
            Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
              width: screenWidth,
            ),
            Container(
              height: 166.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color(0XFFFFFFFF).withOpacity(0),
                    Color(0XFF0000FF).withOpacity(0.4),
                    //Colors.black,
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 18, right: 18, top: 105),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "ElessonIconLib"),
                  ),
                  Icon(
                    ElessonIconLib.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget loadingAnimation() {
  return Container(
    height: 100,
    width: 100,
    // child: Lottie.asset(
    //   'assets/animations/loading.json',
    //   width: 100,
    //   height: 100,
    //   fit: BoxFit.fill,
    // ),
  );
}

