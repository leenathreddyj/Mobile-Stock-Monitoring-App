import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,                                   // key parameter
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),               // const EdgeInsets
      child: _SearchField(),
    );
  }
}

/// Isolated so the outer Padding can stay const.
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final searchBar =
        context.findAncestorWidgetOfExactType<SearchBar>() as SearchBar;

    return TextField(
      controller: searchBar.controller,
      decoration: InputDecoration(
        hintText: 'Search for a stock…',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => searchBar.onSearch(searchBar.controller.text),
        ),
      ),
    );
  }
}
