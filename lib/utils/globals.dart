import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

Future<void> initGlobals(Future<void> Function() getSelectedCity) async {
  prefs = await SharedPreferences.getInstance();

  citiesSnap = await citiesRef.get();

  await getCities();

  await getSelectedCity();

  await getCategories();

  await listenUserAuth();

  username = prefs.getString('username');
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

Future<void> getCities() async {
  cities.clear();
  citiesID.clear();

  for (var city in citiesSnap.docs) {
    cities.add(city.get('name'));
    citiesID.add(city.id);
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
