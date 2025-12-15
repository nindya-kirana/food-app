import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/menu_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  CartProvider() { loadCart(); }

  // FUNGSI UTAMA: MENDAPATKAN JUMLAH ITEM TERTENTU (PENTING)
  int getItemQuantity(Menu menu) {
    int index = _items.indexWhere((i) => i.menu.id == menu.id);
    if (index >= 0) {
      return _items[index].quantity;
    }
    return 0;
  }
  
  // MENGGANTI addToCart LAMA menjadi FUNGSI INCREMENT (Untuk Tombol '+')
  void incrementQuantity(Menu menu) {
    int index = _items.indexWhere((i) => i.menu.id == menu.id);
    
    if (index >= 0) {
      // 1. Jika sudah ada, tambah jumlahnya
      _items[index].quantity++;
    } else {
      // 2. Jika belum ada, tambahkan item baru dengan quantity 1
      _items.add(CartItem(
        menu: menu, 
        addedTime: DateTime.now(),
        quantity: 1, // Pastikan dimulai dari 1
      ));
    }
    
    // Sortir dan simpan (gunakan ID menu sebagai pembanding yang lebih akurat)
    _items.sort((a, b) => a.addedTime.compareTo(b.addedTime));
    saveCart();
    notifyListeners();
  }

  // FUNGSI BARU: MENGURANGI JUMLAH ITEM (Untuk Tombol '-')
  void decrementQuantity(Menu menu) {
    int index = _items.indexWhere((i) => i.menu.id == menu.id);
    
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        // Kurangi jumlah jika > 1
        _items[index].quantity--;
      } else {
        // Hapus item dari list jika jumlahnya sisa 1
        _items.removeAt(index);
      }
      
      saveCart();
      notifyListeners();
    }
  }

  // Perhitungan Biaya (Tetap sama, sudah benar)
  double get subtotal => _items.fold(0, (sum, item) => sum + (item.menu.price * item.quantity));
  double get serviceCharge => subtotal * 0.075;
  double get pb1 => (subtotal + serviceCharge) * 0.10;
  double get totalPayment => subtotal + serviceCharge + pb1;

  // Hapus semua item
  void clearCart() {
    _items.clear();
    saveCart();
    notifyListeners();
  }

  // Persistence (Tetap sama, sudah benar)
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('user_cart', data);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('user_cart');
    if (data != null) {
      _items = data.map((item) => CartItem.fromJson(jsonDecode(item))).toList();
      notifyListeners();
    }
  }
  
  // Mengganti fungsi addToCart lama dengan incrementQuantity baru
  void addToCart(Menu menu) {
    incrementQuantity(menu);
  }
}