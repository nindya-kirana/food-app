import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Tetap butuh ini
import 'package:provider/provider.dart';
// Hapus: import 'firebase_options.dart'; 
import 'providers/cart_provider.dart';
import 'screens/menu_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Panggil initializeApp() TANPA ARGUMEN 'options'
  // Ini akan menggunakan file konfigurasi yang ada di folder platform (e.g., google-services.json di Android)
  await Firebase.initializeApp(); 
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pemesanan Makanan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuListScreen(), 
    );
  }
}