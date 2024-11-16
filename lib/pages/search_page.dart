import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment/providers.dart'; // Adjust based on your actual provider import
import 'package:assignment/pages/detail_page.dart'; // Import your detail page

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Shows'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Search for shows...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    searchProvider.searchShows(value);
                  }
                },
              ),
            ),

            // Loading Indicator
            if (searchProvider.isLoading)
              const Center(
                  child: CircularProgressIndicator(color: Colors.grey)),

            // Display Search Results
            Expanded(
              child: ListView.builder(
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final show = searchProvider.searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Detail Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(show: show),
                        ),
                      );
                    },
                    child: Container(
                      height: 140,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: show['image'] != null
                                ? Image.network(
                                    show['image']['medium'],
                                    height: 140,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 140,
                                    width: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image,
                                        color: Colors.black),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    show['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16, bottom: 10),
                                  child: Text(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    show['summary'] != null
                                        ? show['summary'].replaceAll(
                                            RegExp(r'<[^>]*>'),
                                            '') // Remove HTML tags
                                        : 'No summary available',
                                    style: const TextStyle(
                                        color: Colors.black45, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
