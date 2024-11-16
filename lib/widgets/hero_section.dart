import 'package:assignment/pages/detail_page.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatefulWidget {
  final List popularShows;

  const HeroSection({super.key, required this.popularShows});

  @override
  HeroSectionState createState() => HeroSectionState();
}

class HeroSectionState extends State<HeroSection> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sliding Images
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: widget.popularShows.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final show = widget.popularShows[index]['show'];
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), // Round corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withValues(alpha: 0.5), // Shadow color
                        blurRadius: 8, // Blur effect
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Show Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: show['image'] != null
                            ? Image.network(
                                show['image']['original'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Center(
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.white10, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),

                      // Show Name
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Text(
                          show['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Dots Indicator
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.popularShows.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 16 : 8, // Active dot is wider
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.black
                      : Colors.grey.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
