import 'package:flutter/material.dart';
import 'demo.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

Ramdom ramdom = Ramdom();

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

//страница с входа
class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   final FocusNode _emailFocusNode = FocusNode();
   final FocusNode _passwordFocusNode = FocusNode();

//отвечает за получение данных из форм на странице входа и отправки их на сервер после нажатия кнопки "аторизация"
   Future<void> loginController() async{
     String email = _emailController.text;
     String password = _passwordController.text;

     // Выводим данные в консоль (или отправляем на сервер)
     print('Email: $email');
     print('Password: $password');

     try {
       await apiService.login(email, password);
       print('User logged');
       //получение списка компаний
       final companies = await apiService.getCompanies('jsonwebtoken');
       print('Companies: $companies');
     } catch (e) {
       print('Error: $e');
     }

     // Очистка TextField
     _emailController.clear();
     _passwordController.clear();
   }

  Future<void> _register() async {
    // Логика регистрации
    try {
      await apiService.register('testuser', 'test@example.com', 'password123');
      print('User registered');
    } catch (e) {
      print('Error: $e');
    }
  }

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
              child: ElevatedButton(onPressed:  () async {

                String email = _emailController.text;
                String password = _passwordController.text;

                _emailFocusNode.unfocus();
                _passwordFocusNode.unfocus();
                // Проверка данных
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Пожалуйста, заполните все поля')),
                  );
                  return;
                }

                try {
                  // Авторизация пользователя
                  final token = await apiService.login(email, password);
                  print('User logged in');
                  final token1 = token['token'];
                  // Получение списка компаний
                  final companies = await apiService.getCompanies(token1);

                  print('Companies: $companies');

                  // Переход на второй экран (опционально)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationExample(),
                    ),
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
                onPressed: _register,
                child: Text('Зарегистрироваться'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),)
      ])
    ));
  }
}


//страница с продукцией
class ProductList extends StatefulWidget {
  const ProductList({super.key});

  final String title = 'Продукты';

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child:
        ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 1,
          itemBuilder: (buildContext, int index){
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 120,
                child: Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(children: [
                    Container(
                      alignment: const Alignment(0.75, 0),
                      child: ElevatedButton(onPressed: () {
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(builder: (context) => CartEditor()),);
                      },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.green)
                        ),
                        child: const Icon(Icons.shopping_cart, color: Colors.black)
                    ),
                  ),
                    Container(
                      alignment: const Alignment(0.98, -0.98),
                      child: SizedBox( height: 40, width: 40,
                        child: GestureDetector(onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartEditor()),
                          );
                        },
                          child: const Icon(Icons.settings, color: Colors.black, size: 20,)
                      ),
                    )),
                    Column(
                      children: [
                          Container(
                            alignment: const Alignment(-1, -1),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10 ),
                            height: 40,
                            width: MediaQuery.of(context).size.width-165,
                            child:  Text("Название", style: TextStyle(fontSize: 20)),),
                          Container(
                            alignment: const Alignment(-1, 0),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            height: 40,
                            width: MediaQuery.of(context).size.width-165,
                            child: Text("Цена в закупке: ", style: TextStyle(fontSize: 20, color: Colors.red)),),
                          Container(
                              alignment: const Alignment(-1, 1),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              height: 40,
                              width: MediaQuery.of(context).size.width-165,
                              child:  Text("Цена:" , style: TextStyle(fontSize: 20, color: Colors.green))),
                        ],
                        )
                  ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}

class ShoppingCart extends StatelessWidget{
  const ShoppingCart({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Добавление товара"),
      ),
      body: Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Container(

              child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Введите название товара"
            ),
            onSubmitted: (text1) {
              description = text1;
            },
          )),
             Container(
               padding: const EdgeInsets.symmetric(vertical: 3),
               width: MediaQuery.sizeOf(context).width,
               child: TextField(
                 decoration: const InputDecoration(
                     border: OutlineInputBorder(),
                     hintText: "Введите закупочную цену"
                 ),
                 onSubmitted: (text2) {
                   price = int.parse(text2);
                 },
               ),
             ),
             Container(
               width: MediaQuery.sizeOf(context).width,
                 child: TextField(
               decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: "Введите наценку"
               ),
               onSubmitted: (text3) {
                 percent = int.parse(text3);
               },
                 )
             )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          transit();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductList()),
          );
        },
        tooltip: 'Сохранить товар',
        child: const Icon(Icons.save),
      ),
    );
  }
  transit(){
    Ramdom ramdom = Ramdom();
    ramdom.main(description: description, price: price, percent: percent);
  }
}


