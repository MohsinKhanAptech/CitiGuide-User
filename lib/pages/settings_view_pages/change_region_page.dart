import 'package:citiguide_user/utils/constants.dart';

import 'package:flutter/material.dart';

class ChangeRegionPage extends StatelessWidget {
  const ChangeRegionPage({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      prefs.setString('city', selectedCity!);
      Navigator.pop(context);
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
