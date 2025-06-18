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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
  Future<void> _generateAndSavePdf() async {
    // 1. Создаем PDF документ
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();

    // 2. Добавляем страницу
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return _buildPdfContent(context, font); // Ваш метод для содержимого
        },
      ),
    );

    // 3. Сохраняем PDF в файл
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_${widget.order.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    // 4. Открываем PDF (или предлагаем печать)
    await OpenFile.open(file.path);

    // Альтернатива: сразу печатать
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdf.save(),
    // );
  }

  pw.Widget _buildPdfContent(pw.Context context, font) {
    final order = widget.order;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    return pw.Column(

      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Заголовок
        pw.Header(
          level: 0,
          child: pw.Text('Накладная №${order.id.substring(0, 8)}',
          style: pw.TextStyle(font: font)),
        ),
        pw.SizedBox(height: 15),

        pw.Text('Дата: ${dateFormat.format(order.createdAt)}', style: pw.TextStyle(font: font)),
        pw.SizedBox(height: 20),

        // Информация о доставке
        pw.Text('Адрес доставки: ${order.shippingAddress}', style: pw.TextStyle(font: font)),
        pw.Text('Способ оплаты: ${_getPaymentMethodText(order.paymentMethod)}', style: pw.TextStyle(font: font)),
        pw.SizedBox(height: 30),

        // Таблица товаров
        pw.TableHelper.fromTextArray(
          context: context,
          border: null,
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(2), // Используйте BorderRadius.circular
            color: PdfColors.grey300, // Также исправлена опечатка в greg300 -> grey300
          ),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
          headers: ['№', 'Наименование', 'Кол-во', 'Цена', 'Сумма'],
          data: order.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return [
              pw.Center(child:
              pw.Text(
                '${index + 1}',
                style: pw.TextStyle(
                  font: font, // Ваш шрифт
                  fontSize: 10,
                ),
              ),),
            pw.Center(child:
              pw.Text(
                item.product.name,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),),
              pw.Center(child:
              pw.Text(
                '${item.quantity}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                ),
              ),),
                pw.Center(child:
              pw.Text(
                '${item.price.toStringAsFixed(2)} ₽',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                ),
              ),),
            pw.Center(child:
              pw.Text(
                '${(item.price * item.quantity).toStringAsFixed(2)} ₽',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),),
            ];
          }).toList(),
        ),
        pw.SizedBox(height: 30),

        // Итого
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Итого: ${order.total.toStringAsFixed(2)} ₽',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 16,
              font: font
            ),
          ),
        ),

        // Подпись
        pw.SizedBox(height: 50),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(
            children: [
              pw.Text('_________________________', style: pw.TextStyle(font: font)),
              pw.Text('Подпись исполнителя', style: pw.TextStyle(font: font)),
            ],
          ),
        ),
        pw.SizedBox(height: 50),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(
            children: [
              pw.Text('_________________________', style: pw.TextStyle(font: font)),
              pw.Text('Подпись заказчика', style: pw.TextStyle(font: font)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                      IconButton(
                        icon: Icon(Icons.picture_as_pdf),
                        onPressed: _generateAndSavePdf,
                        tooltip: 'Скачать накладную',
                      ),
                  Container(
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.order.status),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      _getStatusText(widget.order.status),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Продуктов: ${widget.order.items.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Сумма: ${widget.order.total.toStringAsFixed(2)} ₽',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary
                ),
              ),

              // Детали заказа (раскрываются по нажатию)
              if (_expanded) ...[
                const SizedBox(height: 16),
                Divider(color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 8),
                Text(
                  'Состав заказа:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
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
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        '${(item.product.price * item.quantity).toStringAsFixed(2)} ₽',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 8),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Text(
                  'Адрес доставки:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                Text(
                  widget.order.shippingAddress,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Способ оплаты:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                Text(
                  _getPaymentMethodText(widget.order.paymentMethod),
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Итого:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                    Text(
                      '${widget.order.total.toStringAsFixed(2)} ₽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
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
  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'card':
        return 'Карта';
      case 'cash':
        return 'Наличные';
      case 'SberPay':
        return 'SberPay';
      default:
        return method;
    }
  }
}
