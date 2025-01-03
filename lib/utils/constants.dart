import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
final connectionChecker = InternetConnectionChecker.instance;
Set<String> cities = {};
String? selectedCity;

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

CollectionReference citiesRef = firebaseFirestore.collection('cities');
late QuerySnapshot<Object?> citiesSnap;

Future<void> initConstants() async {
  prefs = await SharedPreferences.getInstance();
  citiesSnap = await citiesRef.get();
  for (var city in citiesSnap.docs) {
    cities.add(city.get('name'));
  }
}

extension StringCasingExtension on String {
  String get toCapitalized {
    return length > 0
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }

  String get toTitleCase {
    return replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((str) => str.toCapitalized)
        .join(' ');
  }
}
