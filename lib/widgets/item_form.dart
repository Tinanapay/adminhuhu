import 'package:flutter/material.dart';


class ItemForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final VoidCallback onSubmit;
  final bool isEditing;

  const ItemForm({
    super.key,
    required this.nameController,
    required this.descController,
    required this.onSubmit,
    required this.isEditing,
  });
@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(isEditing ? 'Update' : 'Add'),
          )
        ],
      ),
    ],
  );
}
}