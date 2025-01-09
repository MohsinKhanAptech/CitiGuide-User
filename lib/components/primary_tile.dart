import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class PrimaryTile extends StatefulWidget {
  const PrimaryTile({
    super.key,
    required this.cityID,
    required this.categoryID,
    required this.locationID,
  });
  final String cityID;
  final String categoryID;
  final String locationID;

  @override
  State<PrimaryTile> createState() => _PrimaryTileState();
}

class _PrimaryTileState extends State<PrimaryTile> {
  bool loading = true;

  late String cityID;
  late String categoryID;
  late String locationID;

  late String locationName;
  late String locationImageUrl;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    cityID = widget.cityID;
    categoryID = widget.categoryID;
    locationID = widget.locationID;
    DocumentSnapshot locationSnap = await citiesRef
        .doc(cityID)
        .collection('categories')
        .doc(categoryID)
        .collection('locations')
        .doc(locationID)
        .get();

    locationName = locationSnap.get('name');
    locationImageUrl = locationSnap.get('imageUrl');

    setState(() => loading = false);
  }

  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          cityID: cityID,
          categoryID: categoryID,
          locationID: widget.locationID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 100,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(locationImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationName.toTitleCase,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < 5; i++) Icon(Icons.star),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
