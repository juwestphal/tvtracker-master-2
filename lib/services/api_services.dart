import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// A service class for interacting with the API endpoints.
class APIService {
  final String baseUrl = APIConfig.baseUrl;

  Map<String, String> get defaultHeaders =>
      {'Content-Type': 'application/json'};

  dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Error: ${response.statusCode} - ${response.reasonPhrase}\nBody: ${response.body}');
    }
  }

  // ------------------ Movies ------------------

  Future<List<dynamic>> fetchMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies'));
    return handleResponse(response);
  }

  Future<dynamic> fetchMovieById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/movies/$id'));
    return handleResponse(response);
  }

  Future<void> createMovie(Map<String, dynamic> movieData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movies'),
      headers: defaultHeaders,
      body: json.encode(movieData),
    );
    handleResponse(response);
  }

  Future<void> updateMovie(String id, Map<String, dynamic> movieData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/movies/$id'),
      headers: defaultHeaders,
      body: json.encode(movieData),
    );
    handleResponse(response);
  }

  Future<void> deleteMovie(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/movies/$id'));
    handleResponse(response);
  }

  Future<void> updateMovieWatchStatus(String movieId, bool isWatched) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/movies/$movieId/watched'),
      headers: defaultHeaders,
      body: json.encode({'isWatched': isWatched}),
    );
    handleResponse(response);
  }

  Future<void> updateMovieFavoriteStatus(
      String movieId, bool isFavorite) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/movies/$movieId/favorite'),
      headers: defaultHeaders,
      body: json.encode({'isFavorite': isFavorite}),
    );
    handleResponse(response);
  }

  // ------------------ Series ------------------

  Future<List<dynamic>> fetchSeries() async {
    final response = await http.get(Uri.parse('$baseUrl/series'));
    if (response.statusCode == 200) {
      return json.decode(response.body); // Return raw JSON data
    } else {
      throw Exception('Failed to load series');
    }
  }

  Future<dynamic> fetchSeriesDetails(String seriesId) async {
    final response = await http.get(Uri.parse('$baseUrl/series/$seriesId'));
    return handleResponse(response);
  }

  Future<void> deleteSeries(String seriesId) async {
    final response = await http.delete(Uri.parse('$baseUrl/series/$seriesId'));
    handleResponse(response);
  }

  Future<void> updateEpisode({
    required String seriesId,
    required int seasonNumber,
    required int episodeNumber,
    required bool isWatched,
  }) async {
    final response = await http.patch(
      Uri.parse(
          '$baseUrl/series/$seriesId/seasons/$seasonNumber/episodes/$episodeNumber'),
      headers: defaultHeaders,
      body: json.encode({'isWatched': isWatched}),
    );
    handleResponse(response);
  }

  Future<void> updateFavoriteStatus(String seriesId, bool isFavorite) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/series/$seriesId/favorite'),
      headers: defaultHeaders,
      body: json.encode({'isFavorite': isFavorite}),
    );
    handleResponse(response);
  }

  Future<void> updateRating(String seriesId, double rating) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/series/$seriesId/rating'),
      headers: defaultHeaders,
      body: json.encode({'rating': rating}),
    );
    handleResponse(response);
  }

  // ------------------ Ratings ------------------

  Future<double?> getUserRating(String seriesId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/series/$seriesId/rating'));
    final data = handleResponse(response);
    return data['rating']?.toDouble();
  }

  Future<void> submitUserRating(String seriesId, double rating) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/series/$seriesId/rating'),
      headers: defaultHeaders,
      body: json.encode({'rating': rating}),
    );
    handleResponse(response);
  }

  // ------------------ Comments ------------------

  Future<List<dynamic>> fetchComments(String movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movies/$movieId/reviews'));
    return handleResponse(response);
  }

  Future<void> createComment(String movieId, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movies/$movieId/reviews'),
      headers: defaultHeaders,
      body: json.encode({'comment': comment}),
    );
    handleResponse(response);
  }

  Future<void> deleteComment(String movieId, String commentId) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/movies/$movieId/reviews/$commentId'));
    handleResponse(response);
  }

  Future<List<dynamic>> fetchSeriesComments(String seriesId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/series/$seriesId/reviews'));
    return handleResponse(response);
  }

  Future<void> createSeriesComment(String seriesId, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/series/$seriesId/reviews'),
      headers: defaultHeaders,
      body: json.encode({'comment': comment}),
    );
    handleResponse(response);
  }

  Future<void> deleteSeriesComment(String seriesId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/series/$seriesId/reviews'));
    handleResponse(response);
  }

  // ------------------ Users ------------------

  Future<List<dynamic>> fetchAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    return handleResponse(response);
  }

  Future<Map<String, dynamic>> fetchUserById(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    final parsed = handleResponse(response);
    if (parsed is List && parsed.isNotEmpty) {
      return parsed[0]; // Assuming the first object is the user
    }
    throw Exception("Unexpected response format");
  }

  Future<void> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: defaultHeaders,
      body: json.encode(userData),
    );
    handleResponse(response);
  }

  Future<dynamic> loginUser(Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: defaultHeaders,
      body: json.encode(credentials),
    );
    return handleResponse(response);
  }

  Future<void> deleteUserAccount(String userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));
    handleResponse(response);
  }

  Future<void> changePassword(Map<String, dynamic> passwordData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/change-password'),
      headers: defaultHeaders,
      body: json.encode(passwordData),
    );
    handleResponse(response);
  }

  // ------------------ Weather ------------------

  Future<dynamic> fetchWeather() async {
    final response = await http.get(Uri.parse('${APIConfig.baseUrl}/weather'));
    return handleResponse(response);
  }

  Future<void> addWeather(Map<String, dynamic> weatherData) async {
    final response = await http.post(
      Uri.parse('${APIConfig.baseUrl}/weather'),
      headers: defaultHeaders,
      body: json.encode(weatherData),
    );
    handleResponse(response);
  }

  Future<List<dynamic>> fetchMoviesByTemperature(double temperature) async {
    final response = await http.get(
      Uri.parse('${APIConfig.baseUrl}/movies'),
    );

    final movies = handleResponse(response);

    // Filter movies based on the temperature range
    final filteredMovies = movies.where((movie) {
      // Normalize weatherCategory to ensure it is always a String
      final weatherCategory = movie['weatherCategory'].toString();

      if (weatherCategory == 'sunny') {
        return temperature >= 25;
      } else if (weatherCategory == '15') {
        return temperature >= 10 && temperature < 20;
      } else if (weatherCategory == 'rainy') {
        return temperature >= 20 && temperature < 25;
      }
      // Add more categories as needed
      return false;
    }).toList();

    return filteredMovies;
  }
}
