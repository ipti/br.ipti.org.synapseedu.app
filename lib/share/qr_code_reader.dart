import 'dart:async';
import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/register/student_model.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'api.dart';
import 'elesson_icon_lib_icons.dart';
import 'my_twillio.dart';

class QrCodeReader extends StatefulWidget {
  static const routeName = '/qr_code';

  @override
  State<StatefulWidget> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  bool showLoading = false;
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TwilioPhoneVerify _twilioPhoneVerify;
  Timer _timer;

  Color colorToTimerOut = Colors.white;
  String textToTimeout = "APONTE PARA O CÓDIGO \nQR PRESENTE NO SEU KIT";

  void timerOut() {
    setState(() {
      colorToTimerOut = Colors.red;
      textToTimeout = "NÃO FOI POSSÍVEL \nVALIDAR O CÓGIGO QR";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer(Duration(seconds: 15), timerOut);
    // _twilioPhoneVerify = new TwilioPhoneVerify(
    //     // meu
    //     accountSid: 'ACadd1dd994d143f635b442de15481e1f7', // replace with Account SID
    //     authToken: 'fe9c3fa3784cd48017ca39f454bbc5bc', // replace with Auth Token
    //     serviceSid: 'VA7686722166b582b1a7ab42770b104097' // replace with Service SID
    //     );

    // _twilioPhoneVerify = new TwilioPhoneVerify( //elesson
    //     accountSid: 'AC7ad4a260cd8163d9ca9d957ff0dfebb7', // replace with Account SID
    //     authToken: '3389bb9152e13b4383cfc79538923c52', // replace with Auth Token
    //     serviceSid: 'A0041644482dcb11b671a45f2777da1ce' // replace with Service SID
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                height: heightScreen * 0.77,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.white,
                    borderRadius: 10,
                    borderWidth: 0,
                    cutOutSize: 200,
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Text(
                    textToTimeout,
                    style: TextStyle(
                        color: colorToTimerOut, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 24),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 2, color: Colors.white.withOpacity(0.4))),
              child: Icon(
                ElessonIconLib.chevron_left,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(
                top: heightScreen * 0.77 - 100, left: widthScreen / 2 - 50),
            child: showLoading == true ? loadingAnimation() : null,
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    TwilioPhoneVerify _twilioPhoneVerify = new TwilioPhoneVerify(
      accountSid: 'ACe0d07ac9688051efbe6eceada8411f56',
      authToken: 'ef2ba29203fece8499714387a1507fe9',
      serviceSid: 'VA3346e166d40a6d69309fac0f15440e6f',
    );
    // RegExp exp = new RegExp(r"([0-9])\d{10}");
    // RegExp exp = new RegExp(r"(\w{8}-\w{4}-\w{4}-\w{4}-\w{12})");
    //RegExp exp = new RegExp(r"(\w|-){36}");

    String studentUuid = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('heyu');
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print(scanData);
      // setState(() async{
      qrText = scanData;
      if (qrText != null) {
        setState(() {
          showLoading = !showLoading;
        });
        _timer.cancel();
        studentUuid = qrText;
        print(studentUuid);
        controller.dispose();

        loginQuery =
            await LoginQuery().searchStudent(true, studentUuid: studentUuid);

        if (loginQuery.valid != false) {
          print('UID:' + studentUuid);

          var discipline = ApiBlock.getDiscipline(loginQuery.actorAccess.id);

          // var responseBlock =
          //     await ApiBlock.getBlock(loginQuery.actorAccess.cobjectBlockId);

          // List<String> cobjectIdList = [];

          // int cobjectId = prefs.getInt('last_cobject_$discipline') ?? 0;

          // int questionIndex = prefs.getInt('last_question_$discipline') ?? 0;

          // responseBlock.data[0]["cobject"].forEach((cobject) {
          //   cobjectIdList.add(cobject["id"]);
          // });

          prefs.setBool('isConfirmed', true);
          prefs.setString('student_uuid', studentUuid);
          prefs.setString('student_name',
              loginQuery.student.name.split(" ")[0].toUpperCase());
          if (loginQuery.student.id != -1)
            prefs.setInt('student_id', loginQuery.student.id);
          if (loginQuery.student.phone.isNotEmpty)
            prefs.setString('student_phone', loginQuery.student.phone);
          if (loginQuery.student.actorId.isNotEmpty)
            prefs.setString('actor_id', loginQuery.student.actorId);
          if (loginQuery.actorAccess.actorAcessBlocks != null) {
            loginQuery.actorAccess.actorAcessBlocks.forEach((key, value) {
              prefs.setString('block_$key', value);
            });
          }

          // getCobject(cobjectId, context, cobjectIdList,
          //     piecesetIndex: questionIndex);

          Navigator.pushReplacementNamed(context, BlockSelection.routeName);
        } else {
          setState(() {
            showLoading = !showLoading;
            colorToTimerOut = Colors.red;
            textToTimeout = "NÃO FOI POSSÍVEL \nVALIDAR O CÓGIGO QR";
          });
        }

        // if (loginQuery.valid != false) {
        //   print('+55' + studentUuid);
        //   var result =
        //       await _twilioPhoneVerify.sendSmsCode('+55' + studentUuid);

        //   if (result['message'] == 'success') {
        //     // code sent
        //     print("Código enviado");
        //     Navigator.pushReplacementNamed(context, '/code-verify',
        //         arguments: loginQuery.student);
        //   } else {
        //     setState(() {
        //       showLoading = !showLoading;
        //       colorToTimerOut = Colors.red;
        //       textToTimeout = "NÃO FOI POSSÍVEL \nVALIDAR O CÓGIGO QR";
        //     });
        //     print("ERROR:");
        //     print('${result['statusCode']} : ${result['message']}');
        //   }
        // } else {
        //   setState(() {
        //     showLoading = !showLoading;
        //     colorToTimerOut = Colors.red;
        //     textToTimeout = "NÃO FOI POSSÍVEL \nVALIDAR O CÓGIGO QR";
        //   });
        // }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
