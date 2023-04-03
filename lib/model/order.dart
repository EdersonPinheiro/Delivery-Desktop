class Order {
  String id;
  num total;
  DateTime createdAt;
  String status;

  Order(
      {required this.id,
      required this.total,
      required this.createdAt,
      required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      createdAt: DateTime.parse(json['due']['iso']),
      status: json['status'],
    );
  }
}
