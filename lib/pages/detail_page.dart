import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map show;

  const DetailPage({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          show['name'] ?? 'Show Details',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show Poster
              if (show['image'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      show['image']['original'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Show Title
              Text(
                show['name'] ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Genres
              if (show['genres'] != null)
                Text(
                  'Genres: ${show['genres'].join(', ')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

              const SizedBox(height: 12),

              // Language, Status, Premiere, Runtime
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem('Language', show['language']),
                  _buildInfoItem('Status', show['status']),
                  _buildInfoItem('Premiere', show['premiered']),
                  _buildInfoItem('Runtime', '${show['runtime'] ?? " -"} min'),
                ],
              ),

              const SizedBox(height: 20),

              // Summary
              const Text(
                'Summary',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                show['summary'] != null
                    ? show['summary']
                        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
                    : 'No summary available',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // Official Site Link
              if (show['officialSite'] != null)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Open Official Site
                      final url = show['officialSite'];
                      if (url != null) {
                        // Use url_launcher or similar plugin to open link
                      }
                    },
                    child: const Text(
                      'Visit Official Site',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget to Build Info Items
  Widget _buildInfoItem(String title, String? value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
