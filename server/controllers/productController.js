const Product = require('../models/Product');
const Company = require('../models/Company');

// Создать товар
exports.createProduct = async (req, res) => {
  try {
    const { name, description, price, itemsPerBox, companyId } = req.body;

    // Проверяем, существует ли компания
    const company = await Company.findById(companyId);
    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }

    const product = new Product({
      name,
      description,
      price,
      itemsPerBox,
      company: companyId,
    });

    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Получить все товары компании
exports.getProductsByCompany = async (req, res) => {
  try {
    const { companyId } = req.params;
    const products = await Product.find({ company: companyId });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Обновить товар
exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndUpdate(id, req.body, { new: true });
    res.json(product);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Удалить товар
exports.deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    await Product.findByIdAndDelete(id);
    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};