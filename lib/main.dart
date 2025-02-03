import 'package:flutter/material.dart';
import 'demo.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Ramdom ramdom = Ramdom();

String description = "";
int? price = 0;
int? percent = 0;
const color = Colors.deepPurple;
void main() async {
  await Parse().initialize(
    'Ee84hKKesmZVd80u4qW7Zo3zb7ONuEqlcxt4AcHC',    // Replace with your App ID
    'https://parseapi.back4app.com',
    clientKey: 'NSD1MsWi2U32CJ1wStSD513AIHbD1vniuq45lXa4',  // Replace with your Client Key
  );
  runApp(const MyApp());

  //testConnection();
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
      home: const LoginScreen(),
    );
  }
}

//страница с входа
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
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
                decoration: const InputDecoration(
                  hintText: "Введите логин",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onSubmitted: (login) {
                  //ввод текста
                },
              ),
            ),
            //второе поле ввода
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 45),
                width: MediaQuery
                    .sizeOf(context)
                    .width / 2,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Введите пароль",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onSubmitted: (password) {
                   // ввод текста
                  },
                )
            ),
            SizedBox(
              height: 50,
              width: MediaQuery
                  .sizeOf(context)
                  .width / 2,
              child: ElevatedButton(onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(color),
                  ),
                  child: Text("АВТОРИЗОВАТЬСЯ", style: TextStyle(fontSize: 22,color: Colors.white))
              )
            )
          ],
        ),
      )
    );
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

class OrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(id: 1, product: "Ноутбук", supplier: "TechCorp", status: "В пути"),
    Order(id: 2, product: "Монитор", supplier: "Display Ltd", status: "Доставлено"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Заказы", style: TextStyle(color: Colors.white)), backgroundColor: color ),
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