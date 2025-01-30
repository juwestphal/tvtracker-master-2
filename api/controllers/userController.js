const User = require('../models/user.model');
const Review = require('../models/review.model');
const jwt = require('jsonwebtoken');

// GET all users
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching users', error });
  }
};

// GET usuario by id
const getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching user', error });
  }
};

// PUT endpoint to add a movie to a user's watchlist
// Id param is the User Id
/*
  Exemplo Body
  {
    "movieId": "3434234234234213",
  }
*/
const addFavoriteMovie = async (req, res) => {
  try {
    const userId = req.params.id;
    const { movieId } = req.body;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Add the movie to the myWatchlist list if not already added
    if (!user.myWatchlist.includes(movieId)) {
      user.myWatchlist.push(movieId);
      await user.save();
    }

    res.status(200).json({ message: 'Movie added to favorites', user });
  } catch (error) {
    res.status(400).json({ message: 'Error adding movie to favorites', error });
  }
};

// Create a user
/*
  Exemplo Body
  {
    "name": "John Doe",
    "email": "johndoe@email.com",
    "password": "jai7asMha21",
    "profile": "admin"
  }
*/
const registerUser = async (req, res) => {
  const { name, email, password } = req.body;

  // Validação de dados obrigatórios
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Preencha todos os campos!' });
  }

  try {
    // Verifica se o usuário já existe
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Usuário já existe!' });
    }

    // Cria um novo usuário
    const newUser = new User(req.body);

    // Salva o novo usuário no banco de dados
    await newUser.save();

    res.status(201).json({ message: 'Usuário registrado com sucesso!' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro ao registrar o usuário.' });
  }
};

/**
 * Rota para logar o usuario
 * Exemplo Body:
 {
    "email": "maria@email.com",
    "password": "123456"
  }
*/
const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Compare password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Generate JWT
    const token = jwt.sign(
      { userId: user._id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '1h' } // Token expiration
    );

    res.status(200).json({ message: 'Login successful', token });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error });
  }
};

// Rota para peagr reviews feitas por um usuario especifico
const getUserReviews = async (req, res) => {
  try {
    const userId = req.params.id;

    // Validate User existence
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Fetch reviews by the user
    const reviews = await Review.find({ user: userId }).populate('movie', 'title director');

    res.status(200).json(reviews);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching reviews', error });
  }
};

// DELETE endpoint to delete a user
const deleteUser = async (req, res) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json({ message: 'User deleted successfully', deletedUser });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting User', error });
  }
};

// DELETE review de usuario
// const deleteUser = async (req, res) => {
//   try {
//     const deletedUser = await User.findByIdAndDelete(req.params.id);
//     if (!deletedUser) {
//       return res.status(404).json({ message: 'User not found' });
//     }
//     res.status(200).json({ message: 'User deleted successfully', deletedUser });
//   } catch (error) {
//     res.status(500).json({ message: 'Error deleting User', error });
//   }
// };

module.exports = {
  getAllUsers,
  getUser,
  addFavoriteMovie,
  registerUser,
  loginUser,
  getUserReviews,
  deleteUser
};