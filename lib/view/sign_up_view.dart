import 'package:citiguide_user/components/password_text_field.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key, this.canPop = true});
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SignUpViewBody(canPop: canPop),
      ),
    );
  }
}

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key, required this.canPop});
  final bool canPop;

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;

  Future<void> onPressed() async {
    String name = usernameController.text.trim();
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

      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firebaseFirestore.collection('users').doc(userID).set({
        'name': name,
        'email': email,
        'favorites': [],
      });

      // save username locally
      username = name;
      prefs.setString('username', name);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(
              child: Text('Sign-Up successful.'),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInView()),
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
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    usernameError = emailError = passwordError = null;

    bool isValid = true;

    if (username.isEmpty) {
      setState(() => usernameError = 'Username is required.');
      isValid = false;
    }
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
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign-Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: usernameError,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
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
                    MaterialPageRoute(builder: (context) => SignInView()),
                  );
                },
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                ),
                child: Text('Already have an account? click here!'),
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
