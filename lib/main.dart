import 'package:elesson/template_questoes/image_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'activity_selection/activity_selection_view.dart';
// import 'login/login_view.dart';
// import 'recover_password/recover_password_view.dart';
// import 'register/register_view.dart';
// import 'webview/base.dart';
// import 'webview/models/webview_modelo.dart';

import './template_questoes/text.dart';
import './template_questoes/multichoice.dart';
import './template_questoes/drag_and_drop.dart';
import './template_questoes/question_and_answer.dart';
import './login/login_view.dart';

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

class Home extends StatelessWidget {
  var questionType;
  var cobject = new List<dynamic>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elesson',
      theme: ThemeData(
        // brightness: Brightness.light,
        // backgroundColor: Colors.white,
        primarySwatch: Colors.lightGreen,
        accentColor: Color(0xFF0000FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            // side: BorderSide(color: Color(0x3300004C), width: 1),
            side: BorderSide(color: Color(0xFF00004C), width: 1),
          ),
          splashColor: Colors.amber[900],
          // minWidth: 120,
          minWidth: 0,
          hoverColor: Colors.red,
        ),
        // primaryTextTheme: GoogleFonts.muliTextTheme(),
        // primaryTextTheme: GoogleFonts.robotoCondensedTextTheme(),
        // textTheme: ThemeData.light().textTheme.copyWith(
        //       headline2: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 36,
        //       ),
        //     ),
        fontFamily: 'Mulish',
        textTheme: GoogleFonts.muliTextTheme(),
      ),
      //home: ActivitySelectionForm(),
      initialRoute: '/',
      routes: {
        '/': (context) => ActivitySelectionForm(),
        SingleLineTextQuestion.routeName: (context) => SingleLineTextQuestion(),
        DragAndDrop.routeName: (context) => DragAndDrop(),
        MultipleChoiceQuestion.routeName: (context) => MultipleChoiceQuestion(),
        TextQuestion.routeName: (context) => TextQuestion(),
        ImageDetailScreen.routeName: (context) => ImageDetailScreen(),
      },
    );
  }
}
