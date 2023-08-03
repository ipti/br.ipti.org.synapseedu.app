import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/block_conclusion.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/splashscreen/degree_selection_view.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/PRE_SOM_IA.dart';
import 'package:provider/provider.dart';
import './register/countdown.dart';
import 'app/feature/auth/auth_module.dart';
import 'app/feature/home/home_module.dart';
import 'app/feature/preview/preview_module.dart';
import 'app/providers/userProvider.dart';
import './root/poc.dart';
import 'package:elesson/register/sms_register.dart';
import 'package:elesson/template_questoes/share/image_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'activity_selection/activity_selection_view.dart';
import 'app/util/routes.dart';
import 'template_questoes/multiple_choice.dart';
import 'template_questoes/ddrop/ddrop.dart';
import 'template_questoes/pre_base.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  //usando pra iniciar em outra tela
  //Força o modo retrato na inicialização do aplicativo

  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Synapse Aluno',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Mulish',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Color(0xFF00004C), width: 1)),
              minWidth: 0,
            ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen).copyWith(background: Color(0xFFFFFFFF)),
          ),
          initialRoute: AuthModule.routeName,
          routes: {
            AuthModule.routeName: (context) => AuthModule(),
            HomeModule.routeName: (context) => HomeModule(),
            DegreeSelectionView.routeName: (context) => DegreeSelectionView(),
            BlockSelection.routeName: (context) => BlockSelection(),
            CountDownTimer.routeName: (context) => CountDownTimer(),
            RootPage.routeName: (context) => RootPage(),
            SmsRegisterView.routeName: (context) => SmsRegisterView(),
            // CodeVerifyView.routeName: (context) => CodeVerifyView(),
            PreImgIa.routeName: (context) => PreImgIa(),
            PreSomIa.routeName: (context) => PreSomIa(),
            //----------------------------rotas fora de fluxo---------------------------
            ActivitySelectionForm.routeName: (context) => ActivitySelectionForm(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            SingleLineTextQuestion.routeName: (context) => SingleLineTextQuestion(),
            DragAndDrop.routeName: (context) => DragAndDrop(),
            MultipleChoiceQuestion.routeName: (context) => MultipleChoiceQuestion(),
            // TextQuestion.routeName: (context) => TextQuestion(),
            ImageDetailScreen.routeName: (context) => ImageDetailScreen(),
            BlockConclusionScreen.routeName: (context) => BlockConclusionScreen(),
            QrCodeReader.routeName: (context) => QrCodeReader(),
          },
            onGenerateRoute: (settings) {
              if (settings.name == null || settings.name == "/") {
                return MaterialPageRoute(builder: (context) => HomeModule());
              }

              var uri = Uri.parse(settings.name!);
              if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'preview') {
                var id = uri.pathSegments[1];
                return MaterialPageRoute(
                    settings: RouteSettings(name: settings.name, arguments: settings.arguments),
                    builder: (context) => PreviewModule(id: int.parse(id))
                );
              }

              return MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(), body: Center(child: Text('404!'))));
            }
        ),
      ),
    );
  });

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}
