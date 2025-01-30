import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/series.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';

class SeasonsPage extends StatelessWidget {
  final Series series;

  const SeasonsPage({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(series.title),
      ),
      body: ListView.builder(
        itemCount: series.seasons?.length ?? 0,
        itemBuilder: (context, index) {
          final season = series.seasons?[index];
          if (season == null) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Temporada ${season.seasonNumber}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodesPage(
                      season: season,
                      seriesTitle: series.title,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EpisodesPage extends StatefulWidget {
  final Season season;
  final String seriesTitle;

  const EpisodesPage({
    super.key,
    required this.season,
    required this.seriesTitle,
  });

  @override
  EpisodesPageState createState() => EpisodesPageState();
}

class EpisodesPageState extends State<EpisodesPage> {
  late List<bool> _episodeWatched;

  @override
  void initState() {
    super.initState();
    _episodeWatched =
        widget.season.episodes?.map((e) => e.isWatched).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.seriesTitle} - Temporada ${widget.season.seasonNumber}'),
      ),
      body: ListView.builder(
        itemCount: widget.season.episodes?.length ?? 0,
        itemBuilder: (context, index) {
          final episode = widget.season.episodes?[index];
          if (episode == null) return const SizedBox.shrink();

          return CheckboxListTile(
            title: Text('Episódio ${index + 1}: ${episode.title}'),
            subtitle: Text(episode.synopsis ?? 'Sem descrição'),
            value: _episodeWatched[index],
            onChanged: (bool? value) async {
              if (value != null) {
                setState(() {
                  _episodeWatched[index] = value;
                });

                // Update the watched status on the API
                await APIService().updateEpisode(
                  seriesId: widget.season.seriesId,
                  seasonNumber: widget.season.seasonNumber,
                  episodeNumber: index + 1,
                  isWatched: value,
                );

                // Show a confirmation snackbar
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Episódio atualizado com sucesso!'),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
