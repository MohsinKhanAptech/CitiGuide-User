import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Cities? selectedCity;

Future<void> initConstants() async {
  prefs = await SharedPreferences.getInstance();
  await getSelectedCity();
}

Future<void> getSelectedCity() async {
  selectedCity = Cities.values.firstWhere(
    (c) => c.name == prefs.getString('city'),
  );
}

enum Cities {
  karachi,
  lahore,
  islamabad,
}
