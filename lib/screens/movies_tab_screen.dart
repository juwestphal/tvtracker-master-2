import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/movie.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';
import 'movies_details_screen.dart';

class MoviesTabScreen extends StatefulWidget {
  const MoviesTabScreen({super.key});

  @override
  MoviesTabScreenState createState() => MoviesTabScreenState();
}

class MoviesTabScreenState extends State<MoviesTabScreen> {
  int _selectedTab = 0; // Controla a aba selecionada
  List<Movie> watchLaterMovies = [];
  List<Movie> upcomingMovies = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final movies = await APIService().fetchMovies();
      setState(() {
        final referenceDate = DateTime(2025, 1, 25, 0, 0);
        watchLaterMovies = movies
            .map<Movie>((movie) => Movie.fromJson(movie))
            .where((movie) =>
                !(movie.isWatched) &&
                (movie.releaseDate == null ||
                    movie.releaseDate!.isBefore(referenceDate) ||
                    movie.releaseDate!.isAtSameMomentAs(referenceDate)))
            .toList();

        upcomingMovies = movies
            .map<Movie>((movie) => Movie.fromJson(movie))
            .where((movie) =>
                !(movie.isWatched) &&
                movie.releaseDate != null &&
                movie.releaseDate!.isAfter(referenceDate))
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar filmes: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Column(
                children: [
                  Text(
                    'Ver mais tarde',
                    style: TextStyle(
                      color: _selectedTab == 0 ? Colors.red : Colors.white,
                    ),
                  ),
                  if (_selectedTab == 0)
                    Container(
                      height: 2,
                      width: 100,
                      color: Colors.red,
                    )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Column(
                children: [
                  Text(
                    'Brevemente',
                    style: TextStyle(
                      color: _selectedTab == 1 ? Colors.red : Colors.white,
                    ),
                  ),
                  if (_selectedTab == 1)
                    Container(
                      height: 2,
                      width: 100,
                      color: Colors.red,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _selectedTab == 0
                  ? _buildMoviesGrid(watchLaterMovies)
                  : _buildMoviesGrid(upcomingMovies),
    );
  }

  Widget _buildMoviesGrid(List<Movie> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index]; // Get the current movie
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Check if posterPath is valid for each movie
                      (movie.posterPath?.isNotEmpty ?? false)
                          ? Image.asset(
                              movie.posterPath!,
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
                                Icons.image_not_supported, // Fallback icon
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
                movie.title,
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
