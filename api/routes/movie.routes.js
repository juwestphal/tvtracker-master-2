const express = require('express');
const router = express.Router();

const {
  getAllMovies,
  getMovieById,
  createMovie,
  updateMovie,
  deleteMovie,
  getMovieReviews,
} = require('../controllers/movieController');

// Routes
router.get('/', getAllMovies);
router.get('/:id', getMovieById);
router.post('/', createMovie);
router.put('/:id', updateMovie);
router.delete('/:id', deleteMovie);
router.get('/:id/reviews', getMovieReviews);

module.exports = router;
