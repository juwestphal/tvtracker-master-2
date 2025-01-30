import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/series.dart';
import 'package:flutter_movieseriestracker/screens/comments_series_screen.dart';
import 'package:flutter_movieseriestracker/screens/seasons_screen.dart';

class SeriesDetailsScreen extends StatefulWidget {
  final Series series;

  const SeriesDetailsScreen({super.key, required this.series});

  @override
  State<SeriesDetailsScreen> createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  double userRating = 0.0;
  bool isFavorite = false;

  void setUserRating(double rating) {
    setState(() {
      userRating = rating;
    });
  }

  void toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.series.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeasonsPage(series: widget.series),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Series poster and overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Series poster
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      (widget.series.posterPath?.isNotEmpty ?? false)
                          ? Image.asset(
                              widget.series.posterPath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: double.infinity,
                                height: 150,
                                color: Colors.grey,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 150,
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ],
                  ),
                  // Series details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Genres with heart icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '• ${widget.series.genres?.join(", ") ?? "Gêneros não disponíveis"}',
                                style: const TextStyle(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white70,
                              ),
                              onPressed: toggleFavoriteStatus,
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
                              widget.series.streamingPlatforms?.map((platform) {
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
                          widget.series.synopsis ?? 'Sinopse não disponível',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        // Cast
                        const Text(
                          'Elenco',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.series.cast?.join(", ") ??
                              'Elenco não disponível',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        // Rating
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
                          'IMDb: ${widget.series.imdbRating?.toStringAsFixed(1) ?? "N/A"}/10',
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
                                  builder: (context) => CommentsSeriesScreen(
                                        series: widget.series,
                                      )),
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
                                    '${widget.series.comments?.length ?? 0}',
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
