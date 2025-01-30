const mongoose = require('mongoose');

// Movie schema and model
const movieSchema = new mongoose.Schema({
  title: { type: String, required: true },
  synopsis: { type: String, required: true },
  posterPath: { type: String, required: true },
  genres: [String],
  duration: { type: String },
  cast: [String],
  releaseDate: { type: Date, default: Date.now },
  streamingPlatforms: [String],
  isWatched: { type: Boolean },
  weatherCategory: { type: Number, required: true }, // Weather category (e.g., "Ensolarado", "Nublado")
});

const Movie = mongoose.model('Movie', movieSchema);

module.exports = Movie;
