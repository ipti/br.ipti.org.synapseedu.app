import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/degree_selection/degree_selection_view.dart';
import 'package:elesson/register/code_verify_view.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/block_conclusion.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/PRE_SOM_IA.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './register/countdown.dart';
import 'admin/admin_page.dart';
import 'init_pages/space_selection.dart';
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
import 'webview/headless_webview.dart';
import 'template_questoes/text_question.dart';
import 'template_questoes/multiple_choice.dart';
import 'template_questoes/ddrop/ddrop.dart';
import 'template_questoes/pre_base.dart';
import './login/auto_login.dart';

void main() async {
  //usando pra iniciar em outra tela
  //Força o modo retrato na inicialização do aplicativo

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    isLogged = await isUserConfirmed();
    runApp(ProviderScope(child: new Home()));
  });

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
  var questionType;

  var cobject = new List<dynamic>();

  Future<bool> isUserConfirmed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    isLogged = prefs.getBool('isConfirmed') ?? false;
    isAdmin = prefs.getBool('admin') ?? false;
    // });
  }

  @override
  // isUserConfirmed();
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elesson',
      theme: ThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        primarySwatch: Colors.lightGreen,
        accentColor: Color(0xFF0000FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Color(0xFF00004C), width: 1),
          ),
          // splashColor: Colors.amber[900],
          minWidth: 0,
          // hoverColor: Colors.red,
        ),
        primaryTextTheme: GoogleFonts.muliTextTheme(),
        fontFamily: 'Mulish',
        textTheme: GoogleFonts.muliTextTheme(),
      ),
      initialRoute: isLogged && isAdmin
          ? '/admin'
          : isLogged
              ? '/'
              : SpaceSelection.routeName,
      // initialRoute: BlockSelection.routeName,
      // initialRoute: SettingsScreen.routeName,
      // initialRoute: isLogged ? '/' : SmsRegisterView.routeName,
      // initialRoute: isLogged ? '/' : ActivitySelectionForm.routeName, // alterado para apresentação
      routes: {
        '/': (context) => BlockSelection(),
        '/admin': (context) => AdminPage(),
        SpaceSelection.routeName: (context) => SpaceSelection(),
        DegreeSelectionView.routeName: (context) => DegreeSelectionView(),
        BlockSelection.routeName: (context) => BlockSelection(),
        CountDownTimer.routeName: (context) => CountDownTimer(),
        RootPage.routeName: (context) => RootPage(),
        SmsRegisterView.routeName: (context) => SmsRegisterView(),
        CodeVerifyView.routeName: (context) => CodeVerifyView(),
        HeadlessWebView.routeName: (context) => HeadlessWebView(),
        PreImgIa.routeName: (context) => PreImgIa(),
        PreSomIa.routeName: (context) => PreSomIa(),
        // PreSomIa.routeName: (context) => PreSomIa(),
        //----------------------------rotas fora de fluxo---------------------------
        ActivitySelectionForm.routeName: (context) => ActivitySelectionForm(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        SingleLineTextQuestion.routeName: (context) => SingleLineTextQuestion(),
        DragAndDrop.routeName: (context) => DragAndDrop(),
        MultipleChoiceQuestion.routeName: (context) => MultipleChoiceQuestion(),
        TextQuestion.routeName: (context) => TextQuestion(),
        ImageDetailScreen.routeName: (context) => ImageDetailScreen(),
        BlockConclusionScreen.routeName: (context) => BlockConclusionScreen(),
        QrCodeReader.routeName: (context) => QrCodeReader(),
      },
    );
  }
}
