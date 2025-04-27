part of 'demo.dart';

class OrdersPage extends StatefulWidget {
  final String token;

  const OrdersPage({Key? key, required this.token}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> futureOrders;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureOrders = apiService.fetchOrders(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('У вас пока нет заказов'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return OrderCard(order: order);
              },
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Основная информация о заказе
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Заказ №${widget.order.id.length > 8 ? widget.order.id.substring(0, 8) : widget.order.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      _getStatusText(widget.order.status),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(widget.order.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Продуктов: ${widget.order.items.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Сумма: ${widget.order.total.toStringAsFixed(2)} ₽',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Детали заказа (раскрываются по нажатию)
              if (_expanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Состав заказа:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.product.name} (x${item.quantity})',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${(item.product.price * item.quantity).toStringAsFixed(2)} ₽',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Итого:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.total.toStringAsFixed(2)} ₽',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.green;
      case 'delivered':
        return Colors.deepPurple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'В обработке';
      case 'processing':
        return 'Готовится';
      case 'shipped':
        return 'В пути';
      case 'delivered':
        return 'Доставлен';
      case 'cancelled':
        return 'Отменен';
      default:
        return status;
    }
  }
}

// Модель заказа
class Order {
  final String id;
  final String userId; // Добавляем поле user
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
      userId: json['user']?.toString() ?? '', // Преобразуем ObjectId в строку
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
      productId: json['product']?.toString() ?? '', // ObjectId как строка
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      product: Product.fromJson(json['productDetails'] ?? {}), // Дополнительные данные о продукте
    );
  }
}

// Модель продукта
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