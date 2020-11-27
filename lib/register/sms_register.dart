import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import '../share/question_widgets.dart';
// import 'package:pinput/pin_put/pin_put.dart';
// import 'package:pinput/pin_put/pin_put_state.dart';

TwilioPhoneVerify _twilioPhoneVerify;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Widget header(double screenHeight, String headerText) {
  double headerHeight = (88 / 731) * screenHeight;
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color.fromRGBO(0, 0, 76, 0.1),
          width: 1,
        ),
      ),
    ),
    height: headerHeight,
    child: Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        headerText,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(
            0,
            0,
            76,
            1,
          ),
        ),
      ),
    ),
  );
}

Future<void> sendCode(String phoneNumber) async {
  var result = await _twilioPhoneVerify.sendSmsCode('+55' + phoneNumber);

  if (result['message'] == 'success') {
    // code sent
    print("Código enviado");
  } else {
    // error
    print("ERROR:");
    print('${result['statusCode']} : ${result['message']}');
  }
}

class SmsRegisterView extends StatefulWidget {
  static const routeName = '/sms-register';
  @override
  _SmsRegisterViewState createState() => _SmsRegisterViewState();
}

class _SmsRegisterViewState extends State<SmsRegisterView> {
  final _phoneNumberController = TextEditingController();
  String phoneNumber;

  //CRIAR TEXTCONTROLLERS PARA CADA ENTRADA

  //TwilioFlutter twilioFlutter;

  @override
  void initState() {
    // TODO: implement initState
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

  // Future<void> sendCode(String phoneNumber) async {
  //   var result = await _twilioPhoneVerify.sendSmsCode('+55' + phoneNumber);

  //   if (result['message'] == 'success') {
  //     // code sent
  //     print("Código enviado");
  //   } else {
  //     // error
  //     print("ERROR:");
  //     print('${result['statusCode']} : ${result['message']}');
  //   }
  // }

  // Future<void> verifyCode(String phoneNumber, String code) async {
  //   var result = await _twilioPhoneVerify.verifySmsCode(phoneNumber, code);

  //   if (result['message'] == 'approved') {
  //     // phone number verified
  //     print("Verificado com sucesso");
  //   } else {
  //     // error
  //     print("ERROR:");
  //     print('${result['statusCode']} : ${result['message']}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            header(screenHeight, "Autenticar"),
            // SizedBox(
            //   height: 42,
            // ),
            Container(
              margin: EdgeInsets.only(top: 42, bottom: 24),
              child: Text(
                'Insira o número de celular do responsável',
                // textScaleFactor: 1.2,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inputWidget(
                      _phoneNumberController, 'Ex: 79987651234', screenWidth),
                  ButtonTheme(
                    minWidth: (48 / 411) * screenWidth,
                    height: (48 / 411) * screenWidth,
                    child: OutlineButton(
                      padding: EdgeInsets.all(0),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 255, 0.2),
                      ),
                      color: Colors.white,
                      textColor: Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: ImageIcon(
                        AssetImage("assets/icons/chevron_right.png"),
                      ),
                      //     Icon(
                      //   Icons.chevron_right,
                      //   size: 48,
                      //   color: Color(0xFF0000FF),
                      // ),
                      onPressed: () => {
                        if (_phoneNumberController.text.length == 11)
                          {
                            sendCode(_phoneNumberController.text),
                            Navigator.popAndPushNamed(context, '/code-verify',
                                arguments: _phoneNumberController.text),
                          }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // registerButton(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  // Widget logo() {
  //   return Container(
  //     margin: EdgeInsets.all(20),
  //     child: Image(
  //       image: NetworkImage(
  //           'https://avatars2.githubusercontent.com/u/64334312?s=200&v=4',
  //           scale: 0.7),
  //     ),
  //   );
  // }

  Widget registerButton(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: screenWidth * 0.5,
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.greenAccent[400],
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(width: 4),
      ),
      child: ButtonTheme(
        // minWidth: minButtonWidth,
        // height: buttonHeight,
        child: MaterialButton(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          textColor: Color(0xFF00DC8C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Color(0xFF00DC8C),
            ),
          ),
          child: Text(
            'CONFIRMAR',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          onPressed: () {
            //função de envio do sms e checagem
            sendCode(_phoneNumberController.text);
            Navigator.popAndPushNamed(context, '/code-verify',
                arguments: _phoneNumberController.text);
          },
        ),
      ),
    );
  }

  //<====parametros(controller , texto inicial)====>
  Widget inputWidget(TextEditingController phoneNumberController,
      String hintText, double screenWidth) {
    return Container(
      height: 48,
      width: (303 / 411) * screenWidth,
      // color: Colors.greenAccent[400],
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 76, 1),
            height: 1,
            fontWeight: FontWeight.w700,
          ),
          validator: (value) =>
              value.length < 11 ? "Entre um número válido" : null,
          onChanged: (value) {
            setState(() {
              phoneNumber = value;
            });
          },
          onSaved: (value) => phoneNumber = value,
          maxLengthEnforced: true,
          maxLength: 11,
          controller: phoneNumberController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 0.4),
                // color: Colors.greenAccent[400],
                // width: 5.0,
              ),
            ),
            // prefixIcon: Icon(Icons.phone),
            // labelText: "Número de celular",
            labelStyle: TextStyle(fontSize: 24, color: Colors.black),
            // border: InputBorder,
            // hintText: hintText,
            hintStyle: TextStyle(fontSize: 20),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 0.4),
                // color: Colors.greenAccent[400],
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                // color: Colors.greenAccent[400],
                width: 1.0,
              ),
            ),
          ),
        ),
      ),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
    );
  }
}

