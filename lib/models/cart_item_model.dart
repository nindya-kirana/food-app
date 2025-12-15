import 'menu_model.dart';

class CartItem {
  final Menu menu;
  int quantity;
  final DateTime addedTime;

  CartItem({required this.menu, this.quantity = 1, required this.addedTime});

  // Untuk penyimpanan lokal (JSON)
  Map<String, dynamic> toJson() => {
    'menu': menu.toMap(),
    'quantity': quantity,
    'addedTime': addedTime.toIso8601String(),
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menu: Menu.fromMap('', json['menu']),
      quantity: json['quantity'],
      addedTime: DateTime.parse(json['addedTime']),
    );
  }
}