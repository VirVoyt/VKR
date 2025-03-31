import 'package:flutter/material.dart';
import 'demo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late Future<List<Companies>> futureCompanies;


final ApiService apiService = ApiService();

String description = "";
int? price = 0;
int? percent = 0;
const color = Colors.deepPurple;
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        useMaterial3: true,
      ),
    );
  }
}

//страница с входа
class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   final FocusNode _emailFocusNode = FocusNode();
   final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child:
            Stack( children: [
              Align(alignment: const Alignment(0, 0),
                child:
        Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //текст вход
            const Text("Вход",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 40,
                    decorationStyle: TextDecorationStyle.double,
                  color: color
                )
            ),
            //первое поле ввода
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical:25),
              width: MediaQuery
                  .sizeOf(context)
                  .width / 2,
              child: TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  hintText: "Введите email",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            //второе поле ввода
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 45),
                width: MediaQuery.sizeOf(context).width / 2,
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode, // Привязываем FocusNode
                  decoration: const InputDecoration(
                    hintText: "Введите пароль",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width / 2,
              //действия кнопки авторизации
              child: ElevatedButton(onPressed:  ()

              async {
                String email = _emailController.text;
                String password = _passwordController.text;

                _emailFocusNode.unfocus();
                _passwordFocusNode.unfocus();

                // Проверка данных
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пожалуйста, заполните все поля')),
                  );
                  return;
                }

                try {
                  // Авторизация пользователя
                  final token = await apiService.login(email, password);
                  print('User logged in');
                  final token1 = token['token'];
                  // Получение списка компаний
                //  final futureCompanies = await apiService.getCompanies(token1);
                  //print('Companies: $futureCompanies');

                  // Переход на второй экран
                  Navigator.pushNamed(
                    context,
                    '/app',
                    arguments: token1, // Передаем токен
                  );

                  // Очистка TextField
                  _emailController.clear();
                  _passwordController.clear();
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(color),
                  ),
                  child: const Text("АВТОРИЗОВАТЬСЯ", style: TextStyle(fontSize: 15,color: Colors.white))
              )
            ),
          ],
        ),),
              Align(alignment: const Alignment(0, 1),
                  child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text('Зарегистрироваться'),
              ),)
      ])
    ));
  }
   //очищение фокуса и контроллеров
   void dispose() {
     _emailFocusNode.dispose();
     _passwordFocusNode.dispose();
     _emailController.dispose();
     _passwordController.dispose(); // Очищаем контроллер
     dispose();
   }
}

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.center,
            child:
            Stack( children: [
              Align(alignment: const Alignment(0, 0),
                child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //текст вход
                    const Text("Регистрация",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 40,
                            decorationStyle: TextDecorationStyle.double,
                            color: color
                        )
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical:25),
                      width: MediaQuery
                          .sizeOf(context)
                          .width / 2,
                      child: TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: const InputDecoration(
                          hintText: "Введите Имя пользователя",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    //первое поле ввода
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical:25),
                      width: MediaQuery
                          .sizeOf(context)
                          .width / 2,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: const InputDecoration(
                          hintText: "Введите email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    //второе поле ввода
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 45),
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode, // Привязываем FocusNode
                          decoration: const InputDecoration(
                            hintText: "Введите пароль",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                    ),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width / 2,
                        //действия кнопки авторизации
                        child: ElevatedButton(onPressed:  () async {

                          String username = _usernameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          _emailFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          // Проверка данных
                          if (email.isEmpty || password.isEmpty ||username.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пожалуйста, заполните все поля')),
                            );
                            return;
                          }

                          try {
                            // Авторизация пользователя
                            await apiService.register(username, email, password);
                            print('User registered');

                            // уведомление о регистрации
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Пользователь зарегистрирован')),
                            );

                            // Очистка TextField
                            _usernameController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                          } catch (e) {
                            print('Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(color),
                            ),
                            child: const Text("ЗАРЕГИСТРИРОВАТЬСЯ", style: TextStyle(fontSize: 15,color: Colors.white))
                        )
                    ),
                  ],
                ),),
              Align(alignment: const Alignment(0, 1),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/');
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Войти'),
                ),)
            ])
        ));
  }
  //очищение фокуса и контроллеров
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose(); // Очищаем контроллер
    dispose();
  }
}

class Order {
  final int id;
  final String product;
  final String supplier;
  final String status;

  Order({required this.id, required this.product, required this.supplier, required this.status});
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

