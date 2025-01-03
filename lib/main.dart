import 'dart:async';

import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/internet_unavailable_view.dart';
import 'package:citiguide_user/view/main_view.dart';
import 'package:citiguide_user/view/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_user/firebase_options.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// TODO: implement a custom splash screen if possible.

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
  bool internetAvailable = true;
  Timer? waitForReconnect;
  late StreamSubscription<InternetConnectionStatus> subscription;

  Future<void> getSelectedCity() async {
    String? city = prefs.getString('city');
    setState(() {
      selectedCity = cities.lookup(city);
    });
  }

  @override
  void initState() {
    super.initState();
    initConstants().then((value) {
      getSelectedCity();
    });
    subscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          setState(() => internetAvailable = true);
          waitForReconnect?.cancel();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text('internet unavailable, please reconnect.'),
                ),
                duration: Duration(milliseconds: 4500),
              ),
            );
          }
          waitForReconnect = Timer(Duration(milliseconds: 5000), () {
            setState(() => internetAvailable = false);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!internetAvailable) {
      return InternetUnavailableView();
    }
    if (selectedCity == null) {
      return SplashView();
    } else {
      return MainView();
    }
  }

  @override
  void dispose() {
    connectionChecker.dispose();
    super.dispose();
  }
}
