import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
final connectionChecker = InternetConnectionChecker.instance;
Cities? selectedCity;

Future<void> initConstants() async {
  prefs = await SharedPreferences.getInstance();
}

enum Cities {
  karachi,
  lahore,
  islamabad,
}
