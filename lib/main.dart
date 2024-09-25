import 'package:flutter/material.dart';
import 'demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductList(title: 'Продукция'),
    );
  }
}

//страница с продукцией
class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.title});

  final String title;

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
                      child: ElevatedButton(onPressed: () => {
                        setState(() {
                        //функция для добавления товара в корзину
                      })
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
                        child: GestureDetector(onTap: () => {
                        setState(() {
                          //функция для настройки карточки товара
                        })
                      },
                          child: const Icon(Icons.settings, color: Colors.black, size: 20,)
                      ),
                    )),
                    Column(children: [
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
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingCart()),
          );
        },
        tooltip: 'Добавить товар',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ShoppingCart extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: const Text("Дабавление товара",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Введите название товара"
            ),
            onSubmitted: (text1) {

            },
          ),
           Row(children: [
             Container(
               width: MediaQuery.sizeOf(context).width/2,
               child: TextField(
                 decoration: const InputDecoration(
                     border: OutlineInputBorder(),
                     hintText: "Введите закупочную цену товара"
                 ),
                 onSubmitted: (text2) {

                 },
               ),
             ),
             Container(
               width: MediaQuery.sizeOf(context).width/2,
                 child: TextField(
               decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: "Введите наценку"
               ),
               onSubmitted: (text3) {

               },
             )
             )
           ],),
        ],
      )
    );
  }
}
