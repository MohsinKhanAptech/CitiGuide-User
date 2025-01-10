import 'package:citiguide_user/components/action_button.dart';
import 'package:citiguide_user/components/map_preview.dart';
import 'package:citiguide_user/view/reviews_view.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/map_view.dart';

import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailView extends StatefulWidget {
  const DetailView({
    super.key,
    required this.cityID,
    required this.categoryID,
    required this.locationID,
  });

  final String cityID;
  final String categoryID;
  final String locationID;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool loading = true;
  late DocumentSnapshot locationSnap;

  Future<void> getData() async {
    String cityID = widget.cityID;

    locationSnap = await citiesRef
        .doc(cityID)
        .collection('categories')
        .doc(widget.categoryID)
        .collection('locations')
        .doc(widget.locationID)
        .get();
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) => setState(() => loading = false));
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
    }
    return SafeArea(
      child: Scaffold(
        appBar: DetailViewAppBar(locationSnap: locationSnap),
        body: DetailViewBody(
          cityID: widget.cityID,
          categoryID: widget.categoryID,
          locationSnap: locationSnap,
        ),
      ),
    );
  }
}

class DetailViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailViewAppBar({super.key, required this.locationSnap});
  final DocumentSnapshot locationSnap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String locationName = locationSnap.get('name');

    return AppBar(
      title: Text(locationName.toTitleCase),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Open in google maps'),
              onTap: () {
                MapsLauncher.launchQuery(locationName);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DetailViewBody extends StatelessWidget {
  const DetailViewBody({
    super.key,
    required this.cityID,
    required this.categoryID,
    required this.locationSnap,
  });
  final String cityID;
  final String categoryID;
  final DocumentSnapshot locationSnap;

  @override
  Widget build(BuildContext context) {
    String locationName = locationSnap.get('name');
    String locationImageUrl = locationSnap.get('imageUrl');
    String locationDescription = locationSnap.get('description');
    double locationRating = locationSnap.get('rating');

    return ListView(
      children: [
        SizedBox(
          height: 300,
          child: Image.network(
            locationImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName.toTitleCase,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${locationRating.toStringAsFixed(1)} / 5.0',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.star_rounded),
                ],
              ),
              SizedBox(height: 12),
              Text(
                locationDescription,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 24),
              DetailViewActionButtonContainer(
                cityID: cityID,
                categoryID: categoryID,
                locationSnap: locationSnap,
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              MapPreview(locationSnap: locationSnap),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailViewActionButtonContainer extends StatefulWidget {
  const DetailViewActionButtonContainer({
    super.key,
    required this.cityID,
    required this.categoryID,
    required this.locationSnap,
  });

  final String cityID;
  final String categoryID;
  final DocumentSnapshot locationSnap;

  @override
  State<DetailViewActionButtonContainer> createState() =>
      _DetailViewActionButtonContainerState();
}

class _DetailViewActionButtonContainerState
    extends State<DetailViewActionButtonContainer> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = checkIfFavorite();
  }

  void loginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign-In.'),
          content: Text('You need to sign-in to favorite locations.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInView()),
                  );
                }
              },
              child: const Text('Sign-In'),
            ),
          ],
        );
      },
    );
  }

  bool checkIfFavorite() {
    return userFavorites.contains(
      '$selectedCityID-${widget.categoryID}-${widget.locationSnap.id}',
    );
  }

  Future<void> favorite(BuildContext context) async {
    if (userSignedIn) {
      String favoriteEntry =
          '$selectedCityID-${widget.categoryID}-${widget.locationSnap.id}';
      if (userFavorites.remove(favoriteEntry)) {
        firebaseFirestore
            .collection('users')
            .doc(userID)
            .update({'favorites': userFavorites});
      } else {
        userFavorites.add(favoriteEntry);
        firebaseFirestore
            .collection('users')
            .doc(userID)
            .update({'favorites': userFavorites});
      }
    } else {
      loginDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionButton(
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          active: isFavorite,
          label: 'Favorite',
          onTap: () => favorite(context),
        ),
        ActionButton(
          icon: Icons.location_on_outlined,
          label: 'Map',
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MapView(locationSnap: widget.locationSnap);
                },
              ),
            );
          },
        ),
        ActionButton(
          // TODO: implement directions to location.
          icon: Icons.directions_outlined,
          label: 'Directions',
          onTap: () async {
            MapsLauncher.launchQuery(widget.locationSnap.get('name'));
          },
        ),
        ActionButton(
          icon: Icons.star_outline,
          label: 'Reviews',
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewsView(
                  cityID: widget.cityID,
                  categoryID: widget.categoryID,
                  locationID: widget.locationSnap.id,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
