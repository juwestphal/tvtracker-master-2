const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

// User schema and model
const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  profile: { type: String, enum: ['admin', 'user'], default: 'user' },
  myWatchlist: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Movie' }],
  mySeriesWatchlist: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Serie' }],
});

// Hash password before saving
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// Compare passwords
userSchema.methods.comparePassword = function (password) {
  return bcrypt.compare(password, this.password);
};

const User = mongoose.model('User', userSchema);

module.exports = User;