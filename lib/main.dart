import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'login/login_view.dart';
import 'register/register_view.dart';
import 'template_questoes/share/template_slider.dart';
import 'webview/base.dart';
import 'webview/models/webview_modelo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'template_questoes/text_question.dart';
import 'template_questoes/multiple_choice.dart';

void main() async {
  //usando pra iniciar em outra tela
  //Força o modo retrato na inicialização do aplicativo
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(ProviderScope(child: new Home())));

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
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elesson',
      theme: ThemeData(
        // brightness: Brightness.light,
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          splashColor: Colors.orange,
          minWidth: 120,
          hoverColor: Colors.red,
        ),
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline2: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
      ),
      // home: MultipleChoiceQuestion(),
      home: LoginView(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => Base(),
      // },
    );
  }
}
