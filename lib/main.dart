import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';
import 'package:citiguide_user/view/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_user/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitiGuide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> getSelectedCity() async {
    String? city = prefs.getString('city');
    setState(() {
      selectedCity = Cities.values.firstWhere((c) => c.name == city);
    });
  }

  @override
  void initState() {
    super.initState();
    initConstants().then((value) {
      getSelectedCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCity == null) {
      return SplashView();
    } else {
      return MainView();
    }
  }
}
