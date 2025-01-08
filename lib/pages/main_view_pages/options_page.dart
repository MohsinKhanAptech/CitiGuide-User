import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';
import 'package:citiguide_user/view/options_view.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/view/sign_up_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class OptionsPageAppBar extends StatelessWidget {
  const OptionsPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class OptionsPageBody extends StatelessWidget {
  const OptionsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    String greetings = 'Welcome, User!';

    if (userSignedIn) greetings = 'Welcome, $username';

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
                Text(
                  greetings,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          OptionsViewAuthSection(),
          OptionsTile(
            icon: Icons.favorite,
            title: 'Your Favorites',
          ),
          OptionsTile(
            icon: Icons.star,
            title: 'Your Reviews',
          ),
          OptionsTile(
            optionsPage: 0,
            icon: Icons.language,
            title: 'Change Region',
          ),
          const Divider(),
          OptionsTile(
            optionsPage: 1,
            icon: Icons.info,
            title: 'About',
          ),
          OptionsTile(
            optionsPage: 2,
            icon: Icons.help,
            title: 'Help',
          ),
        ],
      ),
    );
  }
}

class OptionsViewAuthSection extends StatelessWidget {
  const OptionsViewAuthSection({super.key});

  void signOut(BuildContext context) {
    Future<void> onConfirm() async {
      Navigator.pop(context);
      firebaseAuth.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('Sign-out succesful.'),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainView()),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign-Out.'),
          content: Text('Are you sure you want to Sign-out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userSignedIn) {
      return Column(
        children: [
          const Divider(),
          OptionsTile(
            icon: Icons.person,
            title: 'Change Username',
          ),
          OptionsTile(
            icon: Icons.email,
            title: 'Change Email',
          ),
          OptionsTile(
            icon: Icons.password,
            title: 'Change Password',
          ),
          OptionsTile(
            icon: Icons.logout,
            title: 'Sign-Out',
            onTap: () => signOut(context),
          ),
          const Divider(),
        ],
      );
    } else {
      return Column(
        children: [
          const Divider(),
          OptionsTile(
            icon: Icons.login,
            title: 'Sign-Up',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpView()),
              );
            },
          ),
          OptionsTile(
            icon: Icons.login,
            title: 'Sign-In',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInView()),
              );
            },
          ),
          const Divider(),
        ],
      );
    }
  }
}

class OptionsTile extends StatelessWidget {
  const OptionsTile({
    super.key,
    this.optionsPage,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final int? optionsPage;
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (optionsPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OptionsView(page: optionsPage!),
            ),
          );
        }
      },
      leading: Icon(icon),
      title: Text(title),
    );
  }
}
