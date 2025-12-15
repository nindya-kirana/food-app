// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Wajib: untuk encoding Base64
import 'dart:io'; // Wajib: untuk kelas File
import '../models/menu_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Hapus: final FirebaseStorage _storage = FirebaseStorage.instance; 

  // FUNGSI BARU: Mengkonversi File gambar ke Base64 String
  Future<String> imageFileToBase64(File imageFile) async {
    // Membaca bytes (data biner) dari file gambar
    List<int> imageBytes = await imageFile.readAsBytes(); 
    // Mengkonversi bytes menjadi string Base64
    String base64Image = base64Encode(imageBytes); 
    return base64Image;
  }
  
  // Hapus: fungsi uploadMenuImage

  Future<bool> isMenuNameExists(String name) async {
    final querySnapshot = await _db.collection('menus')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
  
  Future<void> initializeMenu(List<Menu> initialMenus) async {
    for (var menu in initialMenus) {
      final existing = await _db.collection('menus')
          .where('name', isEqualTo: menu.name)
          .get();
      
      if (existing.docs.isEmpty) {
        await _db.collection('menus').add(menu.toMap());
      }
    }
  }

  Stream<List<Menu>> getMenus() {
    return _db.collection('menus')
        .orderBy('displayOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Menu.fromMap(doc.id, doc.data()))
            .toList());
  }
}