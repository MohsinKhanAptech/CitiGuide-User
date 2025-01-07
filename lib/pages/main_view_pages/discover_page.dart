import 'package:citiguide_user/components/card_row.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/main_view.dart';

import 'package:flutter/material.dart';

class DiscoverPageAppBar extends StatefulWidget {
  const DiscoverPageAppBar({super.key});

  @override
  State<DiscoverPageAppBar> createState() => _DiscoverPageAppBarState();
}

class _DiscoverPageAppBarState extends State<DiscoverPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('CitiGuide'),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Refresh'),
              onTap: () {},
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
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CardRow(
          title: '${categories.elementAt(index)} in $selectedCity',
          category: categories.elementAt(index),
          categoryID: categoriesID.elementAt(index),
        );
      },
    );
  }
}
