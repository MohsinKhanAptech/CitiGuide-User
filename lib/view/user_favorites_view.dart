import 'package:citiguide_user/components/primary_tile.dart';
import 'package:citiguide_user/view/sign_in_view.dart';
import 'package:citiguide_user/utils/constants.dart';

import 'package:flutter/material.dart';

class UserFavoritesView extends StatelessWidget {
  const UserFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: UserFavoritesViewBody(),
      ),
    );
  }
}

class UserFavoritesViewBody extends StatefulWidget {
  const UserFavoritesViewBody({super.key});

  @override
  State<UserFavoritesViewBody> createState() => _UserFavoritesViewBodyState();
}

class _UserFavoritesViewBodyState extends State<UserFavoritesViewBody> {
  bool loading = true;

  @override
  void initState() {
    super.initState();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (!userSignedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 64),
            SizedBox(height: 12),
            Text(
              'You need to sign-in to view you favorites.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInView()),
                );
              },
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
              child: Text('Sign-in', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    } else if (userFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.heart_broken_rounded, size: 64),
            SizedBox(height: 12),
            Text(
              'You haven\'t favorited any locations yet.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: userFavorites.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: PrimaryTile(
              cityID: userFavorites.elementAt(index).split('-')[0],
              categoryID: userFavorites.elementAt(index).split('-')[1],
              locationID: userFavorites.elementAt(index).split('-')[2],
            ),
          );
        },
      );
    }
  }
}
