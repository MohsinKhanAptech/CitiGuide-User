import 'package:citiguide_user/view/detail_view.dart';

import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({
    super.key,
    required this.locationImageUrl,
    required this.locationName,
    required this.locationID,
    required this.category,
    required this.categoryID,
    this.height,
    this.width,
  });

  final String locationImageUrl;
  final String locationName;
  final String locationID;
  final String category;
  final String categoryID;
  final double? height;
  final double? width;

  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          category: category,
          categoryID: categoryID,
          locationID: locationID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: () => onTap(context),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: DecoratedBox(
                  // TODO: replace this container with image.
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(locationImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  locationName,
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
