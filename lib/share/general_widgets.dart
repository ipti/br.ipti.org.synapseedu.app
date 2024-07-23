import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'elesson_icon_lib_icons.dart';

Widget elessonCard({required String backgroundImage, required String text, double? screenWidth, Function? onTap, BuildContext? context, bool? blockDone, bool showLoading = false}) {
  return GestureDetector(
    onTap: () {
      Future<void> retorno = onTap!(context);
    },
    child: Container(
      margin: EdgeInsets.all(2),
      height: 166,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36.0)),
        elevation: 5,
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Stack(
          children: [
            Image.asset(backgroundImage, fit: BoxFit.cover, width: screenWidth),
            Container(
              height: 166.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [Color(0XFFFFFFFF).withOpacity(0), Color(0XFF0000FF).withOpacity(0.4)],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 18, right: 18, top: 105),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib")),
                  Icon(ElessonIconLib.chevron_right, color: Colors.white),
                ],
              ),
            ),
            if(showLoading) Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(36.0), color: Colors.grey.withOpacity(0.5)),
                height: 145,
                width: screenWidth,
                child: loadingAnimation(),
              ),
            ),
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
    child: Lottie.asset(
      'assets/animations/loading.json',
      width: 100,
      height: 100,
      fit: BoxFit.scaleDown,
    ),
  );
}
