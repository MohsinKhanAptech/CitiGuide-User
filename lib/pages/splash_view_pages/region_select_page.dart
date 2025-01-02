import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';

import 'package:flutter/material.dart';

class RegionSelectPage extends StatefulWidget {
  const RegionSelectPage({super.key, required this.incrementPage});

  final VoidCallback incrementPage;

  @override
  State<RegionSelectPage> createState() => _RegionSelectPageState();
}

class _RegionSelectPageState extends State<RegionSelectPage> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // TODO: add location access to determine city and set it as default value

    void onPressed() async {
      if (selectedCity == null) {
        setState(() => errorMessage = 'Please select your city.');
      } else {
        await prefs.setString('city', selectedCity!);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
            (route) => false,
          );
        }
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
                width: 160,
                errorText: errorMessage,
                label: Text('City'),
                onSelected: (String? value) => selectedCity = value,
                initialSelection: selectedCity,
                dropdownMenuEntries: [
                  for (var i = 0; i < cities.length; i++)
                    DropdownMenuEntry(
                      value: cities.elementAt(i),
                      label: cities.elementAt(i).toTitleCase,
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
