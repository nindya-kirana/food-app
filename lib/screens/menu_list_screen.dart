// lib/screens/menu_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import wajib untuk Base64 decoding
import 'dart:convert'; 

import '../services/firebase_service.dart';
import '../providers/cart_provider.dart'; // Wajib
import 'cart_screen.dart';
import '../models/menu_model.dart'; 

class MenuListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Makanan"),
        actions: [
          // Tombol Keranjang (tetap ada)
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
          ),
        ],
      ),
      body: StreamBuilder<List<Menu>>(
        stream: FirebaseService().getMenus(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          if (snapshot.hasError) return Center(child: Text('Error memuat data: ${snapshot.error}'));

          // Mengelompokkan berdasarkan kategori
          Map<String, List<Menu>> categories = {};
          for (var menu in snapshot.data!) {
            categories.putIfAbsent(menu.category, () => []).add(menu);
          }

          return ListView(
            children: categories.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(entry.key, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...entry.value.map((menu) => ListTile(
                    
                    // === TAMPILAN GAMBAR BASE64 (TIDAK BERUBAH) ===
                    leading: (menu.imageUrl.isNotEmpty) 
                      ? Image.memory(
                          // Decode Base64 string kembali ke bytes
                          base64Decode(menu.imageUrl), 
                          width: 50, 
                          height: 50, 
                          fit: BoxFit.cover,
                          // Penanganan error untuk Base64
                          errorBuilder: (context, error, stackTrace) {
                            print('Base64 Decoding Failed for ${menu.name}: $error'); 
                            return Icon(Icons.image_not_supported, color: Colors.red);
                          },
                        )
                      : Icon(Icons.image_not_supported, color: Colors.grey), // Jika imageUrl kosong
                    // ===========================================
                    
                    title: Text(menu.name),
                    subtitle: Text("Rp ${menu.price.toStringAsFixed(0)}"),
                    
                    // === MODIFIKASI: MENGGANTI TOMBOL DENGAN QUANTITY CONTROL ===
                    trailing: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        // Ambil jumlah item di keranjang
                        final quantity = cart.getItemQuantity(menu); 

                        if (quantity > 0) {
                          // TAMPILKAN QUANTITY CONTROL (MINUS - JUMLAH - PLUS)
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Kurang (-)
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => cart.decrementQuantity(menu),
                              ),
                              
                              // Teks Jumlah
                              Text(
                                quantity.toString(), 
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              
                              // Tombol Tambah (+)
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => cart.incrementQuantity(menu),
                              ),
                            ],
                          );
                        } else {
                          // TAMPILKAN TOMBOL "TAMBAH" jika jumlahnya 0
                          return ElevatedButton(
                            onPressed: () {
                              // Panggil incrementQuantity (yang sama dengan menambah item baru)
                              cart.incrementQuantity(menu);
                            },
                            child: Text("Tambah"),
                          );
                        }
                      },
                    ),
                    // =======================================================
                  )).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}