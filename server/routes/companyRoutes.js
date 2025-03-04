const express = require('express');
const companyController = require('../controllers/companyController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/', authMiddleware, companyController.createCompany);
router.get('/', authMiddleware, companyController.getCompanies);
router.put('/:id', authMiddleware, companyController.updateCompany);
router.delete('/:id', authMiddleware, companyController.deleteCompany);

module.exports = router;