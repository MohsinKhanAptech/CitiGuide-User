import 'package:citiguide_user/components/password_text_field.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';
import 'package:citiguide_user/view/sign_up_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key, this.canPop = true});
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SignInViewBody(canPop: canPop),
      ),
    );
  }
}

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key, required this.canPop});
  final bool canPop;

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> onPressed() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    bool isDataValid = await validateData();

    if (!isDataValid) return;

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('Processing request.'),
            ),
          ),
        );
      }

      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final DocumentSnapshot userSnap = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      username = userSnap.get('name');
      prefs.setString('username', username!);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(
              child: Text('Sign-In successful.'),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('Something went wrong.\n${e.message}'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('Something went wrong.'),
            ),
          ),
        );
      }
    }
  }

  void showsnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> validateData() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required.');
      isValid = false;
    } else if (!EmailValidator.validate(email)) {
      setState(() => emailError = 'Please enter a valid email.');
      isValid = false;
    }
    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required.');
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign-In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailError,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            PasswordTextField(
              labelText: 'Password',
              controller: passwordController,
              errorText: passwordError,
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpView()),
                );
              },
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
              child: Text('Don\'t have an account? click here!'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: onPressed,
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10),
                  Text('Submit', style: TextStyle(fontSize: 16)),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 12),
            if (widget.canPop)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left),
                    Text('Cancel', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
