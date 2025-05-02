part of 'demo.dart';

class CompaniesCart extends StatefulWidget {
  final String token;
  final String id;
  final String name;
  final String description;
  final String website;
  final String contactEmail;
  final String contactPhone;
  final String address;
  final Function(String, double, String) onAddToCart;
  const CompaniesCart({super.key,
    required this.token,
    required this.id,
    required this.name,
    required this.onAddToCart,
    required this.description,
    required this.website,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
  });

  @override
  State<CompaniesCart> createState() => _CompaniesCartState();
}

class _CompaniesCartState extends State<CompaniesCart> {
  late Future<List<Products>> futureCart;

  @override
  void initState() {
    super.initState();
    futureCart = apiService.getProducts(widget.token, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          // Блок с описанием компании
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              color: Theme.of(context).colorScheme.onPrimary,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Информация о компании ' + widget.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description + '\n'
                          'Телефон: ' + widget.contactPhone + '\n'
                          'Email: ' + widget.contactEmail + '\n'
                          'Адрес: ' + widget.address + '\n'
                          'Сайт: ' + widget.website,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Заголовок списка товаров
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Товары компании',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Список товаров
          Expanded(
            child:
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
                          color: Theme.of(context).colorScheme.onPrimary,
                          margin: EdgeInsets.all(4),
                          child: Stack( children: [
                            ListTile(
                              title: Text(product.name,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.description,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              alignment: const Alignment(0.6, 0),
                              padding: EdgeInsets.symmetric(vertical: 22),
                              child: Text(product.price.toString() + ' ₽',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary
                                  )),
                            ),
                            Container(
                              alignment: const Alignment(1, 0),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child:ElevatedButton(
                                onPressed: () {
                                  widget.onAddToCart(product.id, product.price, product.name); // Передаем id продукта
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                        content: Text('${product.name} добавлен в корзину',
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),)
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.tertiary,),
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
          ),
        ],
      ),
    );
  }
}