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
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.star),
              title: Text('Your Reviews'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Currency'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.style),
              title: Text('Layout'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Statistics'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
            ),
          ),
        ],
      ),
    );
  }
}
