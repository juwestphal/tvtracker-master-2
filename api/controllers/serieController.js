const mongoose = require('mongoose');
const Serie = require('../models/serie.model');
const Review = require('../models/review.model');

// GET endpoint to fetch all series with optional filtering
const getAllSeries = async (req, res) => {
  try {
    const { title, genres, streamingPlatforms } = req.query;

    const filter = {};
    if (title) filter.title = new RegExp(title, 'i'); // case-insensitive search
    if (genres) filter.genres = { $in: genres.split(',') };
    if (streamingPlatforms) filter.streamingPlatforms = { $in: streamingPlatforms.split(',') };

    const series = await Serie.find(filter);
    res.status(200).json(series);
  } catch (error) {
    console.error('Error fetching series:', error.message);
    res.status(500).json({ message: 'Error fetching series', error: error.message });
  }
};

// GET endpoint to fetch a series by ID
const getSerieById = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid series ID' });
    }

    const serie = await Serie.findById(id);
    if (!serie) {
      return res.status(404).json({ message: 'Series not found' });
    }
    res.status(200).json(serie);
  } catch (error) {
    console.error('Error fetching series:', error.message);
    res.status(500).json({ message: 'Error fetching series', error: error.message });
  }
};

// POST endpoint to create a new series
const createSerie = async (req, res) => {
  try {
    const { title, synopsis, posterPath, genres, cast, streamingPlatforms, isWatched, imdbRating, seasons } = req.body;

    if (!title || !genres || !posterPath) {
      return res.status(400).json({ message: 'Required fields: title, genres, posterPath' });
    }

    const newSerie = new Serie({
      title,
      synopsis,
      posterPath,
      genres,
      cast,
      streamingPlatforms,
      isWatched: isWatched || false,
      imdbRating,
      seasons
    });

    const savedSerie = await newSerie.save();
    res.status(201).json(savedSerie);
  } catch (error) {
    console.error('Error creating series:', error.message);
    res.status(400).json({ message: 'Error creating series', error: error.message });
  }
};

// PUT endpoint to update a series by ID
const updateSerie = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid series ID' });
    }

    const allowedUpdates = ['title', 'synopsis', 'posterPath', 'genres', 'cast', 'streamingPlatforms', 'isWatched', 'imdbRating', 'seasons'];
    const updates = {};
    for (const key of allowedUpdates) {
      if (req.body[key] !== undefined) {
        updates[key] = req.body[key];
      }
    }

    const updatedSerie = await Serie.findByIdAndUpdate(id, updates, {
      new: true,
      runValidators: true,
    });

    if (!updatedSerie) {
      return res.status(404).json({ message: 'Series not found' });
    }

    res.status(200).json(updatedSerie);
  } catch (error) {
    console.error('Error updating series:', error.message);
    res.status(400).json({ message: 'Error updating series', error: error.message });
  }
};

// DELETE endpoint to delete a series by ID
const deleteSerie = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid series ID' });
    }

    const deletedSerie = await Serie.findByIdAndDelete(id);
    if (!deletedSerie) {
      return res.status(404).json({ message: 'Series not found' });
    }

    res.status(200).json({ message: 'Series deleted successfully', deletedSerie });
  } catch (error) {
    console.error('Error deleting series:', error.message);
    res.status(500).json({ message: 'Error deleting series', error: error.message });
  }
};

// GET endpoint to fetch reviews for a specific series
const getSerieReviews = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid series ID' });
    }

    const serie = await Serie.findById(id);
    if (!serie) {
      return res.status(404).json({ message: 'Series not found' });
    }

    const reviews = await Review.find({ serie: id }).populate('user', 'name email');
    res.status(200).json(reviews);
  } catch (error) {
    console.error('Error fetching reviews:', error.message);
    res.status(500).json({ message: 'Error fetching reviews', error: error.message });
  }
};

module.exports = {
  getAllSeries,
  getSerieById,
  createSerie,
  updateSerie,
  deleteSerie,
  getSerieReviews
};
