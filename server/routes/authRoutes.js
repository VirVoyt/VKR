const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const auth = require('../middleware/authMiddleware'); // Импорт middleware аутентификации

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/me', auth, authController.me); // Добавляем auth middleware

module.exports = router;