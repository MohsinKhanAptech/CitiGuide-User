import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';

import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SplashPageHandler(),
      ),
    );
  }
}

class SplashPageHandler extends StatefulWidget {
  const SplashPageHandler({super.key});

  @override
  State<SplashPageHandler> createState() => _SplashPageHandlerState();
}

class _SplashPageHandlerState extends State<SplashPageHandler> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    void incrementPage() => setState(() => page++);

    return [
      Page1(incrementPage: incrementPage),
      Page2(incrementPage: incrementPage),
    ][page];
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key, required this.incrementPage});

  final VoidCallback incrementPage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 12),
          Column(
            children: [
              const Text(
                'Welcome to CitiGuide',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Text(
                'Your travel companion',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: incrementPage,
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 6),
                    Text('Continue', style: TextStyle(fontSize: 16)),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key, required this.incrementPage});

  final VoidCallback incrementPage;

  @override
  Widget build(BuildContext context) {
    // TODO: add location access to determine city and set it as default value
    selectedCity = Cities.karachi;

    void onPressed() async {
      await prefs.setString('city', selectedCity!.name.toString());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainView()),
          (route) => false,
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Confirm your City',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 12),
              DropdownMenu(
                label: Text('City'),
                onSelected: (Cities? value) => selectedCity = value,
                initialSelection: selectedCity,
                dropdownMenuEntries: [
                  for (var i = 0; i < Cities.values.length; i++)
                    DropdownMenuEntry(
                      value: Cities.values[i],
                      label: Cities.values[i].name,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onPressed,
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 6),
                    Text('Continue', style: TextStyle(fontSize: 16)),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
