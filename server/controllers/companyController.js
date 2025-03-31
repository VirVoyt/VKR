const Company = require('../models/Company');

// Создание компании
exports.createCompany = async (req, res) => {
  const { name, contactEmail, contactPhone, address, website , description } = req.body;
  try {
    const company = new Company({ name, contactEmail, contactPhone, address, website, description });
    await company.save();
    res.status(201).json(company);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Получение всех компаний
exports.getCompanies = async (req, res) => {
  try {
    const companies = await Company.find({});
    res.json(companies);
  } catch (err) {
    console.error('Error fetching companies:', err);
    res.status(400).json({ error: err.message });
  }
};

// Обновление компании
exports.updateCompany = async (req, res) => {
  const { id } = req.params;
  try {
    const company = await Company.findOneAndUpdate(
      { _id: id, createdBy: req.userId },
      req.body,
      { new: true }
    );
    if (!company) throw new Error('Company not found');
    res.json(company);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Удаление компании
exports.deleteCompany = async (req, res) => {
  const { id } = req.params;
  try {
    const company = await Company.findOneAndDelete({ _id: id, createdBy: req.userId });
    if (!company) throw new Error('Company not found');
    res.json({ message: 'Company deleted successfully' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};