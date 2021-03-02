import 'dart:async';

import 'package:elesson/register/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import '../share/header_widget.dart';

/**
 * * Tela de inserção do número de celular para o recebimento do pin de acesso ao aplicativo.
 * ? O envio do SMS é feito usando a API do Twilio.
 */

TwilioPhoneVerify _twilioPhoneVerify;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
Student student;
StudentQuery studentQuery;

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    print('$screenWidth and $screenHeight');

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
                style: TextStyle(fontSize: screenHeight < 823 ? 16 : 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inputWidget(_phoneNumberController, 'Ex: 79987651234',
                      screenWidth, screenHeight),
                  ButtonTheme(
                    minWidth: screenHeight < 823 ? 48 : 64,
                    height: screenHeight < 823 ? 48 : 64,
                    child: OutlineButton(
                      padding: const EdgeInsets.all(0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(0, 0, 255, 0.2),
                      ),
                      color: Colors.white,
                      textColor: const Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: ImageIcon(
                        AssetImage("assets/icons/chevron_right.png"),
                      ),
                      onPressed: () async {
                        // student = await Student().searchForStudent();
                        studentQuery = await StudentQuery().searchStudent();
                        if (studentQuery.valid == true) print("true");
                        if (_phoneNumberController.text.length == 11 &&
                            student != null) {
                          sendCode(
                              _phoneNumberController.text);
                          Navigator.popAndPushNamed(context, '/code-verify',
                              arguments: _phoneNumberController.text);
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
        child: MaterialButton(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          textColor: const Color(0xFF00DC8C),
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

            // sendCode(_phoneNumberController.text, _twilioPhoneVerify);
            // Navigator.popAndPushNamed(context, '/code-verify',
            //     arguments: _phoneNumberController.text);
          },
        ),
      ),
    );
  }

  //<====parametros(controller , texto inicial)====>
  Widget inputWidget(TextEditingController phoneNumberController,
      String hintText, double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight < 823 ? 48 : 70,
      width: (303 / 411) * screenWidth,
      // color: Colors.greenAccent[400],
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(
            color: const Color.fromRGBO(0, 0, 76, 1),
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
              borderSide: const BorderSide(
                color: Color.fromRGBO(0, 0, 255, 0.4),
                // color: Colors.greenAccent[400],
                // width: 5.0,
              ),
            ),
            // prefixIcon: Icon(Icons.phone),
            // labelText: "Número de celular",
            labelStyle: const TextStyle(fontSize: 24, color: Colors.black),
            // border: InputBorder,
            // hintText: hintText,
            hintStyle: const TextStyle(fontSize: 20),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: const Color.fromRGBO(0, 0, 255, 0.4),
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
