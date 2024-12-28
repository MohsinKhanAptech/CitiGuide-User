import 'package:citiguide_user/pages/main_view_pages/discover_page.dart';
import 'package:citiguide_user/pages/main_view_pages/search_page.dart';
import 'package:citiguide_user/pages/main_view_pages/more_page.dart';

import 'package:flutter/material.dart';

// NOTE: this view handles the main pages like discover, search, settings.
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;

  void onDestinationSelected(value) {
    setState(() => selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarHandler(
          selectedIndex: selectedIndex,
        ),
        body: BodyHandler(
          selectedIndex: selectedIndex,
        ),
        bottomNavigationBar: NavigationBarHandler(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}

class AppBarHandler extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHandler({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return const [
      DiscoverPageAppBar(),
      SearchPageAppBar(),
      MorePageAppBar(),
    ][selectedIndex];
  }
}

class BodyHandler extends StatelessWidget {
  const BodyHandler({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return const [
      DiscoverPageBody(),
      SearchPageBody(),
      MorePageBody(),
    ][selectedIndex];
  }
}

class NavigationBarHandler extends StatelessWidget {
  const NavigationBarHandler({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final Function onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => onDestinationSelected(index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.location_on_outlined),
          selectedIcon: Icon(Icons.location_on),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz_outlined),
          selectedIcon: Icon(Icons.more_horiz),
          label: 'Options',
        ),
      ],
    );
  }
}
