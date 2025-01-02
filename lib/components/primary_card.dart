import 'package:citiguide_user/view/detail_view.dart';

import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({
    super.key,
    required this.title,
    required this.category,
    this.height,
    this.width,
  });

  final String title;
  final String category;
  final double? height;
  final double? width;

  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          category: category,
          locationID: title,
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
                  ),
                  child: const Center(
                    child: Text('location image'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  maxLines: 2,
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
