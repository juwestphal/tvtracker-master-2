const mongoose = require('mongoose');

// Weather schema e model
const WeatherSchema = new mongoose.Schema({
 temperature: { type: Number, required: true, min: -20, max: 40, default:25 },
  humidity: { type: Number, default: 60 },
  createdAt: { type: Date, default: Date.now },
});


const Weather = mongoose.model('Weather', WeatherSchema);

module.exports = Weather;