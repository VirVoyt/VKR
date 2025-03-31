const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const authMiddleware = require('../middleware/authMiddleware'); // Добавлено

// Все маршруты требуют аутентификации
router.post('/', authMiddleware, productController.createProduct);
router.get('/company/:companyId', authMiddleware, productController.getProductsByCompany);
router.put('/:id', authMiddleware, productController.updateProduct);
router.delete('/:id', authMiddleware, productController.deleteProduct);

module.exports = router;