const mongoose = require('mongoose');

const companySchema = new mongoose.Schema({
  name: { type: String, required: true },
  contactEmail: { type: String, required: true },
  contactPhone: { type: String },
  address: { type: String },
  website: { type: String },
  });

module.exports = mongoose.model('Company', companySchema);