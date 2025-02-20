import 'package:citiguide_user/components/primary_card.dart';
import 'package:citiguide_user/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardRow extends StatefulWidget {
  const CardRow({
    super.key,
    required this.title,
    required this.category,
    required this.categoryID,
    this.cityID,
  });

  final String title;
  final String category;
  final String categoryID;
  final String? cityID;

  @override
  State<CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<CardRow> {
  bool loading = true;
  late QuerySnapshot<Object?> locationsSnap;

  Future<void> getData() async {
    locationsSnap = await citiesRef
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
            // TODO: implement a category list view to show
            // when "see more" button is pressed.
            TextButton(
              onPressed: () {},
              child: const Text('see more >'),
            ),
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
              itemCount: locationsSnap.size,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PrimaryCard(
                  width: 200,
                  locationSnap: locationsSnap.docs[index],
                  categoryID: widget.categoryID,
                  cityID: widget.cityID ?? selectedCityID,
                );
              },
            ),
          ),
      ],
    );
  }
}
