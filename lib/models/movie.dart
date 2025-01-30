class Movie {
  final String? id;
  final String title;
  final String? synopsis;
  final String? posterPath;
  final List<String>? genres;
  final List<String>? streamingPlatforms;
  final double? imdbRating;
  final String? duration;
  final DateTime? releaseDate;
  final bool isWatched;
  final double? userRating;
  final List<Comment>? comments;
  final String? weatherCategory; // Field for weather category
  final List<String>? cast; // Field for cast

  Movie({
    this.id,
    required this.title,
    this.synopsis,
    this.posterPath,
    this.genres,
    this.streamingPlatforms,
    this.imdbRating,
    this.duration,
    this.releaseDate,
    this.isWatched = false,
    this.userRating,
    this.comments,
    this.weatherCategory, // Include it in the constructor
    this.cast, // Include it in the constructor
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id']?.toString(), // Ensure ID is always treated as String
      title: json['title'] ?? '',
      synopsis: json['synopsis'] as String?,
      posterPath:
          json['posterPath']?.toString() ?? '', // Ensure posterPath is String
      genres: (json['genres'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      streamingPlatforms: (json['streamingPlatforms'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      imdbRating: (json['imdbRating'] as num?)?.toDouble(),
      duration: json['duration']?.toString(), // Ensure duration is String
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'].toString())
          : null,
      isWatched: json['isWatched'] ?? false,
      userRating: (json['userRating'] as num?)?.toDouble(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList(),
      weatherCategory: json['weatherCategory']
          ?.toString(), // Ensure weatherCategory is String
      cast: (json['cast'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'posterPath': posterPath,
      'genres': genres,
      'streamingPlatforms': streamingPlatforms,
      'imdbRating': imdbRating,
      'duration': duration,
      'releaseDate': releaseDate?.toIso8601String(),
      'isWatched': isWatched,
      'userRating': userRating,
      'comments': comments?.map((comment) => comment.toJson()).toList(),
      'weatherCategory': weatherCategory, // Include in JSON conversion
      'cast': cast, // Include the cast in JSON conversion
    };
  }
}

class Comment {
  final String? text;
  final String? user;

  Comment({
    this.text,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'] as String?,
      user: json['user'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'user': user,
    };
  }
}
