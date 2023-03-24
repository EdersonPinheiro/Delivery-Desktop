class Product {
  String image;
  String title;
  String description;
  num price;
  int quantity;

  Product(
      {required this.image,
      required this.title,
      required this.description,
      required this.price,
      this.quantity = 1});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        image: json['imageUrl'],
        title: json['title'],
        description: json['description'],
        price: json['price'],);
  }
}
