import 'dart:async';

import './sms_register.dart';
import '../share/question_widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import '../share/header_widget.dart';

/**
 * * Tela de verificação de pin que aparece após o envio do número de celular.
 * ? A verificação é feita através da api do Twilio.
 */

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

  TwilioPhoneVerify _twilioPhoneVerify;

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
    double screenWidth = MediaQuery.of(context).size.width;

    print(_phoneNumber);

    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            header(screenHeight, "Código verificador"),
            const SizedBox(height: 42),
            Text(
              'Insira o código enviado por SMS',
              style: TextStyle(fontSize: screenHeight < 823 ? 16 : 28),
            ),
            const SizedBox(height: 24),
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
                    inactiveColor: const Color.fromRGBO(0, 0, 255, 0.4),
                    shape: PinCodeFieldShape.box,
                    fieldHeight: screenHeight < 823 ? 48 : 72,
                    fieldWidth: screenHeight < 823 ? 48 : 72,
                    borderRadius: BorderRadius.circular(18.0),
                    activeFillColor: hasError ? Colors.orange : Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  textStyle: const TextStyle(fontSize: 20, height: 1.6),
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
            if (screenHeight > 822) const SizedBox(height: 12),
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
                        color: const Color.fromRGBO(0, 0, 255, 1),
                        fontWeight: FontWeight.w800,
                        fontSize: screenHeight < 823 ? 12 : 22,
                      ),
                    ),
                  )
                : AnimatedBuilder(
                    animation: countdownAnimationController,
                    builder: (context, child) {
                      return RichText(
                        text: TextSpan(
                            text: "Reenviar código ",
                            style: TextStyle(
                              color: const Color.fromRGBO(110, 114, 145, 0.4),
                              fontSize: fonteDaLetra,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: timerString,
                                style: const TextStyle(
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
