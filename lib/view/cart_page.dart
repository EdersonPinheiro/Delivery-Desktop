import 'package:delivery_desktop/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ProductController productController = Get.put(ProductController());
  late List<Product> products;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          _topMenu(
            title: 'Pedidos',
            subTitle: 'Mesa 8',
            action: Container(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: productController.productList.length,
                itemBuilder: (context, index) {
                  final product = productController.productList[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.title,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('\$${product.price}',
                          style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            productController.removeProduct(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xff1f2029),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          'Total: ${productController.totalPrice.value.toStringAsFixed(2)} R\$',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 2,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('Finalizar Compra')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _topMenu({
  required String title,
  required String subTitle,
  required Widget action,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subTitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
      Expanded(flex: 1, child: Container(width: double.infinity)),
      Expanded(flex: 5, child: action),
    ],
  );
}
