const Weather = require('../models/weather.model');
const Movie = require('../models/movie.model');

// Fetch weather data and movie recommendations
const getWeather = async (req, res) => {
  try {
    // Get the most recent weather data
    const currentWeather = await Weather.findOne().sort({ createdAt: -1 }).exec();

    if (!currentWeather) {
      return res.status(404).json({ message: 'No weather data found in the database.' });
    }

    const { temperature } = currentWeather;

    if (temperature == null) {
      return res.status(400).json({ message: 'Temperature data is not available.' });
    }

    // Find movies based on temperature range
    const recommendedMovies = await Movie.find({
      minTemp: { $lte: temperature },
      maxTemp: { $gte: temperature },
    });

    res.status(200).json({
      weather: currentWeather,
      recommendations: recommendedMovies,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching weather and movies', error });
  }
};


// Add new weather data to the database
const addWeather = async (req, res) => {
  try {
    const { temperature, humidity } = req.body;
    if (typeof temperature !== 'number') {
      return res.status(400).json({ message: 'Temperature must be a number' });
    }
    const weatherData = new Weather({ temperature, humidity });
    const savedData = await weatherData.save();
    res.status(201).json(savedData);
  } catch (error) {
    res.status(500).json({ message: 'Error saving weather data', error });
  }
};

// Fetch movies by temperature range
const getMoviesByTemperature = async (req, res) => {
  try {
    const { temperature } = req.query;

    if (!temperature) {
      return res.status(400).json({ message: 'Temperature is required' });
    }

    const temp = parseFloat(temperature);

    // Find movies where temperature falls within the range
    const movies = await Movie.find({
      minTemp: { $lte: temp },
      maxTemp: { $gte: temp },
    });

    res.status(200).json(movies);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching movies', error });
  }
};

module.exports = {
  getWeather,
  addWeather,
  getMoviesByTemperature,
};
