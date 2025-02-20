import 'package:flutter/material.dart';

class UserReviewsPage extends StatelessWidget {
  const UserReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Reviews'),
        ),
        body: Placeholder(),
      ),
    );
  }
}
