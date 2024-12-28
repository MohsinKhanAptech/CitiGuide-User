import 'package:citiguide_user/utils/constants.dart';

import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SettingsViewAppBar(page: page),
        body: SettingsViewBodyHandler(page: page),
      ),
    );
  }
}

class SettingsViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsViewAppBar({super.key, required this.page});
  final int page;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        [
          'Change Region',
        ][page],
      ),
    );
  }
}

class SettingsViewBodyHandler extends StatelessWidget {
  const SettingsViewBodyHandler({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return [
      ChangeRegion(),
    ][page];
  }
}

class ChangeRegion extends StatelessWidget {
  const ChangeRegion({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      prefs.setString('city', selectedCity!.name.toString());
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
                label: Text('City'),
                onSelected: (value) {
                  value != null ? selectedCity = value : null;
                },
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
