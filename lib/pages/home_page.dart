import 'package:assignment/pages/detail_page.dart';
import 'package:assignment/providers.dart';
import 'package:assignment/pages/search_page.dart';
import 'package:assignment/widgets/hero_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tvShowProvider = Provider.of<TVShowProvider>(context);
    if (tvShowProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.grey),
        ),
      );
    }

    final shows = tvShowProvider.shows;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Provider.of<BottomNavigationProvider>(context).currentPage == 0
          ? _bodyWidget(context, shows)
          : SearchPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: Provider.of<BottomNavigationProvider>(context).ontap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        currentIndex:
            Provider.of<BottomNavigationProvider>(context).currentPage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, List shows) {
    // Categorized show data
    final popularShows = shows.take(4).toList();
    final dramaShows = shows
        .where((show) => show['show']['genres'].contains('Drama'))
        .toList();
    final sportsShows = shows
        .where((show) => show['show']['genres'].contains('Sports'))
        .toList();
    final comedyShows = shows
        .where((show) => show['show']['genres'].contains('Comedy'))
        .toList();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                'Welcome here...!',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
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
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SearchPage()));
                },
              ),
            ),

            // Hero Section
            HeroSection(popularShows: popularShows),

            const SizedBox(height: 12),

            // Genre Sections
            _buildHorizontalList('Drama Shows', dramaShows),
            _buildHorizontalList('Sports Shows', sportsShows),
            _buildHorizontalList('Comedy Shows', comedyShows),

            // All Shows Section
            _buildHorizontalList('All Shows', shows),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList(String title, List shows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index]['show'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPage(show: show)));
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          show['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
