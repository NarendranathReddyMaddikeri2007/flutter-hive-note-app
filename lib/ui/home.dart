import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePagetState();
  }
}

class _HomePagetState extends State<HomePage> {
  //Reference of Hive Box
  final _noteApp = Hive.box('note_app');

  List<Map<String, dynamic>> _items = [];

  //For TextField
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createItem(Map<String, dynamic> list) async {
    await _noteApp.add(list);
    _refreshItems();
  }

  @override
  void initState() {
    _refreshItems();
    super.initState();
  }

  void _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _noteApp.put(itemKey, item);
    _refreshItems();
  }

  void _refreshItems() {
    final data = _noteApp.keys.map((key) {
      final item = _noteApp.get(key);
      return {
        "key": key,
        "title": item['title'],
        'description': item['description']
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> _deleteItem(int itemKey) async {
    await _noteApp.delete(itemKey);
    _refreshItems();
  }

  void _showForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _titleController.text = existingItem['title'];
      _descriptionController.text = existingItem['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 8,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                      controller: _titleController,
                      decoration:
                          const InputDecoration(hintText: 'Enter Title',
                          labelText: 'Title', border: OutlineInputBorder(),)),
                          SizedBox(height: 10,),
                  TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Enter Description', border: OutlineInputBorder(), labelText: 'Decoration')),
                  const SizedBox(height: 10),
                  OutlinedButton(
                      onPressed: () async {
                        if (itemKey == null) {
                          _createItem({
                            "title": _titleController.text,
                            "description": _descriptionController.text
                          });
                        }

                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "title": _titleController.text.trim(),
                            "description": _descriptionController.text.trim()
                          });
                        }

                        _titleController.clear();
                        _descriptionController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Submit')),
                      SizedBox(height: 10)
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Hive App',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showForm(context, null);
          },
          label: const Text('Add', style: TextStyle(color: Colors.white),),
          
          icon: const Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.teal),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final currentItem = _items[index];
            return Card(
              color: Colors.orange.shade100,
              margin: const EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                title: Text(currentItem['title']),
                subtitle: Text(currentItem['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          _showForm(context, currentItem['key']);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _deleteItem(currentItem['key']);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
