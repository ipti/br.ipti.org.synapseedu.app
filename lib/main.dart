import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/block_conclusion.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/splashscreen/degree_selection_view.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/PRE_SOM_IA.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import './register/countdown.dart';
import 'app/feature/auth/auth_module.dart';
import 'app/feature/home/home_module.dart';
import 'app/feature/preview/preview_module.dart';
import 'app/feature/qrcode/qrcode_module.dart';
import 'app/feature/task/page/task_completed_page.dart';
import 'app/providers/block_provider.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // // ;;FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  //usando pra iniciar em outra tela
  //Força o modo retrato na inicialização do aplicativo
  WidgetsFlutterBinding.ensureInitialized();
  //[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  SystemChrome.setPreferredOrientations([]).then((_) async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => BlockProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'RPSEdu',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Comic',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Color(0xFF00004C), width: 1)),
              minWidth: 0,
            ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen).copyWith(background: Color(0xFFFFFFFF)),
          ),
          // initialRoute: QrCodePage.routeName,
          // initialRoute: ActivitySelectionForm.routeName,
          initialRoute: AuthModule.routeName,
          // initialRoute: BlockConclusionScreen.routeName,
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
            QrCodePage.routeName: (context) => QrCodeModule(),
          },
            onGenerateRoute: (settings) {
              var uri = Uri.parse(settings.name!);
              if(kIsWeb){
                if (settings.name == null || settings.name == "/") {
                  return MaterialPageRoute(builder: (context) => TaskCompletedPage());
                }
              }

              if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'preview') {
                var id = uri.pathSegments[1];
                return MaterialPageRoute(
                    settings: RouteSettings(name: settings.name, arguments: settings.arguments),
                    builder: (context) => PreviewModule(id: int.parse(id))
                );
              }

              if(kIsWeb)return MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(), body: Center(child: Text('404!'))));
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
