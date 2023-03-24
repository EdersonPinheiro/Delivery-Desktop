import 'package:dio/dio.dart';
import '../constants/auth.dart';
import '../model/product.dart';
class ProductController {
  List<Product> productOrder = [];
  
  late List<Product> products = [];
  final Dio dio = Dio();
  bool isLoading = true;

  Future<List<Product>> getProducts() async {
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio
        .post('https://parseapi.back4app.com/parse/functions/get-all-products');

    if (response.data["result"] != null) {
      products = (response.data["result"] as List)
          .map((data) => Product.fromJson(data))
          .toList();
      //return products;
    }

    return [];
  }
}