import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
Set<String> userFavorites = {};

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

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.system;

  Future<void> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? theme = sharedPreferences.getString('theme');

    if (theme == 'light') {
      currentTheme = ThemeMode.light;
    } else if (theme == 'dark') {
      currentTheme = ThemeMode.dark;
    } else {
      currentTheme = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> changeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (currentTheme == ThemeMode.light) {
      currentTheme = ThemeMode.dark;
      sharedPreferences.setString('theme', 'dark');
    } else {
      currentTheme = ThemeMode.light;
      sharedPreferences.setString('theme', 'light');
    }
    notifyListeners();
  }
}

Future<void> listenUserAuth() async {
  firebaseAuth.authStateChanges().listen((User? user) async {
    if (user == null) {
      userSignedIn = false;
    } else {
      userSignedIn = true;
      userID = user.uid;
      await fetchUserFavorites();
    }
  });
}

Future<void> fetchUserFavorites() async {
  DocumentSnapshot userSnap =
      await firebaseFirestore.collection('users').doc(userID).get();
  List<dynamic> favorites = userSnap.get('favorites') as List<dynamic>;
  for (var location in favorites) {
    userFavorites.add(location);
  }
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

void processingRequestSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text('Processing Request.'),
      ),
    ),
  );
}

void somethingWentWrongSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text('Something went wrong.'),
      ),
    ),
  );
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
