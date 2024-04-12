import 'package:dio/dio.dart';
import 'package:get/get_rx/get_rx.dart';
import '../constants/auth.dart';
import '../model/product.dart';

class ProductController {
  RxList<Product> productList = <Product>[].obs;
  RxDouble totalPrice = 0.0.obs;

  void addProduct(Product product) {
    productList.add(product);
    totalPrice.value += product.price;
  }

  void removeProduct(Product product) {
    productList.remove(product);
    totalPrice.value -= product.price;
  }

  late List<Product> products = [];
  final Dio dio = Dio();
  bool isLoading = true;

  Future<List<Product>> getProducts() async {
    dio.options.headers = {
      'X-Parse-Application-Id': '',
      'X-Parse-REST-API-Key': '
      'X-Parse-Session-Token': '${token}',
    };

    try {
      final response = await dio.post(
          'https://parseapi.back4app.com/parse/functions/get-all-products');

      if (response.data["result"] != null) {
        products = (response.data["result"] as List)
            .map((data) => Product.fromJson(data))
            .toList();
        //return products;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }
}