class CodeVerifyView extends StatefulWidget {
  static const routeName = "/code-verify";
  @override
  _CodeVerifyViewState createState() => _CodeVerifyViewState();
}

class _CodeVerifyViewState extends State<CodeVerifyView>
    with TickerProviderStateMixin {
  String _code;
  StreamController<ErrorAnimationType> errorController;
  TextEditingController _pinCodeController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  bool hasError = false;
  bool resendCode = false;

  AnimationController countdownAnimationController;

  String get timerString {
    Duration duration = countdownAnimationController.duration *
        countdownAnimationController.value;
    return duration.inSeconds < 10
        ? '${((duration.inSeconds % 60) + 1).toString().padLeft(1, '0')}'
        : '${((duration.inSeconds % 60) + 1).toString().padLeft(2, '0')}';
  }

  void initState() {
    // TODO: implement initState
    _twilioPhoneVerify = new TwilioPhoneVerify(
        // meu
        accountSid:
            'ACadd1dd994d143f635b442de15481e1f7', // replace with Account SID
        authToken:
            'fe9c3fa3784cd48017ca39f454bbc5bc', // replace with Auth Token
        serviceSid:
            'VA7686722166b582b1a7ab42770b104097' // replace with Service SID
        );

    countdownAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    countdownLogic();
    // _twilioPhoneVerify = new TwilioPhoneVerify( //elesson
    //     accountSid: 'AC7ad4a260cd8163d9ca9d957ff0dfebb7', // replace with Account SID
    //     authToken: '3389bb9152e13b4383cfc79538923c52', // replace with Auth Token
    //     serviceSid: 'A0041644482dcb11b671a45f2777da1ce' // replace with Service SID
    // );
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  void countdownLogic() {
    countdownAnimationController
        .reverse(
            from: countdownAnimationController.value == 0.0
                ? 1.0
                : countdownAnimationController.value)
        .whenComplete(() => setState(() {
              resendCode = true;
            }));
  }

  Future<void> verifyCode(String phoneNumber, String code) async {
    var result = await _twilioPhoneVerify.verifySmsCode(phoneNumber, code);
    print("Enviado $code");

    if (result['message'] == 'approved') {
      // phone number verified
      print("Verificado com sucesso");
      Navigator.of(context).popAndPushNamed('/');
    } else {
      // error
      print("ERROR:");
      print('${result['statusCode']} : ${result['message']}');
    }
  }

  String currentText = "";
  GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    // String _phoneNumber = ModalRoute.of(context).settings.arguments;
    String _phoneNumber = '79991210650';
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight =
        48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    double minButtonWidth = MediaQuery.of(context).size.width < 411 ? 180 : 259;

    print(_phoneNumber);
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            header(screenHeight, "Código verificador"),
            SizedBox(height: 42),
            Text('Insira o código enviado por SMS'),
            SizedBox(height: 24),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30, right: 30),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  // validator: (v) {
                  //   if (v.length < 3) {
                  //     return "I'm from validator";
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  pinTheme: PinTheme(
                    activeColor: hasError
                        ? Colors.redAccent
                        : Color.fromRGBO(0, 0, 255, 0.4),
                    inactiveColor: Color.fromRGBO(0, 0, 255, 0.4),
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 60,
                    fieldWidth: 50,
                    borderRadius: BorderRadius.circular(18.0),
                    activeFillColor: hasError ? Colors.orange : Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(fontSize: 20, height: 1.6),
                  backgroundColor: Colors.grey[50],
                  // enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: _pinCodeController,
                  keyboardType: TextInputType.number,
                  // boxShadows: [
                  //   BoxShadow(
                  //     offset: Offset(0, 1),
                  //     color: Colors.black12,
                  //     blurRadius: 10,
                  //   )
                  // ],
                  onCompleted: (v) {
                    print("Completed. Code: ${_pinCodeController.text}");
                    verifyCode("+55" + _phoneNumber, _pinCodeController.text);
                    setState(() {
                      hasError = true;
                    });
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      hasError = false;
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
            ),
            resendCode == true
                ? RichText(
                    text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          sendCode(_phoneNumber);
                          setState(() {
                            resendCode = false;
                          });
                          countdownLogic();
                        },
                      text: "Reenviar código",
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 255, 1),
                          fontWeight: FontWeight.w800),
                    ),
                  )
                : AnimatedBuilder(
                    animation: countdownAnimationController,
                    builder: (context, child) {
                      return RichText(
                        text: TextSpan(
                            text: "Reenviar código ",
                            style: TextStyle(
                              color: Color.fromRGBO(110, 114, 145, 0.4),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: timerString,
                                style: TextStyle(
                                  color: Color.fromRGBO(110, 114, 145, 0.4),
                                ),
                              ),
                            ]),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
