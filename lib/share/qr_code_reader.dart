import 'dart:async';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'elesson_icon_lib_icons.dart';

class QrCodeReader extends StatefulWidget {
  const QrCodeReader({Key key}) : super(key: key);

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
    _twilioPhoneVerify = new TwilioPhoneVerify(
        // meu
        accountSid:
            'ACadd1dd994d143f635b442de15481e1f7', // replace with Account SID
        authToken:
            'fe9c3fa3784cd48017ca39f454bbc5bc', // replace with Auth Token
        serviceSid:
            'VA7686722166b582b1a7ab42770b104097' // replace with Service SID
        );

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

  void _onQRViewCreated(QRViewController controller) {
    RegExp exp = new RegExp(r"([0-9])\d{10}");
    String number = "";

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        print("exibindo loading");
        qrText = scanData;
        showLoading = !showLoading;
        if (exp.hasMatch(qrText)) {
          number = exp.stringMatch(qrText);
          print(number);
          controller.dispose();
          showLoading = false;
          sendCode(number, _twilioPhoneVerify);
          _timer.cancel();
          Navigator.pushReplacementNamed(context, '/code-verify',
              arguments: number);
        }
      });
      // setState(() {
      //   // qrText = scanData;
      //   // controller.dispose();
      //   //todo implementar aqui o que vai acontecer depois de receber os dados do qrcode

      //   //Navigator.pop(context, qrText);
      //   //Navigator.of(context).pushReplacementNamed(StartAndSendTest.routeName);
      // });
      // print(qrText);
      // if (exp.hasMatch(qrText)) {
      //   number = exp.stringMatch(qrText);
      //   print(number);
      // }
      // else
      //   textToTimeout =
      //       "Não conseguimos ler o seu Q";
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
