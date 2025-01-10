import 'package:citiguide_user/utils/constants.dart';
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
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];
  bool loading = false;
  String selectedCategory = categories.elementAt(0);
  String selectedCategoryID = categoriesID.elementAt(0);

  // TODO: add global search, to search through every category.
  Future<void> searchLocations(String query) async {
    setState(() {
      loading = true;
      searchResults.clear();
    });

    try {
      CollectionReference locationsRef = citiesRef
          .doc(selectedCityID)
          .collection('categories')
          .doc(selectedCategoryID)
          .collection('locations');
      QuerySnapshot locationsSnap = await locationsRef
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThan: '${query.toLowerCase()}z')
          .get();

      for (var location in locationsSnap.docs) {
        searchResults.add({
          'name': location.get('name'),
          'categoryID': selectedCategoryID,
          'locationID': location.id,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('Search request failed, please try again.'),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> changeCategory(String category) async {
    selectedCategory = category;
    selectedCategoryID = categoriesID.elementAt(
      categories.toList().indexOf(category),
    );
    searchController.clear();
    setState(() {
      searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      searchLocations(value);
                    } else {
                      setState(() => searchResults.clear());
                    }
                  },
                  decoration: const InputDecoration(
                    label: Text('Search'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 12),
              DropdownMenu(
                width: 160,
                menuHeight: 200,
                label: Text('category'),
                onSelected: (String? value) => changeCategory(value!),
                initialSelection: selectedCategory,
                dropdownMenuEntries: [
                  for (var i = 0; i < categories.length; i++)
                    DropdownMenuEntry(
                      value: categories.elementAt(i),
                      label: categories.elementAt(i).toTitleCase,
                    ),
                ],
              ),
            ],
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
                    title: Text(searchResults[index]['name']!.toTitleCase),
                    onTap: () {
                      searchController.clear();
                      setState(() => searchResults.clear());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailView(
                            categoryID: searchResults[index]['categoryID']!,
                            locationID: searchResults[index]['locationID']!,
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
