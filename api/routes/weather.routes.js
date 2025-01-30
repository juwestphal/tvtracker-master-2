const express = require('express');
const router = express.Router();
const { getWeather, addWeather, getMoviesByTemperature } = require('../controllers/weatherController');

// Routes
router.get('/', getWeather); // Fetch weather + recommendations
router.post('/', addWeather); // Add new weather data
router.get('/movies', getMoviesByTemperature); // Fetch movies by temperature

module.exports = router;
