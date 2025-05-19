import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification/services/notification_services.dart';
import 'package:firebase_notification/model/item.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Item>> getItemsStream() {
    try {
      return _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Item.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      debugPrint('Error getting items stream: $e');
      return Stream.error(e);
    }
  }
  
  Future<List<Item>> getItems() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .get();
      return snapshot.docs.map((doc) => Item.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Error fetching items: $e');
      rethrow;
    }
  }

  Future<void> addItem(Item item) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .add(item.toMap());
      await NotificationServices.showNotification(
        title: 'Barang Ditambahkan',
        body: 'Barang ${item.name} berhasil ditambahkan.',
        type: NotificationType.success,
      );
    } catch (e) {
      await NotificationServices.showNotification(
        title: 'Gagal Menambahkan Barang',
        body: e.toString(),
        type: NotificationType.error,
      );
      debugPrint('Error adding item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .doc(item.id)
          .update(item.toMap());
      await NotificationServices.showNotification(
        title: 'Barang Diperbarui',
        body: 'Barang ${item.name} berhasil diperbarui.',
        type: NotificationType.success,
      );
    } catch (e) {
      await NotificationServices.showNotification(
        title: 'Gagal Memperbarui Barang',
        body: e.toString(),
        type: NotificationType.error,
      );
      debugPrint('Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(String id, String name) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('items')
          .doc(id)
          .delete();
      await NotificationServices.showNotification(
        title: 'Barang Dihapus',
        body: 'Barang $name berhasil dihapus.',
        type: NotificationType.success,
      );
    } catch (e) {
      await NotificationServices.showNotification(
        title: 'Gagal Menghapus Barang $name',
        body: e.toString(),
        type: NotificationType.error,
      );
      debugPrint('Error deleting item: $e');
      rethrow;
    }
  }
}