import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/map_view.dart';
import 'package:citiguide_user/view/review_view.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  late DocumentSnapshot documentSnapshot;

  Future<void> getData() async {
    documentSnapshot = await citiesRef
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
        appBar: DetailViewAppBar(documentSnapshot: documentSnapshot),
        body: DetailViewBody(documentSnapshot: documentSnapshot),
      ),
    );
  }
}

class DetailViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailViewAppBar({super.key, required this.documentSnapshot});
  final DocumentSnapshot documentSnapshot;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String locationName = documentSnapshot.get('name');

    return AppBar(
      title: Text(locationName),
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
  const DetailViewBody({super.key, required this.documentSnapshot});
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    String locationName = documentSnapshot.get('name');
    String locationImageUrl = documentSnapshot.get('imageUrl');
    String locationDescription = documentSnapshot.get('description');
    double locationRating = documentSnapshot.get('rating');

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
                locationName,
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
                documentSnapshot: documentSnapshot,
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              DetailViewMapPreview(documentSnapshot: documentSnapshot),
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

class DetailViewActionButtonContainer extends StatelessWidget {
  const DetailViewActionButtonContainer({
    super.key,
    required this.documentSnapshot,
  });

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DetailViewActionButton(
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          label: 'Favorite',
        ),
        DetailViewActionButton(
          icon: Icons.location_on_outlined,
          label: 'Map',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MapView(documentSnapshot: documentSnapshot);
                },
              ),
            );
          },
        ),
        DetailViewActionButton(
          // TODO: implement directions to location.
          icon: Icons.directions_outlined,
          label: 'Directions',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MapView(documentSnapshot: documentSnapshot);
                },
              ),
            );
          },
        ),
        DetailViewActionButton(
          icon: Icons.star_outline,
          label: 'Reviews',
          onTap: () {
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
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final VoidCallback? onTap;

  @override
  State<DetailViewActionButton> createState() => _DetailViewActionButtonState();
}

class _DetailViewActionButtonState extends State<DetailViewActionButton> {
  bool active = false;
  IconData? currentIcon;

  @override
  void initState() {
    super.initState();
    currentIcon ??= widget.icon;
  }

  void onTap() {
    if (widget.onTap != null) widget.onTap!();
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
  const DetailViewMapPreview({super.key, required this.documentSnapshot});
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final GeoPoint locationGeoPoint = documentSnapshot.get('geopoint');

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
                  return MapView(documentSnapshot: documentSnapshot);
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
