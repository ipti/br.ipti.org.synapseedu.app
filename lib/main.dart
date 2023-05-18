import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/degree_selection/degree_selection_view.dart';
import 'package:elesson/register/code_verify_view.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/block_conclusion.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/PRE_SOM_IA.dart';
import 'package:provider/provider.dart';
import './register/countdown.dart';
import 'app/core/auth/data/model/user_model.dart';
import 'app/feature/auth/auth_module.dart';
import 'app/feature/task/task_module.dart';
import 'app/providers/userProvider.dart';
import 'init_pages/space_selection.dart';
import './root/poc.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/template_questoes/share/image_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Elesson',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Mulish',
            backgroundColor: Color(0xFFFFFFFF),
            primarySwatch: Colors.lightGreen,
            accentColor: Color(0xFF0000FF),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Color(0xFF00004C), width: 1)),
              minWidth: 0,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => VerifyLogin(),
            AuthModule.routeName: (context) => AuthModule(),
            TaskModule.routeName: (context) => TaskModule(),
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
        ),
      ),
    );
  });

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

class VerifyLogin extends StatefulWidget {
  const VerifyLogin({Key? key}) : super(key: key);

  @override
  State<VerifyLogin> createState() => _VerifyLoginState();
}

class _VerifyLoginState extends State<VerifyLogin> {
  bool initialized = false;

  Future<UserModel?> verifyLogin() async {
    initialized = true;
    return await Provider.of<UserProvider>(context).recoverUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialized ? null : verifyLogin(),
      builder: (context, snapshot) {
        print((snapshot.data as UserModel?)?.user_type_id);
        if (snapshot.connectionState != ConnectionState.waiting) {
          return AuthModule();
          // return snapshot.data != null ? TaskModule() : AuthModule();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
