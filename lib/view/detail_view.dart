import 'package:flutter/material.dart';
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
            const PopupMenuItem(
              child: Text('menu option'),
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
          height: 250,
          color: Colors.grey.shade400,
          child: Center(
            child: Text('Location image'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
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
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DetailViewActionButton(
                    icon: Icons.favorite_outline,
                    activeIcon: Icons.favorite,
                    label: 'Favorite',
                  ),
                  DetailViewActionButton(
                    icon: Icons.location_on_outlined,
                    label: 'Open Maps',
                    onTap: () {
                      MapsLauncher.launchQuery(
                        'Aptech Computer Education North Karachi Center',
                      );
                    },
                  ),
                  DetailViewActionButton(
                    icon: Icons.star_outline,
                    activeIcon: Icons.star,
                    label: 'Reviews',
                  ),
                  DetailViewActionButton(
                    icon: Icons.report_outlined,
                    activeIcon: Icons.report,
                    label: 'Report',
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 250,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Location in map'),
                ),
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 24),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < 5; i++) Icon(Icons.star_rounded),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              for (var i = 0; i < 5; i++) ReviewCard(),
            ],
          ),
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
