class Product {
  final String id;
  final String name;
  final String des;
  final double price;
  final String imgURL;

  Product({
    required this.id,
    required this.name,
    required this.des,
    required this.price,
    required this.imgURL,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      des: json['des'],
      price: (json['price'] as num).toDouble(),
      imgURL: json['imgURL'],
    );
  }
}