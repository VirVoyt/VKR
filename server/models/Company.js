const mongoose = require('mongoose');

const CompanySchema = new mongoose.Schema({
  name: String,
  contactEmail: String,
  contactPhone: String,
  address: String,
  website: String,
  description: String,
}, { timestamps: true });

// Добавляем виртуальную связь с товарами
CompanySchema.virtual('products', {
  ref: 'Product',  // Модель Product
  localField: '_id',  // Поле в Company
  foreignField: 'company',  // Поле в Product
  justOne: false,  // Получить массив товаров
});

// Чтобы виртуальные поля включались в JSON
CompanySchema.set('toJSON', { virtuals: true });

module.exports = mongoose.model('Company', CompanySchema);