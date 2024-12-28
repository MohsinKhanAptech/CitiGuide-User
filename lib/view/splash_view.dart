import 'package:citiguide_user/pages/splash_view_pages/welcome_page.dart';
import 'package:citiguide_user/pages/splash_view_pages/region_select_page.dart';

import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SplashPageHandler(),
      ),
    );
  }
}

class SplashPageHandler extends StatefulWidget {
  const SplashPageHandler({super.key});

  @override
  State<SplashPageHandler> createState() => _SplashPageHandlerState();
}

class _SplashPageHandlerState extends State<SplashPageHandler> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    void incrementPage() => setState(() => page++);

    return [
      WelcomePage(incrementPage: incrementPage),
      RegionSelectPage(incrementPage: incrementPage),
    ][page];
  }
}
