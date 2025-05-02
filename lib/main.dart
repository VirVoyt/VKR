import 'package:flutter/material.dart';
import 'demo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

late Future<List<Companies>> futureCompanies;


final ApiService apiService = ApiService();

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Product List',
      theme: themeNotifier.currentTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => RegisterScreen());
          case '/app':
            final token = settings.arguments as String; // Получаем токен
            return MaterialPageRoute(
              builder: (context) => ShopPage(token: token), // Передаем токен
            );
          default:
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  }
}



class ShopPage extends StatefulWidget {
  final String token;//принимаем токен
  const ShopPage({super.key, required this.token});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late List<CartItem> cartItems = [];
  late Future<List<Companies>> futureCompanies;// Добавляем Future для компаний

  int currentPageIndex = 0;

  late GoogleMapController mapController;

  TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'card';

  // Добавление товара в корзину
  void _addToCart(String id, double price, String name) {
    setState(() {
      final existingItemIndex = cartItems.indexWhere((item) => item.id == id);
      if (existingItemIndex >= 0) {
        cartItems[existingItemIndex].quantity++;
      } else {
        cartItems.add(CartItem(
          id: id,
          name: name,
          price: price,
        ));
      }
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        cartItems[index].quantity = newQuantity;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void _placeOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пожалуйста, введите адрес доставки',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
          backgroundColor: Theme.of(context).colorScheme.primary,),
      );
      return;
    }

    try {
      final orderItems = cartItems.map((item) => {
        'product': item.id,
        'quantity': item.quantity,
      }).toList();

      await apiService.createOrder(
        widget.token,
        orderItems,
        totalPrice,
        shippingAddress: _addressController.text,
        paymentMethod: _selectedPaymentMethod,
      );

      setState(() {
        cartItems.clear();
        _addressController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Заказ успешно оформлен!', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка оформления заказа: ${e.toString()}', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                    (route) => false,
              );
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    // Загружаем данные с использованием токена
    futureCompanies = apiService.getCompanies(widget.token);
  }
  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: NavigationBar(

        backgroundColor: Theme.of(context).colorScheme.surface, // цвет навигатора
        indicatorColor: Theme.of(context).colorScheme.tertiary, // цвет выбранного элемента
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.secondary),
            icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.secondary),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.delivery_dining_rounded, color: Theme.of(context).colorScheme.secondary),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary),
            label: '',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(cartItems.length.toString()),
              child: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.secondary),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.secondary),
            label: '',
          ),
        ],
      ),
      body: <Widget>[

        ///home page
        FutureBuilder<List<Companies>>(
          future: futureCompanies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Нет данных о компаниях'));
            } else {
              final companies = snapshot.data!;
              return ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    margin: EdgeInsets.all(4),
                    child: ListTile(
                      title: Text(company.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary
                        ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(company.description,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary
                              )),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.secondary,),
                      onTap: () {
                        // Действие при нажатии на компанию
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompaniesCart(
                                token: widget.token,
                                id: company.id,
                              name: company.name,
                              description: company.description,
                              address: company.address,
                              contactPhone: company.contactPhone,
                              contactEmail: company.contactEmail,
                              website: company.website,
                              onAddToCart: _addToCart,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
        /// Orders page
        OrdersPage(token: widget.token),

        /// map page
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.7749, -122.4194), // Координаты (замените на нужные)
            zoom: 10,
          ),
        ),

        ///shopping cart page
        cartItems.isEmpty
            ? const Center(child: Text('Корзина пуста'))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Название и цена
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.price.toStringAsFixed(2)} ₽',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Кнопки количества
                          Row(
                            children: [
                              IconButton(
                                icon: item.quantity > 1
                                    ? Icon(Icons.remove, color: Theme.of(context).colorScheme.secondary)
                                    : Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary,),
                                onPressed: () => _updateQuantity(index, item.quantity - 1),
                                style: IconButton.styleFrom(

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                              IconButton(
                                icon:  Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
                                onPressed: () => _updateQuantity(index, item.quantity + 1),
                                style: IconButton.styleFrom(
                                ),
                              ),
                            ],
                          ),
                          // Сумма по позиции
                          Text(
                            '${(item.price * item.quantity).toStringAsFixed(2)} ₽',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Блок с итогами и кнопкой оформления
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Поле для ввода адреса
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Адрес доставки',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Выбор способа оплаты
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Способ оплаты',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'card',
                        child: Text('Карта'),
                      ),
                      DropdownMenuItem(
                        value: 'cash',
                        child: Text('Наличные'),
                      ),
                      DropdownMenuItem(
                        value: 'SberPay',
                        child: Text('SberPay'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Итоговая строка
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ₽',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Кнопка оформления
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cartItems.isEmpty
                          ? null
                          : () {
                        _placeOrder();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Оформить заказ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        /// account page
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Профиль', style: TextStyle(fontSize: 24)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.brightness_6),
                        onPressed: () {
                          final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                          themeNotifier.toggleTheme();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: apiService.getUserInfo(widget.token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Нет данных о пользователе'));
                  } else {
                    final userData = snapshot.data!;
                    return Column(
                      children: [
                        CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                          child: Text(
                            userData['username']?.toString().isNotEmpty == true
                                ? userData['username'][0].toUpperCase()
                                : 'U',
                            style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary),
                          ),
                          radius: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Имя: ${userData['username'] ?? 'Не указано'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${userData['email'] ?? 'Не указан'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}

