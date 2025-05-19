class Item {
  final String? id;
  final String name;
  final String description;
  final int quantity;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
    );
  }

}