class CartEditor extends StatelessWidget{
  const CartEditor({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Изменение товара"),
      ),
      body: Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Container(

              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Введите новое название товара"
                ),
                onSubmitted: (text1) {
                  description = text1;
                },
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            width: MediaQuery.sizeOf(context).width,
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Введите новую закупочную цену"
              ),
              onSubmitted: (text2) {
                price = int.parse(text2);
              },
            ),
          ),
          Container(
              width: MediaQuery.sizeOf(context).width,
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Введите новую наценку"
                ),
                onSubmitted: (text3) {
                  percent = int.parse(text3);
                },
              )
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductList()),
          );
        },
        tooltip: 'Сохранить товар',
        child: const Icon(Icons.save),
      ),
    );
  }

}

class OrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(id: 1, product: "Ноутбук", supplier: "TechCorp", status: "В пути"),
    Order(id: 2, product: "Монитор", supplier: "Display Ltd", status: "Доставлено"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Business',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'School',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Settings',
            backgroundColor: color,
          ),
        ],
       // currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
       // onTap: _onItemTapped,
      ),
      appBar: AppBar(title: Text("Заказы", style: TextStyle(color:Colors.white)), backgroundColor: color ),
      body: ListView.builder(
        itemCount: orders.length,
        padding: const EdgeInsets.all(5),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2.5),
            child: Material(color: Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child:ListTile(
              title: Text(order.product),
              subtitle: Text("Поставщик: ${order.supplier}"),
              trailing: Chip(label: Text(order.status)),
            ),), );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductList()),
          );
        },
        tooltip: 'Сделать заказ',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Order {
  final int id;
  final String product;
  final String supplier;
  final String status;

  Order({required this.id, required this.product, required this.supplier, required this.status});
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState(cartItems: [
    CartItem('Товар 1', 29.99),
    CartItem('Товар 2', 49.99),
    CartItem('Товар 3', 19.99),
  ]);
}

class _NavigationExampleState extends State<NavigationExample> {
  final List<CartItem> cartItems;

  _NavigationExampleState({required this.cartItems});

  int currentPageIndex = 0;

  late GoogleMapController mapController;

  final UserProfile user = UserProfile(
    name: 'Имя Фамилия',
    email: 'email@example.com',
    image: 'https://via.placeholder.com/150',
  );
  final List<Product> products = [
    Product(name: 'Товар 1', image: 'https://via.placeholder.com/150', price: 29.99),
    Product(name: 'Товар 2', image: 'https://via.placeholder.com/150', price: 49.99),
    Product(name: 'Товар 3', image: 'https://via.placeholder.com/150', price: 19.99),
  ];

  final List<Order> orders = [
    Order(id: 1, product: "Ноутбук", supplier: "TechCorp", status: "В пути"),
    Order(id: 2, product: "Монитор", supplier: "Display Ltd", status: "Доставлено"),
  ];

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + item.price);
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
        ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              color: Colors.black12,
              margin: EdgeInsets.all(4),
              child: ListTile(
                leading: Image.network(product.image),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Icon(Icons.shopping_cart),
                onTap: () {
                  // Действие при нажатии на товар
                },
              ),
            );
          },
        ),
        /// Orders page
        ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2.5),
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
          cartItems.isEmpty ? Center(child: Text('Корзина пуста')) : ListView.builder(
          itemCount: cartItems.length,
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2.5),
              child: Material(color: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child:ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),), ));
          },
        ),),
          Align(alignment: Alignment(-1, 1),
            child: Container(
            height: 50,
            width: 150,
            color: Colors.deepPurpleAccent,
            alignment: Alignment(0, 0),
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
              SizedBox(height: 16),
              Text('Имя: ${user.name}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),
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