import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.menu.name),
                  subtitle: Text("${item.quantity} x Rp ${item.menu.price}"),
                  trailing: Text("Rp ${(item.quantity * item.menu.price).toStringAsFixed(0)}"),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Column(
              children: [
                _buildRow("Subtotal", cart.subtotal),
                _buildRow("Service Charge (7.5%)", cart.serviceCharge),
                _buildRow("PB1 (10%)", cart.pb1),
                Divider(),
                _buildRow("Total Pembayaran", cart.totalPayment, isBold: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("Rp ${value.toStringAsFixed(0)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}