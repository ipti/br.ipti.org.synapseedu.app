import 'package:flutter/material.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class SmsRegisterView extends StatefulWidget {
  static const routeName = '/sms-register';
  @override
  _SmsRegisterViewState createState() => _SmsRegisterViewState();
}

class _SmsRegisterViewState extends State<SmsRegisterView> {
  final _phoneNumberController = TextEditingController();

  //CRIAR TEXTCONTROLLERS PARA CADA ENTRADA

  String colegioValue;
  String serieValue;

  TwilioPhoneVerify _twilioPhoneVerify;
  //TwilioFlutter twilioFlutter;

  @override
  void initState() {
    // TODO: implement initState
    _twilioPhoneVerify = new TwilioPhoneVerify( // meu
        accountSid: 'ACadd1dd994d143f635b442de15481e1f7', // replace with Account SID
        authToken: 'fe9c3fa3784cd48017ca39f454bbc5bc', // replace with Auth Token
        serviceSid: 'VA7686722166b582b1a7ab42770b104097' // replace with Service SID
    );

    // _twilioPhoneVerify = new TwilioPhoneVerify( //elesson
    //     accountSid: 'AC7ad4a260cd8163d9ca9d957ff0dfebb7', // replace with Account SID
    //     authToken: '3389bb9152e13b4383cfc79538923c52', // replace with Auth Token
    //     serviceSid: 'A0041644482dcb11b671a45f2777da1ce' // replace with Service SID
    // );
    super.initState();
  }

  Future<void> sendCode(String phoneNumber) async {
    var result = await _twilioPhoneVerify.sendSmsCode(phoneNumber);

    if (result['message'] == 'success') {
      // code sent
      print("Código enviado");
    } else {
      // error
      print("ERROR:");
      print('${result['statusCode']} : ${result['message']}');
    }
  }

  Future<void> verifyCode(String phoneNumber, String code) async {
    var result = await _twilioPhoneVerify.verifySmsCode(phoneNumber, code);

    if (result['message'] == 'approved') {
      // phone number verified
      print("Verificado com sucesso");
    } else {
      // error
      print("ERROR:");
      print('${result['statusCode']} : ${result['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            logo(),
            inputWidget(_phoneNumberController, 'Exemplo: 79987651234'),
            if (_phoneNumberController.text.length == 1)
              registerButton(widthScreen, heightScreen),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Image(
        image: NetworkImage(
            'https://avatars2.githubusercontent.com/u/64334312?s=200&v=4',
            scale: 0.7),
      ),
    );
  }

  Widget registerButton(double widthScreen, double heightScreen) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: widthScreen * 0.5,
      height: heightScreen * 0.08,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: MaterialButton(
        onPressed: () {
          //função de envio do sms e checagem
        },
        child: Center(
          child: Text(
            'CADASTRAR!',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }

  //<====parametros(controller , texto inicial)====>
  Widget inputWidget(TextEditingController controller, String hintText) {
    return Container(
      child: TextFormField(
        maxLength: 11,
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: "Número de telefone",
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 20),
        ),
        validator: (value) {
          if (value.length < 11) {
            return "Entre um número válido";
          }
          return null;
        },
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.green,
            width: 5,
          )),
    );
  }
}
