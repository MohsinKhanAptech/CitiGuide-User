import 'package:flutter/material.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: ReviewViewAppBar(),
        body: ReviewViewBody(),
      ),
    );
  }
}

class ReviewViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReviewViewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Reviews'),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('more options'),
            ),
          ],
        ),
      ],
    );
  }
}

class ReviewViewBody extends StatelessWidget {
  const ReviewViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
