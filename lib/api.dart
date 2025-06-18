part of 'demo.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      throw Exception('Failed to load user info: $e');
    }
  }

  Future<List<Companies>> getCompanies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/companies'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status: ${response.statusCode}'); // Логируем статус ответа

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      // Преобразуем List<dynamic> в List<Companies>
      final List<Companies> companies = jsonList
          .map((json) => Companies.fromJson(json))
          .toList();

      return companies; // Возвращаем List<Companies>
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<Products>> getProducts(String token, String companyId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/company/$companyId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        // Проверка на null и преобразование в List<Products>
        final List<Products> products = jsonList
            .where((json) => json != null) // Фильтрация null (если есть)
            .map((json) => Products.fromJson(json))
            .toList();

        return products;
      } else if (response.statusCode == 404) {
        throw Exception('Company not found or has no products');
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> createOrder(
      String token,
      List<Map<String, dynamic>> items,
      double total, {
        required String shippingAddress,
        required String paymentMethod,
      }) async {
    try {
     /* print('Creating order with data:');
      print('Items: $items');
      print('Total: $total');
      print('Shipping: $shippingAddress');
      print('Payment: $paymentMethod');*/

      final orderData = {
        'items': items,
        'total': total,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(orderData),
      );

      print('Order creation response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ??
                'Failed to create order. Status: ${response.statusCode}'
        );
      }
    } catch (e) {
      print('Order creation error: $e');
      rethrow;
    }
  }

  Future<List<Order>> fetchOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Проверяем успешность запроса и наличие данных
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> ordersData = responseData['data'];
          return ordersData.map((json) => Order.fromJson(json)).toList();
        } else {
          throw Exception('No orders data received');
        }
      } else {
        throw Exception('Failed to load orders. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to load orders: $e');
    }
  }
}

