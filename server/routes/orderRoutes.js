const express = require('express');
const orderController = require('../controllers/orderController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// Создание заказа
router.post(
  '/',
  authMiddleware,
  orderController.validateOrder,
  orderController.createOrder
);

// Получение списка заказов
router.get(
  '/',
  authMiddleware,
  orderController.getOrders
);

// Получение конкретного заказа
router.get(
  '/:id',
  authMiddleware,
  orderController.getOrderById
);

module.exports = router;