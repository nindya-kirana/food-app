class Menu {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final int displayOrder;

  Menu({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.displayOrder,
  });

  factory Menu.fromMap(String id, Map<String, dynamic> data) {
    return Menu(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? 'Lainnya',
      displayOrder: data['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'category': category,
    'displayOrder': displayOrder,
  };
}