import 'package:citiguide_user/components/card_row.dart';

import 'package:flutter/material.dart';

class DiscoverPageAppBar extends StatelessWidget {
  const DiscoverPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("CitiGuide"),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              child: Text('menu option'),
            ),
          ],
        ),
      ],
    );
  }
}

class DiscoverPageBody extends StatelessWidget {
  const DiscoverPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardRow(title: 'Featured'),
          CardRow(title: 'Recommended'),
          CardRow(title: 'Trending'),
        ],
      ),
    );
  }
}
