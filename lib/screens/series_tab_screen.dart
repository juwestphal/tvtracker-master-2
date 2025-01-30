import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/models/series.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';
import 'series_details_screen.dart';

class SeriesTabScreen extends StatefulWidget {
  const SeriesTabScreen({super.key});

  @override
  SeriesTabScreenState createState() => SeriesTabScreenState();
}

class SeriesTabScreenState extends State<SeriesTabScreen> {
  int _selectedTab = 0; // 0 = "Watch Later", 1 = "Coming Soon"
  List<Series> watchLaterSeries = [];
  List<Series> upcomingSeries = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSeries();
  }

  Future<void> fetchSeries() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final seriesList = await APIService().fetchSeries();

      setState(() {
        final referenceDate = DateTime(2025, 1, 25, 0, 0);
        watchLaterSeries = seriesList
            .map<Series>(
                (s) => s is Map<String, dynamic> ? Series.fromJson(s) : s)
            .where((series) =>
                !(series.isWatched) &&
                (series.releaseDate == null ||
                    series.releaseDate!.isBefore(referenceDate)))
            .toList();

        upcomingSeries = seriesList
            .map<Series>(
                (s) => s is Map<String, dynamic> ? Series.fromJson(s) : s)
            .where((series) =>
                !(series.isWatched) &&
                series.releaseDate != null &&
                series.releaseDate!.isAfter(referenceDate))
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar séries: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                    ),
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
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : _selectedTab == 0
                  ? _buildSeriesList(watchLaterSeries)
                  : _buildSeriesList(upcomingSeries),
    );
  }

  Widget _buildSeriesList(List<Series> seriesList) {
    return ListView.builder(
      itemCount: seriesList.length,
      itemBuilder: (context, index) {
        final series = seriesList[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeriesDetailsScreen(series: series),
            ),
          ),
          child: Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: (series.posterPath?.isNotEmpty ?? false)
                        ? Image.asset(
                            series.posterPath!, // Ensure the path is correct
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          series.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Temporada ${series.season ?? 'N/A'}, Episódios ${series.seasons?.length ?? 'N/A'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
