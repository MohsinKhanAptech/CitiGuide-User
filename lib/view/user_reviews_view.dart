import 'package:flutter/material.dart';

class UserReviewsView extends StatelessWidget {
  const UserReviewsView({super.key});

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
