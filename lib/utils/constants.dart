import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
final connectionChecker = InternetConnectionChecker.instance;
Set<String> cities = {};
Set<String> citiesID = {};
Set<String> categories = {};
Set<String> categoriesID = {};
String? selectedCity;
String? selectedCityID;
bool userSignedIn = false;
String? userID;
String? username;

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

CollectionReference citiesRef = firebaseFirestore.collection('cities');
late QuerySnapshot<Object?> citiesSnap;

Future<void> initConstants(Future<void> Function() getSelectedCity) async {
  prefs = await SharedPreferences.getInstance();

  citiesSnap = await citiesRef.get();
  for (var city in citiesSnap.docs) {
    cities.add(city.get('name'));
    citiesID.add(city.id);
  }

  await getSelectedCity();

  await getCategories();

  listenUserAuth();

  username = prefs.getString('username');
}

Future<void> listenUserAuth() async {
  firebaseAuth.authStateChanges().listen((User? user) {
    if (user == null) {
      userSignedIn = false;
    } else {
      userSignedIn = true;
      userID = user.uid;
    }
  });
}

Future<void> getCategories() async {
  categories.clear();
  categoriesID.clear();
  CollectionReference categoriesRef = firebaseFirestore
      .collection('cities')
      .doc(selectedCityID)
      .collection('categories');
  QuerySnapshot<Object?> categoriesSnap = await categoriesRef.get();
  for (var category in categoriesSnap.docs) {
    categories.add(category.get('name'));
    categoriesID.add(category.id);
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
