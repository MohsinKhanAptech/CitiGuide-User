import 'package:citiguide_user/view/detail_view.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchItems(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults.clear(); // Clear previous results
    });

    try {
      final CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('locations');

      // Perform a case-insensitive search using a where clause.
      // Important: Ensure you have a composite index on the field you are querying for better performance.
      // In Firebase console, go to "Indexes" and create one if needed.
      final QuerySnapshot snapshot = await itemsCollection
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name',
              isLessThan: '${query.toLowerCase()}z') // Efficient prefix search
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _searchResults =
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                _searchItems(value);
              } else {
                setState(() {
                  // Clear suggestions when input is empty
                  _searchResults.clear();
                });
              }
            },
            decoration: const InputDecoration(
              hintText: 'Search Locations...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_searchResults[index]),
                        onTap: () {
                          // Handle item tap, e.g., navigate to item details
                          print('Tapped: ${_searchResults[index]}');
                          _searchController.clear();
                          setState(() => _searchResults.clear());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailView()),
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
