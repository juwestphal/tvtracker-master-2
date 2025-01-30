const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const Movie = require('../models/movie.model');
const User = require('../models/user.model');
const Review = require('../models/review.model');
const { authenticateToken } = require('../lib/auth');

/*
  *POST endpoint para criar reviews referenciando Movie e User
  *Um usuário pode ter review de varios filmes
  *Um filme pode ter review de varios usuários

  - movieId precisa ser um id de um filme adicionado no banco
  - userId precisa ser um id de um utilizador adicionado no banco


  Exemplo Body:
    {
      "movieId": "1231232131",
      "userId": "1231232131",
      "comment": "Filme sensacional! Recomendo!",
      "rating": 4
    }
*/
router.post('/', async (req, res) => {
  try {
    const { movieId, userId, comment, rating } = req.body;

    const movie = await Movie.findById(movieId);
    if (!movie) return res.status(404).json({ message: 'Movie not found' });

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Create the review
    const review = new Review({ movie: movieId, user: userId, comment, rating });
    const savedReview = await review.save();

    res.status(201).json({ message: 'Review added successfully', review: savedReview });
  } catch (error) {
    res.status(400).json({ message: 'Error creating review', error });
  }
});

router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const deletedReview = await Review.findByIdAndDelete(req.params.id);
    if (!deletedReview) {
      return res.status(404).json({ message: 'Review not found' });
    }
    res.status(200).json({ message: 'Review deleted successfully', deletedReview });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting Review', error });
  }
});

module.exports = router;