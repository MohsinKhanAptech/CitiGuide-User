import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});
  final QueryDocumentSnapshot review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(review.get('username')),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${review.get('rating')} / 5',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 4),
          Icon(Icons.star_rounded),
        ],
      ),
      subtitle: Text(review.get('title')),
      titleAlignment: ListTileTitleAlignment.top,
    );
  }
}
