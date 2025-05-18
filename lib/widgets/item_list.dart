import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemList extends StatelessWidget {
  final List<Item> items;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const ItemList({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: const Color.fromARGB(255, 2, 72, 85)),
                    onPressed: () => onEdit(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: const Color.fromARGB(255, 253, 0, 0)),
                    onPressed: () => onDelete(index),
                  ),
                ],
              ),
            ),
          );
        },
      );
    
  }
}
