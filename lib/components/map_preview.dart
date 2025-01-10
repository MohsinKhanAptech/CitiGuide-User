import 'package:citiguide_user/view/map_view.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key, required this.locationSnap});
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
                builder: (context) => MapView(locationSnap: locationSnap),
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
