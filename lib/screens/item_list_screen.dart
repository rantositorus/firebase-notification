import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_notification/model/item.dart';
import 'package:firebase_notification/services/auth_service.dart';
import 'package:firebase_notification/services/item_service.dart';
import 'package:firebase_notification/screens/item_form_screen.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final itemService = ItemService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/auth');
              }
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ItemFormScreen(),
          ),
        ),
      ),
      body: StreamBuilder<List<Item>>(
        stream: itemService.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Tidak ada barang'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.quantity} pcs'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemFormScreen(item: item),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(context, item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteItem(BuildContext context, Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barang'),
        content: Text('Yakin ingin menghapus ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ItemService().deleteItem(item.id!, item.name);
      } catch (e) {
        // Error notification will be handled by ItemService
      }
    }
  }
}