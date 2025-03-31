part of 'demo.dart';

class ApiService {
  final String baseUrl = 'http://localhost:5000/api';

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

  Future<List<Companies>> getCompanies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/companies'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status: ${response.statusCode}'); // Логируем статус ответа
 // print('Response body: ${response.body}'); // Логируем тело ответа

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
      double total,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'items': items,
        'total': total,
        'date': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.statusCode}');
    }
  }
}

