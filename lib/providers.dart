import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void ontap(int index) {
    _currentPage = index;
    notifyListeners();
  }
}

class TVShowProvider with ChangeNotifier {
  List _shows = [];
  bool _isLoading = true;

  List get shows => _shows;
  bool get isLoading => _isLoading;

  TVShowProvider() {
    fetchShows();
  }

  Future<void> fetchShows() async {
    _isLoading = true;
    try {
      final response = await http
          .get(Uri.parse("https://api.tvmaze.com/search/shows?q=all"));
      if (response.statusCode == 200) {
        _shows = json.decode(response.body);
      } else {
        throw Exception('Failed to load shows');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class SearchProvider with ChangeNotifier {
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  List<dynamic> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> searchShows(String searchTerm) async {
    _isLoading = true;
    notifyListeners();

    final url = 'https://api.tvmaze.com/search/shows?q=$searchTerm';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _searchResults = data.map((item) => item['show']).toList();
      } else {
        // Handle error
        _searchResults = [];
      }
    } catch (error) {
      // Handle error
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
