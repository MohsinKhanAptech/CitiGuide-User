import 'package:citiguide_user/pages/options_view_pages/user_favorites_page.dart';
import 'package:citiguide_user/pages/options_view_pages/change_region_page.dart';
import 'package:citiguide_user/pages/options_view_pages/user_reviews_page.dart';
import 'package:citiguide_user/pages/options_view_pages/about_page.dart';
import 'package:citiguide_user/pages/options_view_pages/help_page.dart';

import 'package:flutter/material.dart';

enum OptionsViewPage {
  userFavorites,
  userReviews,
  changeRegion,
  about,
  help,
}

class OptionsView extends StatelessWidget {
  const OptionsView({super.key, required this.page});
  final OptionsViewPage page;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OptionsViewAppBar(page: page.index),
        body: OptionsViewBodyHandler(page: page.index),
      ),
    );
  }
}

class OptionsViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OptionsViewAppBar({super.key, required this.page});
  final int page;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        [
          'Your Favorites',
          'Your Reviews',
          'Change Region',
          'About',
          'Help',
        ][page],
      ),
    );
  }
}

class OptionsViewBodyHandler extends StatelessWidget {
  const OptionsViewBodyHandler({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return [
      UserFavoritesPage(),
      UserReviewsPage(),
      ChangeRegionPage(),
      AboutPage(),
      HelpPage(),
    ][page];
  }
}
