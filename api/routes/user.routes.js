const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../lib/auth');


const {
  getAllUsers,
  getUser,
  addFavoriteMovie,
  registerUser,
  loginUser,
  getUserReviews,
  deleteUser
} = require('../controllers/userController');

// Rotas publicas
router.get('/', getAllUsers);
router.post('/', registerUser);
router.post('/login', loginUser);
router.delete('/:id', deleteUser);

// Rotas privadas que necessitam user login
router.get('/:id', authenticateToken, getUser);
router.put('/:id/favorites', authenticateToken, addFavoriteMovie);
router.get('/:id/reviews', authenticateToken, getUserReviews);

module.exports = router;
