import 'package:citiguide_user/pages/main_view_pages/discover_page.dart';
import 'package:citiguide_user/pages/main_view_pages/options_page.dart';
import 'package:citiguide_user/pages/main_view_pages/search_page.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;
  bool canExit = false;

  void onDestinationSelected(value) {
    setState(() => selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canExit,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            if (selectedIndex == 0) {
              canExit = true;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('Press again to exit')),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            }
            selectedIndex = 0;
          });
          Timer(Duration(milliseconds: 1500), () {
            setState(() => canExit = false);
          });
        }
      },
      child: SafeArea(
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
      OptionsPageAppBar(),
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
      OptionsPageBody(),
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
