const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    default: "",
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  itemsPerBox: {
    type: Number,
    required: true,
    min: 1,
  },
  company: {  // Ссылка на компанию-владельца
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Company',  // Связь с моделью Company
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Product', ProductSchema);