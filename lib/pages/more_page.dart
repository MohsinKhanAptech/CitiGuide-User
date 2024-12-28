import 'package:citiguide_user/view/settings_view.dart';

import 'package:flutter/material.dart';

class MorePageAppBar extends StatelessWidget {
  const MorePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class MorePageBody extends StatelessWidget {
  const MorePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hi, User!',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                  ),
                  child: const Text('Manage Account'),
                )
              ],
            ),
          ),
          const Divider(),
          moreTile(
            settingsPage: 0,
            icon: Icons.language,
            title: 'Change Region',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.star,
            title: 'Your Reviews',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.attach_money,
            title: 'Currency',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.style,
            title: 'Layout',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.auto_graph,
            title: 'Statistics',
          ),
          const Divider(),
          moreTile(
            settingsPage: 0,
            icon: Icons.settings,
            title: 'Settings',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.info,
            title: 'About',
          ),
          moreTile(
            settingsPage: 0,
            icon: Icons.help,
            title: 'Help',
          ),
        ],
      ),
    );
  }
}

class moreTile extends StatelessWidget {
  const moreTile({
    super.key,
    required this.settingsPage,
    required this.icon,
    required this.title,
  });

  final int settingsPage;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsView(page: settingsPage),
          ),
        );
      },
      leading: Icon(icon),
      title: Text(title),
    );
  }
}
