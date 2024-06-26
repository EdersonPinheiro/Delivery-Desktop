import 'package:flutter/material.dart';
import 'package:delivery_desktop/controller/product_controller.dart';
import 'package:get/get.dart';

import '../model/product.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Product? product;
  final ProductController productController = Get.put(ProductController());
  bool _isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isVisible = true;
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (!_isVisible) {
        productController.addProduct(widget.product);
      } else {
        productController.removeProduct(widget.product);
      }
    });
  }

  void _decrementQuantity(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
      }
    });
  }

  void _incrementQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xff1f2029),
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Visibility(
                visible: _isVisible,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  onPressed: () {
                    _toggleVisibility();
                  },
                  child: const Text("Adicionar"),
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: !_isVisible,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    _toggleVisibility();
                  },
                  child: const Text("Adicionado"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
