import 'package:citiguide_user/components/password_text_field.dart';
import 'package:citiguide_user/view/user_favorites_view.dart';
import 'package:citiguide_user/view/options_view.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/view/sign_up_view.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserFavoritesView()),
              );
            },
            icon: Icons.favorite,
            title: 'Your Favorites',
          ),
          //TODO: complete you reviews page.
          //OptionsTile(
          //  onTap: () {
          //    Navigator.push(
          //      context,
          //      MaterialPageRoute(builder: (context) => UserReviewsView()),
          //    );
          //  },
          //  icon: Icons.star,
          //  title: 'Your Reviews',
          //),
          OptionsTile(
            optionsPage: 0,
            icon: Icons.language,
            title: 'Change Region',
          ),
          OptionsTile(
            icon: Icons.dark_mode,
            title: 'Change Theme',
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
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

  Future<void> changeUsername(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();

    Future<void> onConfirm() async {
      username = usernameController.text.trim();

      if (username!.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Username invalid.'),
              ),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        processingRequestSnackBar(context);
        await firebaseFirestore
            .collection('users')
            .doc(userID)
            .update({'name': username});
        prefs.setString('username', username!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Username changed.'),
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Username.'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              label: Text('New Username'),
              border: OutlineInputBorder(),
            ),
          ),
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

  Future<void> changeEmail(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    Future<void> onConfirm() async {
      String newEmail = emailController.text.trim();

      if (newEmail.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Email invalid.'),
              ),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        processingRequestSnackBar(context);
        try {
          firebaseAuth.currentUser!.verifyBeforeUpdateEmail(newEmail);
        } catch (e) {
          somethingWentWrongSnackBar(context);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Email changed.'),
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Email.'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text('New Email'),
              border: OutlineInputBorder(),
            ),
          ),
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

  Future<void> changePassword(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    Future<void> onConfirm() async {
      String newPassword = passwordController.text.trim();

      if (newPassword.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Password invalid.'),
              ),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        processingRequestSnackBar(context);
        try {
          await firebaseAuth.currentUser!.updatePassword(newPassword);
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text('Password change succesful.'),
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainView()),
            );
          }
        } on FirebaseAuthException {
          await firebaseAuth.signOut();
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInView(),
              ),
            );
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text('Sign-In to verify password change.'),
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) somethingWentWrongSnackBar(context);
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password.'),
          content: PasswordTextField(
            controller: passwordController,
            labelText: 'New Password',
          ),
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

  void signOut(BuildContext context) {
    Future<void> onConfirm() async {
      Navigator.pop(context);
      processingRequestSnackBar(context);
      firebaseAuth.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
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

  void deleteAccount(BuildContext context) {
    Future<void> onConfirm() async {
      try {
        Navigator.pop(context);
        processingRequestSnackBar(context);
        await firebaseAuth.currentUser!.delete().then((value) {
          firebaseFirestore.collection('users').doc(userID).delete();
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Account deleted succesfully.'),
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
          );
        }
      } on FirebaseAuthException {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignInView(reauthForDeletion: true),
            ),
          );
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text('Sign-In to verify account deletion.'),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) somethingWentWrongSnackBar(context);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account.'),
          content: Text(
            'Are you sure you want to delete your account?\nOnce deleted it can not be recovered.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
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
            onTap: () => changeUsername(context),
          ),
          OptionsTile(
            icon: Icons.email,
            title: 'Change Email',
            onTap: () => changeEmail(context),
          ),
          OptionsTile(
            icon: Icons.password,
            title: 'Change Password',
            onTap: () => changePassword(context),
          ),
          OptionsTile(
            icon: Icons.logout,
            title: 'Sign-Out',
            onTap: () => signOut(context),
          ),
          OptionsTile(
            icon: Icons.delete,
            title: 'Delete Account',
            onTap: () => deleteAccount(context),
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
