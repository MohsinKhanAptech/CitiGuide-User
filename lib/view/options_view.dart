import 'package:citiguide_user/pages/options_view_pages/change_region_page.dart';
import 'package:citiguide_user/pages/options_view_pages/about_page.dart';
import 'package:citiguide_user/pages/options_view_pages/help_page.dart';

import 'package:flutter/material.dart';

class OptionsView extends StatelessWidget {
  const OptionsView({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: OptionsViewAppBar(page: page),
        body: OptionsViewBodyHandler(page: page),
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
      ChangeRegionPage(),
      AboutPage(),
      HelpPage(),
    ][page];
  }
}
