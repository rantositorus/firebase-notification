import 'package:flutter/material.dart';
import 'package:firebase_notification/model/item.dart';
import 'package:firebase_notification/services/item_service.dart';
import 'package:firebase_notification/widgets/custom_textfield.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  const ItemFormScreen({super.key, this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _quantityController.text = widget.item!.quantity.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final item = Item(
        id: widget.item?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
      );

      if (widget.item == null) {
        await ItemService().addItem(item);
      } else {
        await ItemService().updateItem(item);
      }

      Navigator.pop(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Tambah Barang' : 'Edit Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nama Barang',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _quantityController,
                label: 'Jumlah',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(widget.item == null ? 'Tambah' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}