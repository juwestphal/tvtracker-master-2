import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/movie.dart';
import 'package:flutter_movieseriestracker/screens/comments_movies_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  MovieDetailsScreenState createState() => MovieDetailsScreenState();
}

class MovieDetailsScreenState extends State<MovieDetailsScreen> {
  // State storage for watched and favorite status by movie ID
  static final Map<String, bool> watchedStatus = {};
  static final Map<String, bool> favoriteStatus = {};

  double userRating = 0.0;
  bool isWatched = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Initialize from stored state, or default to false if not yet set
    isWatched = watchedStatus[widget.movie.id!] ?? false;
    isFavorite = favoriteStatus[widget.movie.id!] ?? false;
  }

  void setUserRating(double rating) {
    setState(() {
      userRating = rating;
    });
  }

  void toggleWatchedStatus() {
    setState(() {
      isWatched = !isWatched;
      watchedStatus[widget.movie.id!] = isWatched;
    });
  }

  void toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
      favoriteStatus[widget.movie.id!] = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Movie poster and overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie poster
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      (widget.movie.posterPath?.isNotEmpty ?? false)
                          ? Image.asset(
                              widget.movie.posterPath!,
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
                              width: 150,
                              height: 220,
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ],
                  ),
                  // Movie details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Duration and genres with icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ' • ${widget.movie.duration ?? "Duração não disponível"}',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    '•  ${widget.movie.genres?.join(", ") ?? "Gêneros não disponíveis"}',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isWatched
                                        ? Icons.check
                                        : Icons.remove_red_eye,
                                    color: isWatched
                                        ? Colors.green
                                        : Colors.white70,
                                  ),
                                  onPressed: toggleWatchedStatus,
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.white70,
                                  ),
                                  onPressed: toggleFavoriteStatus,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24),
                        // Streaming platforms
                        const Text(
                          'Onde ver',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children:
                              widget.movie.streamingPlatforms?.map((platform) {
                                    return ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                      child: Text(platform),
                                    );
                                  }).toList() ??
                                  [],
                        ),
                        const SizedBox(height: 20),
                        // Synopsis
                        const Text(
                          'Sinopse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.movie.synopsis ?? 'Sinopse não disponível',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        // Cast (elenco)
                        const Text(
                          'Elenco',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // IMDb rating
                        const Text(
                          'Avaliação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'IMDb: ${widget.movie.imdbRating?.toStringAsFixed(1) ?? "N/A"}/10',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => GestureDetector(
                              onTap: () => setUserRating(index + 1.0),
                              child: Icon(
                                index < userRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24),
                        // Comments section
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsPopup(movie: widget.movie)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Comentários',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${widget.movie.comments?.length ?? 0}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
