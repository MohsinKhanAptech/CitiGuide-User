import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text('User Name'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++) Icon(Icons.star_rounded),
        ],
      ),
      titleAlignment: ListTileTitleAlignment.top,
      subtitle: Text('User review of product'),
    );
  }
}
