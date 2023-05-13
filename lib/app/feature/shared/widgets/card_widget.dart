import 'package:elesson/share/elesson_icon_lib_icons.dart';
import 'package:flutter/material.dart';

class ElessonCardWidget extends StatelessWidget {
  bool? blockDone;
  String? backgroundImage;
  Function? onTap;
  double? screenWidth;
  String? text;
  String textModulo;
  BuildContext? context;

  ElessonCardWidget({Key? key, this.blockDone, this.backgroundImage, this.onTap, this.screenWidth, this.text, this.textModulo = '', this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Container(
                height: 166.0,
                child: Image.asset(
                  backgroundImage!,
                  fit: BoxFit.cover,
                  width: screenWidth,
                ),
              ),
              !blockDone!
                  ? Container(
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
              )
                  : Container(
                height: 166.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text!,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib"),
                        ),
                        Text(
                          textModulo,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.7),
                alignment: Alignment.centerRight,
                child: Center(
                  child: Icon(
                    ElessonIconLib.chevron_right,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
