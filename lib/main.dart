import 'package:citiguide_user/view/internet_unavailable_view.dart';
import 'package:citiguide_user/utils/theme_provider.dart';
import 'package:citiguide_user/view/loading_view.dart';
import 'package:citiguide_user/view/splash_view.dart';
import 'package:citiguide_user/view/main_view.dart';
import 'package:citiguide_user/utils/globals.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_user/firebase_options.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.getTheme();
  runApp(
    // FIXME: theme change seems to be buggy.
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// TODO: implement a custom splash screen if possible.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitiGuide',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
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
  bool loading = true;
  bool internetAvailable = true;
  Timer? waitForReconnect;
  late StreamSubscription<InternetConnectionStatus> subscription;

  Future<void> getSelectedCity() async {
    String? savedCity = prefs.getString('city');
    String? savedCityID = prefs.getString('cityID');

    // TODO: why is this here? why are we changing the state?
    setState(() {
      selectedCity = cities.lookup(savedCity);
      selectedCityID = citiesID.lookup(savedCityID);
    });
  }

  @override
  void initState() {
    super.initState();

    initGlobals(getSelectedCity).then((value) {
      setState(() => loading = false);
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
    if (loading) {
      return LoadingView();
    } else if (!internetAvailable) {
      return InternetUnavailableView();
    } else if (selectedCity == null) {
      return SplashView();
    } else {
      return MainView();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    connectionChecker.dispose();
    super.dispose();
  }
}
