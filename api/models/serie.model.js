const mongoose = require('mongoose');

// Serie schema e model
const serieSchema = new mongoose.Schema({
  title: { type: String, required: true },
  synopsis: { type: String, required: true },
  posterPath: { type: String, required: true },
  genres: [String],
  streamingPlatforms: [String],
  cast: [String],
  releaseDate: { type: Date, default: Date.now },
  isWatched: { type: Boolean },
   imdbRating: { type: Number, min: 0, max: 10 },
  reviews: [{
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    comment: { type: String, required: true },
    userRating: { type: Number, required: true, min: 1, max: 5 },
    createdAt: { type: Date, default: Date.now }
  }],
  seasons: [{
    seasonNumber: { type: Number, required: true },
    episodes: [{
      title: { type: String, required: true },
      duration: { type: Number }, // duração em minutos
      synopsis: { type: String },
      releaseDate: { type: Date }
    }]
  }],
});

const Serie = mongoose.model('Serie', serieSchema);

module.exports = Serie;