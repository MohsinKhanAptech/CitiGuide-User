import 'package:citiguide_user/components/primary_card.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CardRow extends StatefulWidget {
  const CardRow({
    super.key,
    required this.title,
    required this.category,
    required this.categoryID,
  });

  final String title;
  final String category;
  final String categoryID;

  @override
  State<CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<CardRow> {
  bool loading = true;
  late QuerySnapshot<Object?> querySnapshot;

  Future<void> getData() async {
    querySnapshot = await citiesRef
        .doc(selectedCityID)
        .collection('categories')
        .doc(widget.categoryID)
        .collection('locations')
        .get();
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            //TextButton(
            //  onPressed: () {},
            //  child: const Text('see more >'),
            //),
          ],
        ),
        if (loading)
          SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              scrollDirection: Axis.horizontal,
              itemCount: querySnapshot.size,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PrimaryCard(
                  width: 200,
                  locationID: querySnapshot.docs[index].id,
                  locationName: querySnapshot.docs[index].get('name'),
                  locationImageUrl: querySnapshot.docs[index].get('imageUrl'),
                  categoryID: widget.categoryID,
                );
              },
            ),
          ),
      ],
    );
  }
}
