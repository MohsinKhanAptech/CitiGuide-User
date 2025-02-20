import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = true,
    this.suffixIcon = Icons.visibility,
    this.suffixIconActive = Icons.visibility_off,
    this.errorText,
  });
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final IconData suffixIcon;
  final IconData suffixIconActive;
  final String? errorText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  IconData? icon;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      icon = widget.suffixIcon;
      obscureText = widget.obscureText;
    });
  }

  void onPressed() {
    setState(() {
      if (icon == widget.suffixIcon) {
        obscureText = false;
        icon = widget.suffixIconActive;
      } else {
        obscureText = true;
        icon = widget.suffixIcon;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        suffixIcon: IconButton(onPressed: onPressed, icon: Icon(icon)),
        border: OutlineInputBorder(),
      ),
    );
  }
}
