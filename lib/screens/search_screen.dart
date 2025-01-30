import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/movie.dart';
import 'package:flutter_movieseriestracker/models/series.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';
import 'movies_details_screen.dart';
import 'series_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<dynamic> allContent = [];
  bool isLoading = false;
  String errorMessage = '';
  String selectedGenre = 'all';
  String selectedPlatform = 'all';

  @override
  void initState() {
    super.initState();
    fetchAllContent();
  }

  Future<void> fetchAllContent() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch movies
      final movies = (await APIService().fetchMovies())
          .map((m) => Movie.fromJson(m))
          .toList();

      // Fetch series
      final series = (await APIService().fetchSeries())
          .map<Series>(
              (s) => s is Map<String, dynamic> ? Series.fromJson(s) : s)
          .toList();

      // Combine movies and series
      setState(() {
        allContent = [...movies, ...series];
        searchResults = allContent; // Initialize searchResults with all content
        isLoading = false;
      });
    } catch (e) {
      // Handle errors
      setState(() {
        errorMessage = 'Erro ao carregar conteúdo: $e';
        isLoading = false;
      });
    }
  }

  void performSearch(String query) {
    setState(() {
      searchResults = allContent.where((item) {
        final title = (item is Movie) ? item.title : (item as Series).title;
        final matchesQuery =
            query.isEmpty || title.toLowerCase().contains(query.toLowerCase());
        final matchesGenre = selectedGenre == 'all' ||
            (item is Movie &&
                (item.genres?.contains(selectedGenre) ?? false)) ||
            (item is Series && (item.genres?.contains(selectedGenre) ?? false));
        final matchesPlatform = selectedPlatform == 'all' ||
            (item is Movie &&
                (item.streamingPlatforms ?? []).contains(selectedPlatform)) ||
            (item is Series &&
                (item.streamingPlatforms ?? []).contains(selectedPlatform));
        return matchesQuery && matchesGenre && matchesPlatform;
      }).toList();
    });
  }

  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedGenre,
                onChanged: (value) {
                  if (value != null && value != selectedGenre) {
                    setState(() {
                      selectedGenre = value;
                      performSearch(_searchController.text);
                    });
                  }
                },
                items: <String>[
                  'all',
                  'action',
                  'adventure',
                  'comedy',
                  'crime',
                  'drama',
                  'family',
                  'fantasy',
                  'horror',
                  'mystery',
                  'romance',
                  'scifi',
                  'thriller',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedPlatform,
                onChanged: (value) {
                  if (value != null && value != selectedPlatform) {
                    setState(() {
                      selectedPlatform = value;
                      performSearch(_searchController.text);
                    });
                  }
                },
                items: <String>[
                  'all',
                  'Amazon Prime Video',
                  'Apple Tv',
                  'Disney+',
                  'HBO Max',
                  'Netflix'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O que ver a seguir?')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome do filme ou série',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: performSearch,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: showFilterOptions,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage))
            else
              Expanded(
                child: _buildContentGrid(searchResults),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid(List<dynamic> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final title = (item is Movie) ? item.title : (item as Series).title;
        final posterPath =
            (item is Movie) ? item.posterPath : (item as Series).posterPath;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => item is Movie
                    ? MovieDetailsScreen(movie: item)
                    : SeriesDetailsScreen(series: item),
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      posterPath != null && posterPath.isNotEmpty
                          ? Image.asset(
                              posterPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 150,
                                height: 220,
                                color: Colors.grey,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
