import 'package:citiguide_user/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewAddView extends StatelessWidget {
  const ReviewAddView({super.key, required this.reviewsCollectionRef});
  final CollectionReference reviewsCollectionRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Review'),
        ),
        body: ReviewAddViewBody(
          reviewsCollectionRef: reviewsCollectionRef,
        ),
      ),
    );
  }
}

class ReviewAddViewBody extends StatefulWidget {
  const ReviewAddViewBody({super.key, required this.reviewsCollectionRef});
  final CollectionReference reviewsCollectionRef;

  @override
  State<ReviewAddViewBody> createState() => _ReviewAddViewBodyState();
}

class _ReviewAddViewBodyState extends State<ReviewAddViewBody> {
  late QuerySnapshot reviewsCollectionSnap;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? titleError;
  String? descriptionError;
  double ratingSliderValue = 4;

  @override
  void initState() {
    super.initState();
    getSnapshot();
  }

  Future<void> getSnapshot() async {
    reviewsCollectionSnap = await widget.reviewsCollectionRef.get();
  }

  Future<void> onPressed(BuildContext context) async {
    titleError = descriptionError = null;

    String reviewTitle = titleController.text.trim();
    String reviewDescription = descriptionController.text.trim();

    if (reviewTitle.isEmpty) {
      setState(() => titleError = 'This field is required.');
      if (reviewDescription.isEmpty) {
        setState(() => descriptionError = 'This field is required.');
      }
      return;
    }

    processingRequestSnackBar(context);
    try {
      await widget.reviewsCollectionRef.doc(userID).set({
        'username': username,
        'title': reviewTitle,
        'description': reviewDescription,
        'rating': ratingSliderValue,
      });

      DocumentSnapshot locationSnap =
          await widget.reviewsCollectionRef.parent!.get();
      double oldRating = locationSnap.get('rating');
      int reviewCount = reviewsCollectionSnap.docs.length;

      //NOTE: rating calculation system.
      late double newRating;
      if (reviewCount == 0) {
        newRating = ratingSliderValue;
      } else {
        newRating =
            ((oldRating * reviewCount) + ratingSliderValue) / reviewCount + 1;
      }

      await widget.reviewsCollectionRef.parent!.update({
        'rating': newRating,
      });
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('Review added.'),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) somethingWentWrongSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                label: Text('Review Title'),
                errorText: titleError,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                label: Text('Review Description'),
                errorText: descriptionError,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 42),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$ratingSliderValue / 5',
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  child: Slider(
                    value: ratingSliderValue,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: ratingSliderValue.toStringAsFixed(0),
                    onChanged: (double value) {
                      setState(() => ratingSliderValue = value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => onPressed(context),
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
