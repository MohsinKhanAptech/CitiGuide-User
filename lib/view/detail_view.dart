import 'package:citiguide_user/view/reviews_view.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/map_view.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class DetailView extends StatefulWidget {
  const DetailView({
    super.key,
    required this.categoryID,
    required this.locationID,
  });

  final String categoryID;
  final String locationID;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool loading = true;
  late DocumentSnapshot locationSnap;

  Future<void> getData() async {
    locationSnap = await citiesRef
        .doc(selectedCityID)
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
          locationSnap: locationSnap,
          categoryID: widget.categoryID,
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
    required this.locationSnap,
    required this.categoryID,
  });
  final DocumentSnapshot locationSnap;
  final String categoryID;

  @override
  Widget build(BuildContext context) {
    String locationName = locationSnap.get('name');
    String locationImageUrl = locationSnap.get('imageUrl');
    String locationDescription = locationSnap.get('description');
    double locationRating = locationSnap.get('rating');

    return ListView(
      children: [
        Container(
          height: 300,
          color: Colors.grey.shade400,
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
              Text(
                locationDescription,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 24),
              DetailViewActionButtonContainer(
                locationSnap: locationSnap,
                categoryID: categoryID,
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              DetailViewMapPreview(locationSnap: locationSnap),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Reviews',
                      style: TextStyle(fontSize: 24),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(locationRating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        for (var i = 0; i < 5; i++) Icon(Icons.star_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              for (var i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReviewCard(),
                ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewView()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'View More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
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
    required this.locationSnap,
    required this.categoryID,
  });

  final DocumentSnapshot locationSnap;
  final String categoryID;

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
        DetailViewActionButton(
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          active: isFavorite,
          label: 'Favorite',
          onTap: () => favorite(context),
        ),
        DetailViewActionButton(
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
        DetailViewActionButton(
          // TODO: implement directions to location.
          icon: Icons.directions_outlined,
          label: 'Directions',
          onTap: () async {
            MapsLauncher.launchQuery(widget.locationSnap.get('name'));
          },
          //onTap: () async {
          //  Navigator.push(
          //    context,
          //    MaterialPageRoute(
          //      builder: (context) {
          //        return MapView(locationSnap: widget.locationSnap);
          //      },
          //    ),
          //  );
          //},
        ),
        DetailViewActionButton(
          icon: Icons.star_outline,
          label: 'Reviews',
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewView()),
            );
          },
        ),
      ],
    );
  }
}

class DetailViewActionButton extends StatefulWidget {
  const DetailViewActionButton({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.label,
    this.onTap,
    this.active = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Future<void> Function()? onTap;
  final bool active;

  @override
  State<DetailViewActionButton> createState() => _DetailViewActionButtonState();
}

class _DetailViewActionButtonState extends State<DetailViewActionButton> {
  late bool active;
  IconData? currentIcon;

  @override
  void initState() {
    super.initState();
    active = widget.active;
    if (active) {
      currentIcon ??= widget.activeIcon;
    } else {
      currentIcon ??= widget.icon;
    }
  }

  Future<void> onTap() async {
    if (widget.onTap != null) {
      await widget.onTap!();
    }
    setState(
      () {
        if (widget.activeIcon != null) {
          active = !active;
          if (active) {
            currentIcon = widget.activeIcon;
          } else {
            currentIcon = widget.icon;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 50, minHeight: 50),
          child: Column(
            children: [
              Icon(
                currentIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 2),
              Text(
                widget.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailViewMapPreview extends StatelessWidget {
  const DetailViewMapPreview({super.key, required this.locationSnap});
  final DocumentSnapshot locationSnap;

  @override
  Widget build(BuildContext context) {
    final GeoPoint locationGeoPoint = locationSnap.get('geopoint');

    return SizedBox(
      height: 250,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            locationGeoPoint.latitude,
            locationGeoPoint.longitude,
          ),
          initialZoom: 18,
          minZoom: 16,
          maxZoom: 20,
          onTap: (tapPosition, latLng) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MapView(locationSnap: locationSnap);
                },
              ),
            );
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: CancellableNetworkTileProvider(),
          ),
          MarkerLayer(markers: [
            Marker(
              point: LatLng(
                locationGeoPoint.latitude,
                locationGeoPoint.longitude,
              ),
              rotate: true,
              alignment: Alignment(0, -1),
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
          ])
        ],
      ),
    );
  }
}

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
