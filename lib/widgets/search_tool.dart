import 'package:flutter/material.dart';

class SearchTool extends StatelessWidget {
  const SearchTool({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Tools...',
          hintStyle: TextStyle(color: Colors.deepPurple.shade600),
          filled: true,
          fillColor: Colors.deepPurple.shade100,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Colors.deepPurple.shade600),
            onPressed: () {
              // Add search functionality
            },
          ),
        ),
      ),
    );
  }
}
