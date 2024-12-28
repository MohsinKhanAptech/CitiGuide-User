import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MapViewAppBar(),
        body: MapViewBody(),
      ),
    );
  }
}

class MapViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapViewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Map'),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('menu option'),
            ),
          ],
        ),
      ],
    );
  }
}

class MapViewBody extends StatelessWidget {
  const MapViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(24.982172028874995, 67.06525296794702),
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
              point: LatLng(24.982172028874995, 67.06525296794702),
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
