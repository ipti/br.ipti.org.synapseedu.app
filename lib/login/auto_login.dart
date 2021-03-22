import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isUserConfirmed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConfirmed = prefs.getBool('isConfirmed') ?? false;
  // print('Confirmed ${isConfirmed.toString()}');
  return isConfirmed;
}
