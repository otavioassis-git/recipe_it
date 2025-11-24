import 'package:flutter/material.dart';
import 'package:recipe_it/l10n/app_localizations.dart';
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
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SearchList(searchText: searchController.text),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.inversePrimary,
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: text.search,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            child: Icon(Icons.clear),
                            onTap: () {
                              searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
