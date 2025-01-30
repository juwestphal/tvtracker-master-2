const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const app = express();
// Serve static files for images
const path = require('path');


// Middleware
app.use(express.json());

// Use .env variables
dotenv.config();

// Connect MongoDB
connectDB();

// Import routes
const movieRoutes = require('./routes/movie.routes');
const userRoutes = require('./routes/user.routes');
const serieRoutes = require('./routes/serie.routes');
const reviewRoutes = require('./routes/review.routes');
const weatherRoutes = require('./routes/weather.routes');



// Static file paths relative to app.js
app.use('/movies', express.static(path.join(__dirname, '/assets/movies')));
app.use('/series', express.static(path.join(__dirname, '/assets/series')));




// Use routes
app.use('/api/movies', movieRoutes);
app.use('/api/series', serieRoutes);
app.use('/api/users', userRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/weather', weatherRoutes);

module.exports = app;
