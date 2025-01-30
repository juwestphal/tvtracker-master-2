class Series {
  final String? id;
  final String title;
  final String? posterPath;
  final List<String>? genres;
  final String? synopsis;
  final double? imdbRating;
  final bool isWatched;
  final int? season;
  final DateTime? releaseDate;
  final List<Season>? seasons;
  final List<Comment>? comments;
  final List<String>? streamingPlatforms;
  final List<String>? cast;
  final double? userRating;

  Series({
    this.id,
    required this.title,
    this.posterPath,
    this.genres,
    this.synopsis,
    this.imdbRating,
    this.isWatched = false,
    this.season,
    this.releaseDate,
    this.seasons,
    this.comments,
    this.streamingPlatforms,
    this.cast,
    this.userRating,
  });

  // Construct Series from JSON
  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['_id'],
      title: json['title'],
      posterPath: json['posterPath'] ?? '',
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      synopsis: json['synopsis'] ?? '',
      imdbRating: (json['imdbRating'] as num?)?.toDouble(),
      isWatched: json['isWatched'] ?? false,
      season: json['season'],
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((s) => Season.fromJson(s))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromJson(c))
          .toList(),
      streamingPlatforms: json['streamingPlatforms'] != null
          ? List<String>.from(json['streamingPlatforms'])
          : null,
      cast: json['cast'] != null ? List<String>.from(json['cast']) : null,
      userRating: (json['userRating'] as num?)?.toDouble(),
    );
  }

  // Convert Series to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'posterPath': posterPath,
      'genres': genres,
      'synopsis': synopsis,
      'imdbRating': imdbRating,
      'isWatched': isWatched,
      'season': season,
      'releaseDate': releaseDate?.toIso8601String(),
      'seasons': seasons?.map((s) => s.toJson()).toList(),
      'comments': comments?.map((c) => c.toJson()).toList(),
      'streamingPlatforms': streamingPlatforms,
      'cast': cast,
      'userRating': userRating,
    };
  }
}

class Season {
  final int seasonNumber;
  final String seriesId;
  final List<Episode>? episodes;

  Season({
    required this.seasonNumber,
    required this.seriesId,
    this.episodes,
  });

  // Construct Season from JSON
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'] ?? 0,
      seriesId: json['seriesId'] ?? '',
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e))
          .toList(),
    );
  }

  // Convert Season to JSON
  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'seriesId': seriesId,
      'episodes': episodes?.map((e) => e.toJson()).toList(),
    };
  }
}

class Episode {
  final String title;
  final int? duration;
  final String? synopsis;
  final DateTime? releaseDate;
  final bool isWatched;

  Episode({
    required this.title,
    this.duration,
    this.synopsis,
    this.releaseDate,
    this.isWatched = false,
  });

  // Construct Episode from JSON
  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'] ?? '',
      duration: json['duration'],
      synopsis: json['synopsis'] ?? '',
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      isWatched: json['isWatched'] ?? false,
    );
  }

  // Convert Episode to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'synopsis': synopsis,
      'releaseDate': releaseDate?.toIso8601String(),
      'isWatched': isWatched,
    };
  }
}

class Comment {
  final String text;
  final String user;

  Comment({required this.text, required this.user});

  // Construct Comment from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'] ?? '',
      user: json['user'] ?? '',
    );
  }

  // Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'user': user,
    };
  }
}
