import 'package:citiguide_user/utils/constants.dart';
import 'package:citiguide_user/view/detail_view.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// FIXME: search currently only works on 'Hotels' category of the selected city,
// it needs to be able to search through all categories.
// idk if it should search in cities other than the selected city.
class SearchPageAppBar extends StatelessWidget {
  const SearchPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({super.key});

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  final TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  bool loading = false;

  Future<void> searchItems(String query) async {
    setState(() {
      loading = true;
      searchResults.clear();
    });

    try {
      final CollectionReference itemsCollection = FirebaseFirestore.instance
          .collection('cities')
          .doc(selectedCity)
          .collection('categories')
          .doc('Hotels')
          .collection('locations');

      final QuerySnapshot snapshot = await itemsCollection
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThan: '${query.toLowerCase()}z')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          searchResults =
              snapshot.docs.map((doc) => doc['name'] as String).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching. Please try again later.')),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                searchItems(value);
              } else {
                setState(() => searchResults.clear());
              }
            },
            decoration: const InputDecoration(
              hintText: 'Search Locations...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            )
          else if (searchController.text.isNotEmpty && searchResults.isEmpty)
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('No result found.'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index]),
                    onTap: () {
                      print('Tapped: ${searchResults[index]}');
                      searchController.clear();
                      setState(() => searchResults.clear());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailView(
                            category: 'Hotels',
                            locationName: searchResults[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
