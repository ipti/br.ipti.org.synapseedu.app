import 'package:elesson/share/question_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isUserConfirmed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConfirmed = prefs.getBool('isConfirmed') ?? false;
  isAdmin = prefs.getBool('admin') ?? false;
  // print('Confirmed ${isConfirmed.toString()}');
  return isConfirmed;
}
