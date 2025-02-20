import 'package:citiguide_user/utils/extensions.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapView extends StatelessWidget {
  const MapView({super.key, required this.locationSnap});
  final DocumentSnapshot locationSnap;

  @override
  Widget build(BuildContext context) {
    final String locationName = locationSnap.get('name');
    final GeoPoint locationGeoPoint = locationSnap.get('geopoint');

    return SafeArea(
      child: Scaffold(
        appBar: MapViewAppBar(locationName: locationName),
        body: MapViewBody(
          locationLat: locationGeoPoint.latitude,
          locationLng: locationGeoPoint.longitude,
        ),
      ),
    );
  }
}

class MapViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapViewAppBar({super.key, required this.locationName});
  final String locationName;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(locationName.toTitleCase));
  }
}

class MapViewBody extends StatelessWidget {
  const MapViewBody({
    super.key,
    required this.locationLat,
    required this.locationLng,
  });
  final double locationLat;
  final double locationLng;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(locationLat, locationLng),
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(locationLat, locationLng),
              rotate: true,
              alignment: Alignment(0, -1),
              child: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
