import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../constants/auth.dart';
import '../model/order.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final LiveQuery liveQuery = LiveQuery();
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject("Order"));

  @override
  void initState() {
    super.initState();
    getOrders();
    startLiveQuery();
  }

  Future<void> startLiveQuery() async {
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value) {
      debugPrint("Object Created: ${value["status"]}");
      getOrders();
      Get.forceAppUpdate();
    });

    subscription.on(LiveQueryEvent.update, (value) {
      debugPrint("Object Created: ${value["status"]}");
      if (value["status"] == "paid") {
        Get.forceAppUpdate();
      }
      Get.forceAppUpdate();
    });
  }

  bool _showDetails = false;

  void _showDetailsDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes do pedido #${order.id}'),
          content: Text(
              'Total: ${order.total.toStringAsFixed(2)}\nCriado às: ${DateFormat.yMd().add_jm().format(order.createdAt)}'),
          actions: [
            TextButton(
              onPressed: () {
                updateOrder(order.id);
                Navigator.of(context).pop();
              },
              child: Text('Iniciar produção'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        // Atualizar o estado para esconder o AlertDialog
      });
    });
  }

  void _showDetailsDialogPronto(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes do pedido #${order.id}'),
          content: Text(
              'Total: ${order.total.toStringAsFixed(2)}\nCriado às: ${DateFormat.yMd().add_jm().format(order.createdAt)}'),
          actions: [
            TextButton(
              onPressed: () {
                updateOrderPronto(order.id);
                Navigator.of(context).pop();
              },
              child: Text('Concluir Pedido'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        // Atualizar o estado para esconder o AlertDialog
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(
                  10), // margem para o espaçamento entre os cards
              child: Card(
                child: InkWell(
                  child: Column(
                    children: [
                      Card(
                        child: InkWell(
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history_toggle_off_rounded,
                                    color: Colors.deepOrange,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Fila de Espera",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: 800,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FutureBuilder<List<Order>>(
                            future: getOrders(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Order>> snapshot) {
                              if (snapshot.hasData) {
                                return Card(
                                  child: Column(
                                    children: snapshot.data!
                                        .map(
                                          (order) => Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    10), // margem para o espaçamento entre os ListTile
                                            child: Card(
                                              child: InkWell(
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                onTap: () {
                                                  _showDetailsDialog(order);
                                                },
                                                child: SizedBox(
                                                  width: 400,
                                                  height: 120,
                                                  child: ListTile(
                                                    title: Text(
                                                        'Order #${order.id}'),
                                                    subtitle: Text(
                                                      'Total: ${order.total.toStringAsFixed(2)}\nCriado às: ${DateFormat.yMd().add_jm().format(order.createdAt)}',
                                                    ),
                                                    trailing:
                                                        Text(order.status),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                  10), // margem para o espaçamento entre os cards
              child: Card(
                child: InkWell(
                  child: Column(
                    children: [
                      Card(
                        child: InkWell(
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    color: Colors.deepOrange,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Em Produção",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: 800,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FutureBuilder<List<Order>>(
                            future: getOrdersProducao(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Order>> snapshot) {
                              if (snapshot.hasData) {
                                return Card(
                                  child: Column(
                                    children: snapshot.data!
                                        .map(
                                          (order) => Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    10), // margem para o espaçamento entre os ListTile
                                            child: Card(
                                              child: InkWell(
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                onTap: () {
                                                  _showDetailsDialogPronto(
                                                      order);
                                                },
                                                child: SizedBox(
                                                  width: 400,
                                                  height: 120,
                                                  child: ListTile(
                                                    title: Text(
                                                        'Order #${order.id}'),
                                                    subtitle: Text(
                                                      'Total: ${order.total.toStringAsFixed(2)}\nCriado às: ${DateFormat.yMd().add_jm().format(order.createdAt)}',
                                                    ),
                                                    trailing:
                                                        Text(order.status),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                  10), // margem para o espaçamento entre os cards
              child: Card(
                child: InkWell(
                  child: Column(
                    children: [
                      Card(
                        child: InkWell(
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.room_service,
                                    color: Colors.deepOrange,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Pronto!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: 800,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FutureBuilder<List<Order>>(
                            future: getOrdersPronto(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Order>> snapshot) {
                              if (snapshot.hasData) {
                                return Card(
                                  child: Column(
                                    children: snapshot.data!
                                        .map(
                                          (order) => Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    10), // margem para o espaçamento entre os ListTile
                                            child: Card(
                                              child: InkWell(
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                onTap: () {},
                                                child: SizedBox(
                                                  width: 400,
                                                  height: 120,
                                                  child: ListTile(
                                                    title: Text(
                                                        'Order #${order.id}'),
                                                    subtitle: Text(
                                                      'Total: ${order.total.toStringAsFixed(2)}\nCriado às: ${DateFormat.yMd().add_jm().format(order.createdAt)}',
                                                    ),
                                                    trailing:
                                                        Text(order.status),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Order>> getOrders() async {
    var dio = Dio();
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-all-orders');
    if (response.data["result"] != null) {
      return (response.data["result"] as List)
          .map((data) => Order.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Order>> getOrdersProducao() async {
    var dio = Dio();
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio.post(
        'https://parseapi.back4app.com/parse/functions/get-all-orders-producao');
    if (response.data["result"] != null) {
      return (response.data["result"] as List)
          .map((data) => Order.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Order>> getOrdersPronto() async {
    var dio = Dio();
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio.post(
        'https://parseapi.back4app.com/parse/functions/get-all-orders-pronto');
    if (response.data["result"] != null) {
      return (response.data["result"] as List)
          .map((data) => Order.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> updateOrder(String order) async {
    try {
      await Dio().post(
          'https://parseapi.back4app.com/parse/functions/update-order-producao',
          options: Options(
            headers: {
              'X-Parse-Application-Id':
                  'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
              'X-Parse-REST-API-Key':
                  'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
              'X-Parse-Session-Token': '${token}',
              'Content-Type': 'application/json;charset=UTF-8',
            },
          ),
          data: {"orderId": order, "producao": "f"});
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> updateOrderPronto(String order) async {
    try {
      await Dio().post(
          'https://parseapi.back4app.com/parse/functions/update-order-pronto',
          options: Options(
            headers: {
              'X-Parse-Application-Id':
                  'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
              'X-Parse-REST-API-Key':
                  'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
              'X-Parse-Session-Token': '${token}',
              'Content-Type': 'application/json;charset=UTF-8',
            },
          ),
          data: {"orderId": order, "pronto": "f"});
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
