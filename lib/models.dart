part of 'demo.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Неизвестный продукт',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String image;

  UserProfile({required this.name, required this.email, required this.image});
}

class Companies {
  final String id;
  final String name;
  final String contactEmail;
  final String contactPhone;
  final String address;
  final String website;
  final String description;

  Companies({
    required this.id,
    required this.name,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.website,
    required this.description,

  });

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      id: json['_id'],
      name: json['name'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      address: json['address'],
      website: json['website'],
      description: json['description'],
    );
  }
}

class Products {
  final String id;
  final String name;
  final double price;
  final double itemsPerBox;
  final String company;
  final String description;

  Products({
    required this.id,
    required this.name,
    required this.price,
    required this.itemsPerBox,
    required this.company,
    required this.description,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['_id'].toString(), // Явное преобразование в строку
      name: json['name'],
      price: json['price'].toDouble(),
      itemsPerBox: json['itemsPerBox'].toDouble(),
      company: json['company'].toString(),
      description: json['description'],
    );
  }
}

// Модель заказа
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      userId: json['user'] is String
          ? json['user']
          : (json['user']?['_id']?.toString() ?? ''), // Обрабатываем как строку или объект
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      shippingAddress: json['shippingAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

// Модель товара в заказе
class OrderItem {
  final String productId; // Изменяем с Product на productId
  final int quantity;
  final double price;
  final Product product; // Добавляем поле для полной информации о продукте

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.product, // Инициализируем в fromJson
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product'] is String
          ? json['product']
          : (json['product']?['_id']?.toString() ?? ''),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      product: Product.fromJson(json['product'] is Map ? json['product'] : {}),
    );
  }
}

