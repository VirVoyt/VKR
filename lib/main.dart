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

                  // Переход на второй экран (опционально)
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
                  child: const Text("АВТОРИЗОВАТЬСЯ", style: TextStyle(fontSize: 22,color: Colors.white))
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
                  textStyle: const TextStyle(fontSize: 18),
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
                        width: MediaQuery.sizeOf(context).width / 1.6,
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
                            child: const Text("ЗАРЕГИСТРИРОВАТЬСЯ", style: TextStyle(fontSize: 22,color: Colors.white))
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
  State<ShopPage> createState() => _ShopPageState(cartItems: [
    CartItem('Товар 1', 29.99),
    CartItem('Товар 2', 49.99),
    CartItem('Товар 3', 19.99),
  ]);
}

class _ShopPageState extends State<ShopPage> {
  final List<CartItem> cartItems;
  late Future<List<Companies>> futureCompanies;// Добавляем Future для компаний

  _ShopPageState({required this.cartItems});

  int currentPageIndex = 0;

  late GoogleMapController mapController;

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
    return cartItems.fold(0, (sum, item) => sum + item.price);
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
                          Text('Email: ${company.contactEmail}'),
                          Text('Телефон: ${company.contactPhone}'),
                          Text('Адрес: ${company.address}'),
                          Text('Сайт: ${company.website}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Действие при нажатии на компанию
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

        /// shopping cart page
        Stack(children: [
          Container(child:
          cartItems.isEmpty ? const Center(child: Text('Корзина пуста')) : ListView.builder(
          itemCount: cartItems.length,
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Material(color: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child:ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),), ));
          },
        ),),
          Align(alignment: const Alignment(-1, 1),
            child: Container(
            height: 50,
            width: 150,
            color: Colors.deepPurpleAccent,
            alignment: const Alignment(0, 0),
            child: Text('Итого: \$${totalPrice.toStringAsFixed(2)}'),
          ),)
          ]
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

  CartItem(this.name, this.price);
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


  Companies({
    required this.id,
    required this.name,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.website,

  });

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      id: json['_id'],
      name: json['name'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      address: json['address'],
      website: json['website'],

    );
  }
}