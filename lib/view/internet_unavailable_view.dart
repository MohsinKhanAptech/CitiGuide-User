import 'package:flutter/material.dart';

class InternetUnavailableView extends StatefulWidget {
  const InternetUnavailableView({super.key});

  @override
  State<InternetUnavailableView> createState() =>
      _InternetUnavailableViewState();
}

class _InternetUnavailableViewState extends State<InternetUnavailableView> {
  bool reloading = false;

  void retry() {
    setState(() => reloading = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => reloading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reloading) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Internet Unavailable',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'check you connection and try again',
                style: TextStyle(),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: retry,
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                ),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
