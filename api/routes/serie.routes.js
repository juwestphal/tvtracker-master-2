const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const Serie = require('../models/serie.model');

// GET all series
router.get('/', async (req, res) => {
  try {
    const { genres, streamingPlatforms } = req.query;
    const filter = {};
    if (genres) filter.genres = genres;
    if (streamingPlatforms) filter.streamingPlatforms = streamingPlatforms;

    const series = await Serie.find(filter);
    res.status(200).json(series);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching series', error });
  }
});

// GET a single series by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid Serie ID' });
    }

    const serie = await Serie.findById(id);
    if (!serie) {
      return res.status(404).json({ message: 'Serie not found' });
    }

    res.status(200).json(serie);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching serie', error });
  }
});

// POST a new series
router.post('/', async (req, res) => {
  try {
    const newSerie = new Serie(req.body);
    const savedSerie = await newSerie.save();
    res.status(201).json(savedSerie);
  } catch (error) {
    res.status(400).json({ message: 'Error creating serie', error });
  }
});

// PUT to update a series by ID
router.put('/:id', async (req, res) => {
  try {
    const updatedSerie = await Serie.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!updatedSerie) {
      return res.status(404).json({ message: 'Serie not found' });
    }
    res.status(200).json(updatedSerie);
  } catch (error) {
    res.status(400).json({ message: 'Error updating serie', error });
  }
});

// DELETE a series by ID
router.delete('/:id', async (req, res) => {
  try {
    const deletedSerie = await Serie.findByIdAndDelete(req.params.id);
    if (!deletedSerie) {
      return res.status(404).json({ message: 'Serie not found' });
    }
    res.status(200).json({ message: 'Serie deleted successfully', deletedSerie });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting serie', error });
  }
});

// POST a review to a series
router.post('/:id/reviews', async (req, res) => {
  try {
    const { userId, comment, userRating } = req.body;
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid Serie ID' });
    }

    const serie = await Serie.findById(id);
    if (!serie) {
      return res.status(404).json({ message: 'Serie not found' });
    }

    const review = { user: userId, comment, userRating };
    serie.reviews.push(review);
    await serie.save();

    res.status(201).json({ message: 'Review added successfully', review });
  } catch (error) {
    res.status(400).json({ message: 'Error adding review', error });
  }
});

module.exports = router;
