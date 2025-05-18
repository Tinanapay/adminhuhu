import 'package:flutter/material.dart';
import '../controllers/item_controller.dart';
import '../models/item.dart';
import '../widgets/item_form.dart';
import '../widgets/item_list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ItemController controller = ItemController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  bool isLibrary = true;
  int? editingIndex;
  String? currentDocId; // For tracking which Firestore doc to update

  void _submit() {
    final name = nameController.text.trim();
    final desc = descController.text.trim();

    if (name.isEmpty) return;

    final newItem = Item(name: name, description: desc);

    if (editingIndex == null) {
      controller.addItem(isLibrary, newItem);
    } else {
      controller.updateItem(isLibrary, currentDocId!, newItem);
      editingIndex = null;
      currentDocId = null;
    }

    nameController.clear();
    descController.clear();
  }

  void _edit(int index, String docId, Item item) {
    nameController.text = item.name;
    descController.text = item.description;

    setState(() {
      editingIndex = index;
      currentDocId = docId;
    });
  }

  void _delete(String docId) {
    controller.deleteItem(isLibrary, docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN PANEL'),
        titleTextStyle: TextStyle(
          color: isLibrary ? const Color.fromARGB(255, 235, 141, 1)
              : const Color.fromARGB(255, 253, 141, 1),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ), 
        backgroundColor: const Color.fromARGB(255, 0, 73, 83),
        actions: [
          TextButton(
            onPressed: () => setState(() => isLibrary = true),
            child: Text(
            'LIBRARY',
              style: TextStyle(color: isLibrary ?  const Color.fromARGB(255, 235, 141, 1): const Color.fromARGB(255, 2, 245, 215)),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => isLibrary = false),
            child: Text(
              'CATALOG',
              style: TextStyle(color: isLibrary ? const Color.fromARGB(255, 4, 235, 215) : const Color.fromARGB(255, 235, 141, 1)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ItemForm(
              nameController: nameController,
              descController: descController,
              onSubmit: _submit,
              isEditing: editingIndex != null,
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.getItems(isLibrary),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No items found.'));
                  }

                  final data = snapshot.data!;
                  final items = data.map((e) => e['item'] as Item).toList();

                  return ItemList(
                    items: items,
                    onEdit: (index) {
                      final docId = data[index]['id'];
                      final item = data[index]['item'] as Item;
                      _edit(index, docId, item);
                    },
                    onDelete: (index) {
                      final docId = data[index]['id'];
                      _delete(docId);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