  // Добавление товара в корзину
  void _addToCart(String name, double price) {
    setState(() {
      // Проверяем, есть ли уже такой товар в корзине
      final existingItemIndex = cartItems.indexWhere((item) => item.name == name);
      if (existingItemIndex >= 0) {
        // Увеличиваем количество, если товар уже есть
        cartItems[existingItemIndex].quantity++;
      } else {
        // Добавляем новый товар
        cartItems.add(CartItem(name, price));
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
    try {
      // Подготовка данных заказа
      final orderItems = cartItems.map((item) => {
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      }).toList();

      // Отправка на сервер
      final response = await apiService.createOrder(
        widget.token,
        orderItems,
        totalPrice,
      );

      // Очистка корзины при успехе
      setState(() {
        cartItems.clear();
      });

      // Уведомление пользователя
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заказ успешно оформлен!'),
          backgroundColor: Colors.green,
        ),
      );

      // Можно добавить переход на страницу заказов
      // setState(() => currentPageIndex = 1);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка оформления заказа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final UserProfile user = UserProfile(
    name: 'Имя Фамилия',
    email: 'email@example.com',
    image: 'https://steamuserimages-a.akamaihd.net/ugc/2012598700616315267/BCD2C0C2846E4477E8E8340A4ED4EF095BD2655B/?imw=512&amp;imh=512&amp;ima=fit&amp;impolicy=Letterbox&amp;imcolor=%23000000&amp;letterbox=true',
  );
  final List<Product> products = [
    Product(name: 'Товар 1', image: 'https://steamuserimages-a.akamaihd.net/ugc/2012598700616315267/BCD2C0C2846E4477E8E8340A4ED4EF095BD2655B/?imw=512&amp;imh=512&amp;ima=fit&amp;impolicy=Letterbox&amp;imcolor=%23000000&amp;letterbox=true', price: 29.99),
    Product(name: 'Товар 2', image: 'https://steamuserimages-a.akamaihd.net/ugc/2012598700616315267/BCD2C0C2846E4477E8E8340A4ED4EF095BD2655B/?imw=512&amp;imh=512&amp;ima=fit&amp;impolicy=Letterbox&amp;imcolor=%23000000&amp;letterbox=true', price: 49.99),
    Product(name: 'Товар 3', image: "https://steamuserimages-a.akamaihd.net/ugc/2012598700616315267/BCD2C0C2846E4477E8E8340A4ED4EF095BD2655B/?imw=512&amp;imh=512&amp;ima=fit&amp;impolicy=Letterbox&amp;imcolor=%23000000&amp;letterbox=true", price: 19.99),
  ];

  final List<Order> orders = [
    Order(id: 1, product: "Ноутбук", supplier: "TechCorp", status: "В пути"),
    Order(id: 2, product: "Монитор", supplier: "Display Ltd", status: "Доставлено"),
  ];

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  void initState() {
    super.initState();
    // Загружаем данные с использованием токена
    futureCompanies = apiService.getCompanies(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.black38,
        indicatorColor: color,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.delivery_dining_rounded),
            label: 'Заказы',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.location_on)),
            label: 'Отслеживание',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Корзина',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(''),
              child: Icon(Icons.account_circle),
            ),
            label: 'Аккаунт',
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
                    color: Colors.black12,
                    margin: EdgeInsets.all(4),
                    child: ListTile(
                      title: Text(company.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(company.description),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Действие при нажатии на компанию
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompaniesCart(
                                token: widget.token,
                                id: company.id,
                              name: company.name,
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
        ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Material(color: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child:ListTile(
                  title: Text(order.product),
                  subtitle: Text("Поставщик: ${order.supplier}"),
                  trailing: Chip(label: Text(order.status)),
                ),), );
          },
        ),

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
                    color: Colors.grey,
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.price.toStringAsFixed(2)} ₽',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Кнопки количества
                          Row(
                            children: [
                              IconButton(
                                icon: item.quantity > 1 ? Icon(Icons.remove) :  Icon(Icons.delete),
                                onPressed: () => _updateQuantity(index, item.quantity - 1),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon:  const Icon(Icons.add),
                                onPressed: () => _updateQuantity(index, item.quantity + 1),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          // Сумма по позиции
                          Text(
                            '${(item.price * item.quantity).toStringAsFixed(2)} ₽',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                color: Colors.white,
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
                  // Итоговая строка
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Итого:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ₽',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
                        // Оформление заказа
                        _placeOrder();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Оформить заказ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.image),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text('Имя: ${user.name}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity; // поле количества

  CartItem(this.name, this.price, [this.quantity = 1]);
}

class Product {
  final String name;
  final String image;
  final double price;

  Product({required this.name, required this.image, required this.price});
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

class CompaniesCart extends StatefulWidget {
  final String token;
  final String id;
  final String name;
  final Function(String, double) onAddToCart;
  const CompaniesCart({super.key, required this.token, required this.id, required this.name,required this.onAddToCart,});

  @override
  State<CompaniesCart> createState() => _CompaniesCartState();
}

class _CompaniesCartState extends State<CompaniesCart> {
  late Future<List<Products>> futureCart;
  @override

  void initState() {
    super.initState();
        // Загружаем данные с использованием токена
        futureCart = apiService.getProducts(widget.token, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body:
        FutureBuilder<List<Products>>(
              future: futureCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Нет данных о товарах'));
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        color: Colors.black12,
                        margin: EdgeInsets.all(4),
                        child: Stack( children: [
                          ListTile(
                            title: Text(product.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.description),
                              ],
                            ),
                          ),
                          Container(
                            alignment: const Alignment(0.6, 0),
                            padding: EdgeInsets.symmetric(vertical: 22),
                            child: Text(product.price.toString() + ' ₽'),
                          ),
                          Container(
                            alignment: const Alignment(1, 0),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            child:ElevatedButton(
                              onPressed: () {
                                widget.onAddToCart(product.name, product.price);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${product.name} добавлен в корзину')),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(color),
                              ),
                              child: const Icon(Icons.shopping_cart, color: Colors.black),
                            ),
                          ),
                        ])
                      );
                    },
                  );
                }
              },
            ),
    );}
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
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      itemsPerBox: json['itemsPerBox'],
      company: json['company'],
      description: json['description'],
    );
  }
}