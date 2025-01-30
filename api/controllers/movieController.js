const mongoose = require('mongoose');
const Movie = require('../models/movie.model');
const Review = require('../models/review.model');

// GET endpoint to fetch all movies with optional filtering
const getAllMovies = async (req, res) => {
  try {
    const { title, genres, streamingPlatforms } = req.query;

    const filter = {};
    if (title) filter.title = new RegExp(title, 'i'); // case-insensitive search
    if (genres) filter.genres = { $in: genres.split(',') };
    if (streamingPlatforms) filter.streamingPlatforms = { $in: streamingPlatforms.split(',') };

    const movies = await Movie.find(filter);
    res.status(200).json(movies);
  } catch (error) {
    console.error('Error fetching movies:', error.message);
    res.status(500).json({ message: 'Error fetching movies', error: error.message });
  }
};

// GET endpoint to fetch a movie by ID
const getMovieById = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid movie ID' });
    }

    const movie = await Movie.findById(id);
    if (!movie) {
      return res.status(404).json({ message: 'Movie not found' });
    }
    res.status(200).json(movie);
  } catch (error) {
    console.error('Error fetching movie:', error.message);
    res.status(500).json({ message: 'Error fetching movie', error: error.message });
  }
};

// POST endpoint to create a new movie
const createMovie = async (req, res) => {
  try {
    const { title, synopsis, posterPath, genres, duration, cast, streamingPlatforms, isWatched, weatherCategory } = req.body;

    if (!title || !genres || !posterPath) {
      return res.status(400).json({ message: 'Required fields: title, genres, posterPath' });
    }

    const newMovie = new Movie({
      title,
      synopsis,
      posterPath,
      genres,
      duration,
      cast,
      streamingPlatforms,
      isWatched: isWatched || false,
      weatherCategory
    });

    const savedMovie = await newMovie.save();
    res.status(201).json(savedMovie);
  } catch (error) {
    console.error('Error creating movie:', error.message);
    res.status(400).json({ message: 'Error creating movie', error: error.message });
  }
};

// PUT endpoint to update a movie by ID
const updateMovie = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid movie ID' });
    }

    // Log the request body for debugging
    console.log("Updating movie with ID:", id);
    console.log("Request body:", req.body);

    // Extract only the fields you want to allow updates for
    const allowedUpdates = ['title', 'synopsis', 'posterPath', 'genres', 'duration', 'cast', 'streamingPlatforms', 'isWatched', 'releaseDate', 'weatherCategory'];
    const updates = {};
    for (const key of allowedUpdates) {
      if (req.body[key] !== undefined) {
        updates[key] = req.body[key];
      }
    }

    // Log the filtered updates
    console.log("Filtered updates:", updates);

    const updatedMovie = await Movie.findByIdAndUpdate(id, updates, {
      new: true,
      runValidators: true,
    });

    if (!updatedMovie) {
      return res.status(404).json({ message: 'Movie not found' });
    }

    res.status(200).json(updatedMovie);
  } catch (error) {
    console.error('Error updating movie:', error.message);
    res.status(400).json({ message: 'Error updating movie', error: error.message });
  }
};


// DELETE endpoint to delete a movie by ID
const deleteMovie = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid movie ID' });
    }

    const deletedMovie = await Movie.findByIdAndDelete(id);
    if (!deletedMovie) {
      return res.status(404).json({ message: 'Movie not found' });
    }

    res.status(200).json({ message: 'Movie deleted successfully', deletedMovie });
  } catch (error) {
    console.error('Error deleting movie:', error.message);
    res.status(500).json({ message: 'Error deleting movie', error: error.message });
  }
};

// GET endpoint to fetch reviews for a specific movie
const getMovieReviews = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid movie ID' });
    }

    const movie = await Movie.findById(id);
    if (!movie) {
      return res.status(404).json({ message: 'Movie not found' });
    }

    const reviews = await Review.find({ movie: id }).populate('user', 'name email');
    res.status(200).json(reviews);
  } catch (error) {
    console.error('Error fetching reviews:', error.message);
    res.status(500).json({ message: 'Error fetching reviews', error: error.message });
  }
};

module.exports = {
  getAllMovies,
  getMovieById,
  createMovie,
  updateMovie,
  deleteMovie,
  getMovieReviews
};
