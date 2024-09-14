import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController searchController;
  final String hintText;

  const SearchBox(
      {super.key, required this.searchController, this.hintText = 'Search'});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 35,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}
