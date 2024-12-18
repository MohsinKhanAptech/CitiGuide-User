import 'package:citiguide_user/components/primary_card.dart';

import 'package:flutter/material.dart';

class CardRow extends StatelessWidget {
  const CardRow({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'see more >',
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 10; i++)
                const PrimaryCard(width: 200, bookName: 'Location name'),
            ],
          ),
        ),
      ],
    );
  }
}
