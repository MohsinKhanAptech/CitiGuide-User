import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Cities? selectedCity;

Future<void> initConstants() async {
  prefs = await SharedPreferences.getInstance();
}

enum Cities {
  karachi,
  lahore,
  islamabad,
}
