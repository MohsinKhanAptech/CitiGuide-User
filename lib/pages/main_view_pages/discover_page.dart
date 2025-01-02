import 'package:citiguide_user/components/card_row.dart';
import 'package:citiguide_user/utils/constants.dart';

import 'package:flutter/material.dart';

class DiscoverPageAppBar extends StatelessWidget {
  const DiscoverPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('CitiGuide'),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardRow(
            title: 'Hotels in $selectedCity',
            category: 'Hotels',
          ),
          CardRow(
            title: 'Restaurants in $selectedCity',
            category: 'Restaurants',
          ),
        ],
      ),
    );
  }
}
