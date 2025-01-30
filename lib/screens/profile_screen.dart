import 'package:flutter/material.dart';
import 'package:flutter_movieseriestracker/services/api_services.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  String errorMessage = '';
  String? currentWeather;
  Map<String, dynamic>? recommendedMovie;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchWeatherAndRecommendations();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = await APIService().fetchUserById(widget.userId);
      setState(() {
        userProfile = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar perfil: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherAndRecommendations() async {
    try {
      final response = await APIService().fetchWeather();

      final weatherData = response['weather'];
      if (weatherData == null || !weatherData.containsKey('temperature')) {
        setState(() {
          errorMessage = 'Temperature data is not available.';
        });
        return;
      }

      final double temperature = (weatherData['temperature'] as num).toDouble();

      // Fetch movies based on temperature
      final movies = await APIService().fetchMoviesByTemperature(temperature);

      // Debug: Log movies fetched based on temperature
      print('Movies recommended for $temperature°C: $movies');

      setState(() {
        currentWeather = '${temperature.toStringAsFixed(1)}°C';
        recommendedMovie = movies.isNotEmpty ? movies.first : null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching weather and recommendations: $e';
      });
    }
  }

  Future<void> logout() async {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : userProfile != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Olá, ${userProfile!['name'] ?? 'Usuário'}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Estatísticas
                          _buildStatsCard(
                            title: 'Episódios Vistos',
                            value: '120',
                            icon: Icons.play_arrow,
                            color: Colors.blue,
                          ),
                          _buildStatsCard(
                            title: 'Filmes Vistos',
                            value: '40',
                            icon: Icons.local_movies,
                            color: Colors.red,
                          ),
                          _buildStatsCard(
                            title: 'Tempo Total a Ver Séries',
                            value: '60h',
                            icon: Icons.timer,
                            color: Colors.purple,
                          ),
                          _buildStatsCard(
                            title: 'Tempo Total a Ver Filmes',
                            value: '20h',
                            icon: Icons.access_time,
                            color: Colors.orange,
                          ),

                          const SizedBox(height: 32),

                          // Temperatura e pôster do filme recomendado
                          if (currentWeather != null)
                            _buildWeatherRecommendationWidget(),

                          const SizedBox(height: 50),

                          // Botão de Logout
                          _buildLogoutButton(),
                        ],
                      ),
                    )
                  : const Center(child: Text("Perfil não encontrado")),
    );
  }

  Widget _buildWeatherRecommendationWidget() {
    final posterPath = recommendedMovie?['posterPath'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'A temperatura atual é $currentWeather. Recomendo assistir:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        if (posterPath != null && posterPath.startsWith('assets/movies/'))
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              posterPath,
              width: 150,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150,
                height: 220,
                color: Colors.grey,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          )
        else
          const Text(
            'Nenhum filme recomendado no momento',
            style: TextStyle(color: Colors.white70),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: logout,
      child: const Text(
        'Sair',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}
