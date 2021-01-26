import 'package:elesson/register/code_verify_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './register/countdown.dart';

import './init_pages/spaceSelection.dart';

import 'package:elesson/root/start_and_send_test.dart';

import './root/poc.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/template_questoes/share/image_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import './register/sms_register.dart';

import 'activity_selection/activity_selection_view.dart';
// import 'login/login_view.dart';
// import 'recover_password/recover_password_view.dart';
// import 'register/register_view.dart';
// import 'webview/base.dart';
// import 'webview/models/webview_modelo.dart';
import 'webview/headless_webview.dart';

import 'template_questoes/text_question.dart';
import 'template_questoes/multiple_choice.dart';
import 'template_questoes/ddrop/ddrop.dart';
import './template_questoes/question_and_answer.dart';

import './login/auto_login.dart';

void main() async {
  //usando pra iniciar em outra tela
  //Força o modo retrato na inicialização do aplicativo
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(ProviderScope(child: new Home())));

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  //WidgetsFlutterBinding.ensureInitialized();
  // Pedindo permissões para o usuário
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();
  //
  // //força ficar na horizontal
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
  //     .then((_) {
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (context) => WebViewModel(),
  //       ),
  //       ChangeNotifierProxyProvider<WebViewModel, BaseModel>(
  //         update: (context, webViewModel, browserModel) {
  //           return browserModel;
  //         },
  //         create: (BuildContext context) => BaseModel(null),
  //       ),
  //     ],
  //     child: Home(),
  //   ),
  // );
  // });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogged = false;
  var questionType;

  var cobject = new List<dynamic>();

  Future<bool> isUserConfirmed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogged = prefs.getBool('isConfirmed') ?? false;
    });
  }

  @override
  // isUserConfirmed();
  bool isChecked = false;
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    if (isChecked == false) {
      isUserConfirmed();
      isChecked = true;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elesson',
      theme: ThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        primarySwatch: Colors.lightGreen,
        accentColor: Color(0xFF0000FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Color(0xFF00004C), width: 1),
          ),
          // splashColor: Colors.amber[900],
          minWidth: 0,
          // hoverColor: Colors.red,
        ),
        fontFamily: 'Mulish',
        textTheme: GoogleFonts.muliTextTheme(),
      ),
      // initialRoute: '/',
      // initialRoute: ActivitySelectionForm.routeName,
      initialRoute: isLogged ? '/' : SmsRegisterView.routeName,
      // initialRoute: isLogged ? '/' : ActivitySelectionForm.routeName, // alterado para apresentação
      // initialRoute: HeadlessWebView.routeName,
      routes: {
        '/': (context) => SpaceSelection(),
        CountDownTimer.routeName: (context) => CountDownTimer(),
        RootPage.routeName: (context) => RootPage(),
        StartAndSendTest.routeName: (context) => StartAndSendTest(),
        SmsRegisterView.routeName: (context) => SmsRegisterView(),
        CodeVerifyView.routeName: (context) => CodeVerifyView(),
        HeadlessWebView.routeName: (context) => HeadlessWebView(),
        //----------------------------rotas fora de fluxo---------------------------
        ActivitySelectionForm.routeName: (context) => ActivitySelectionForm(),
        SingleLineTextQuestion.routeName: (context) => SingleLineTextQuestion(),
        DragAndDrop.routeName: (context) => DragAndDrop(),
        MultipleChoiceQuestion.routeName: (context) => MultipleChoiceQuestion(),
        TextQuestion.routeName: (context) => TextQuestion(),
        ImageDetailScreen.routeName: (context) => ImageDetailScreen(),
      },
    );
  }
}
