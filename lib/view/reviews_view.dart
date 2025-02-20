import 'package:citiguide_user/components/review_card.dart';
import 'package:citiguide_user/view/review_add_view.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsView extends StatefulWidget {
  const ReviewsView({
    super.key,
    required this.cityID,
    required this.categoryID,
    required this.locationID,
  });

  final String cityID;
  final String categoryID;
  final String locationID;

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  bool loading = true;

  late CollectionReference reviewsCollectionRef;
  late QuerySnapshot reviewsCollectionSnap;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    reviewsCollectionRef = citiesRef
        .doc(widget.cityID)
        .collection('categories')
        .doc(widget.categoryID)
        .collection('locations')
        .doc(widget.locationID)
        .collection('reviews');

    reviewsCollectionSnap = await reviewsCollectionRef.get();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (reviewsCollectionSnap.docs.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Reviews'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border_rounded,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  'No reviews found.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          floatingActionButton: ReviewViewActionButton(
            reviewsCollectionRef: reviewsCollectionRef,
            reviewsCollectionSnap: reviewsCollectionSnap,
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Reviews'),
          ),
          body: ReviewViewBody(
            reviewsCollectionSnap: reviewsCollectionSnap,
          ),
          floatingActionButton: ReviewViewActionButton(
            reviewsCollectionRef: reviewsCollectionRef,
            reviewsCollectionSnap: reviewsCollectionSnap,
          ),
        ),
      );
    }
  }
}

class ReviewViewBody extends StatelessWidget {
  const ReviewViewBody({super.key, required this.reviewsCollectionSnap});
  final QuerySnapshot reviewsCollectionSnap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: reviewsCollectionSnap.docs.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: reviewsCollectionSnap.docs[index]);
      },
    );
  }
}

class ReviewViewActionButton extends StatefulWidget {
  const ReviewViewActionButton({
    super.key,
    required this.reviewsCollectionRef,
    required this.reviewsCollectionSnap,
  });

  final CollectionReference reviewsCollectionRef;
  final QuerySnapshot reviewsCollectionSnap;

  @override
  State<ReviewViewActionButton> createState() => _ReviewViewActionButtonState();
}

class _ReviewViewActionButtonState extends State<ReviewViewActionButton> {
  bool loading = true;
  bool? reviewExists;

  @override
  void initState() {
    super.initState();
    reviewExistsCheck();
  }

  Future<void> reviewExistsCheck() async {
    if (!userSignedIn || widget.reviewsCollectionSnap.docs.isEmpty) {
      setState(() => reviewExists = false);
    } else {
      for (var review in widget.reviewsCollectionSnap.docs) {
        reviewExists = review.id == userID;
        if (reviewExists!) {
          setState(() => reviewExists = true);
          break;
        }
      }
    }
    setState(() => loading = false);
  }

  Future<void> onPressed(BuildContext context) async {
    if (!userSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text('Sign-In to leave a review.'),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInView(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewAddView(
            reviewsCollectionRef: widget.reviewsCollectionRef,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return FloatingActionButton(
        onPressed: () {},
        child: CircularProgressIndicator(),
      );
    } else if (reviewExists!) {
      return SizedBox(width: 1);
    } else {
      return FloatingActionButton(
        onPressed: () => onPressed(context),
        child: Icon(Icons.add),
      );
    }
  }
}
