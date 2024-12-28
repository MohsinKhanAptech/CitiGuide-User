import 'package:citiguide_user/pages/settings_view_pages/change_region_page.dart';

import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SettingsViewAppBar(page: page),
        body: SettingsViewBodyHandler(page: page),
      ),
    );
  }
}

class SettingsViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsViewAppBar({super.key, required this.page});
  final int page;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        [
          'Change Region',
        ][page],
      ),
    );
  }
}

class SettingsViewBodyHandler extends StatelessWidget {
  const SettingsViewBodyHandler({super.key, required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return [
      ChangeRegionPage(),
    ][page];
  }
}
