import 'package:flutter/material.dart';
import 'package:recipe_it/pages/search/widgets/search_list.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SearchList(searchText: searchController.text),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            suffix: SizedBox(
              width: 20,
              height: 20,
              child: searchController.text.isNotEmpty
                  ? IconButton.filled(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.clear, size: 16),
                      padding: EdgeInsets.zero,
                    )
                  : null,
            ),
          ),
          maxLines: null,
          autofocus: true,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
