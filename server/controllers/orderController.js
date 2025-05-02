const mongoose = require('mongoose');
const { body, validationResult } = require('express-validator');
const Order = require('../models/Order');
const Product = require('../models/Product');
const User = require('../models/User');
/**
 * Создание нового заказа
 */
exports.createOrder = async (req, res) => {
  // Валидация входных данных
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ 
      success: false,
      errors: errors.array() 
    });
  }

  const { items, total, shippingAddress, paymentMethod} = req.body;

  try {
    // Проверка существования продуктов
    const productCheckPromises = items.map(async item => {
      if (!mongoose.Types.ObjectId.isValid(item.product)) {
        throw new Error(`Invalid product ID: ${item.product}`);
      }
      
      const product = await Product.findById(item.product);
      if (!product) {
        throw new Error(`Product not found: ${item.product}`);
      }
      
      return {
        product: product._id,
        quantity: item.quantity,
        price: product.price // Используем цену из базы для безопасности
      };
    });

    const orderItems = await Promise.all(productCheckPromises);

    // Пересчет общей суммы на сервере
    const calculatedTotal = orderItems.reduce(
      (sum, item) => sum + (item.price * item.quantity), 
      0
    );

    // Проверка соответствия суммы
    if (Math.abs(calculatedTotal - total) > 0.01) {
      return res.status(400).json({
        success: false,
        error: 'Total amount mismatch',
        details: `Calculated total (${calculatedTotal}) doesn't match provided total (${total})`
      });
    }

    // Создание заказа
    const order = new Order({
      user: req.user._id,
      items: orderItems,
      total: calculatedTotal,
      shippingAddress,
      paymentMethod,
      status: 'pending'
    });

    const savedOrder = await order.save();
    
    // Популяция данных для ответа
    const populatedOrder = await Order.populate(savedOrder, [
      { path: 'user', select: 'username email' },
      { path: 'items.product', select: 'name price' }
    ]);

    res.status(201).json({
      success: true,
      order: populatedOrder
    });

  } catch (err) {
    console.error('Order creation error:', err);
    res.status(400).json({
      success: false,
      error: 'Order creation failed',
      details: err.message
    });
  }
};

/**
 * Получение заказов пользователя
 */
exports.getOrders = async (req, res) => {
  try {
    // Параметры пагинации
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Получение заказов с популяцией данных
    const orders = await Order.find({ user: req.user._id })
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate('user', 'username email')
      .populate('items.product', 'name price image');

    // Общее количество заказов для пагинации
    const totalOrders = await Order.countDocuments({ user: req.user._id });

    res.json({
      success: true,
      data: orders,
      pagination: {
        page,
        limit,
        total: totalOrders,
        pages: Math.ceil(totalOrders / limit)
      }
    });

  } catch (err) {
    console.error('Get orders error:', err);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch orders',
      details: err.message
    });
  }
};

/**
 * Получение конкретного заказа
 */
exports.getOrderById = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid order ID format'
      });
    }

    const order = await Order.findById(req.params.id)
      .populate('user', 'username email')
      .populate('items.product', 'name price image');

    if (!order) {
      return res.status(404).json({
        success: false,
        error: 'Order not found'
      });
    }

    // Проверка прав доступа
    if (order.user._id.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        error: 'Access denied'
      });
    }

    res.json({
      success: true,
      data: order
    });

  } catch (err) {
    console.error('Get order by ID error:', err);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch order',
      details: err.message
    });
  }
};

/**
 * Валидация заказа
 */
exports.validateOrder = [
  body('items').isArray({ min: 1 }).withMessage('At least one item required'),
  body('items.*.product')
    .notEmpty().withMessage('Product ID is required')
    .custom(value => mongoose.Types.ObjectId.isValid(value)).withMessage('Invalid product ID format'),
  body('items.*.quantity')
    .isInt({ min: 1 }).withMessage('Quantity must be at least 1'),
  body('total')
    .isFloat({ min: 0 }).withMessage('Total must be a positive number'),
  body('shippingAddress')
    .notEmpty().withMessage('Shipping address is required')
    .isLength({ max: 500 }).withMessage('Address too long'),
  body('paymentMethod')
    .isIn(['card', 'cash', 'paypal']).withMessage('Invalid payment method'),
];