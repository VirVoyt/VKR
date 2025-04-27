const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

// Хеширование пароля перед сохранением
userSchema.pre('save', async function (next) {
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 10);
  }
  next();
});

// Добавляем виртуальную связь с заказами
userSchema.virtual('orders', {
  ref: 'Order',  // Модель Order
  localField: '_id',  // Поле в User
  foreignField: 'user',  // Поле в Order
  justOne: false,  // Получить массив заказов
});

// Чтобы виртуальные поля включались в JSON
userSchema.set('toJSON', { virtuals: true });

module.exports = mongoose.model('User', userSchema);