const mongoose = require('mongoose');

const companySchema = new mongoose.Schema({
  name: { type: String, required: true },
  contactEmail: { type: String, required: true },
  contactPhone: { type: String },
  address: { type: String },
  website: { type: String },
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
});

module.exports = mongoose.model('Company', companySchema);