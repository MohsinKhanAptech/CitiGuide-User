import 'package:citiguide_user/view/map_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DetailViewAppBar(),
        body: DetailViewBody(),
      ),
    );
  }
}

class DetailViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailViewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Location Detail'),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Open in google maps'),
              onTap: () {
                MapsLauncher.launchQuery(
                  'Aptech Computer Education North Karachi Center',
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DetailViewBody extends StatelessWidget {
  const DetailViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 300,
          color: Colors.grey.shade400,
          child: Center(
            child: Text('Location image'),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location Name',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Location description',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              DetailViewActionButtonContainer(),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              DetailViewMapPreview(),
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
                        Text('5.0', style: TextStyle(fontSize: 18)),
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
            ],
          ),
        ),
      ],
    );
  }
}

class DetailViewActionButtonContainer extends StatelessWidget {
  const DetailViewActionButtonContainer({super.key});

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
              MaterialPageRoute(builder: (context) => MapView()),
            );
          },
        ),
        DetailViewActionButton(
          icon: Icons.directions_outlined,
          label: 'Directions',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapView()),
            );
          },
        ),
        DetailViewActionButton(
          icon: Icons.star_outline,
          label: 'Reviews',
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
  const DetailViewMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(24.982172028874995, 67.06525296794702),
          initialZoom: 18,
          minZoom: 16,
          maxZoom: 20,
          onTap: (tapPosition, latLng) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapView()),
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
              point: LatLng(24.982172028874995, 67.06525296794702),
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
