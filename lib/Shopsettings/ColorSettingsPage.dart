import 'package:flutter/material.dart';

class ColorSettingsPage extends StatefulWidget {
  const ColorSettingsPage({Key? key}) : super(key: key);

  @override
  _ColorSettingsPageState createState() => _ColorSettingsPageState();
}

class _ColorSettingsPageState extends State<ColorSettingsPage> {
  final List<String> _availableColors = ['Red', 'Green', 'Blue'];
  final TextEditingController _colorController = TextEditingController();
  int? _editingIndex;

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  void _addOrUpdateColor() {
    if (_colorController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          _availableColors[_editingIndex!] = _colorController.text;
          _editingIndex = null; // Reset editing index
        } else {
          _availableColors.add(_colorController.text);
        }
        _colorController.clear();
      });
    }
  }

  void _editColor(int index) {
    setState(() {
      _editingIndex = index;
      _colorController.text = _availableColors[index];
    });
  }

  void _deleteColor(int index) {
    setState(() {
      _availableColors.removeAt(index);
      // If currently editing this index, cancel editing on delete
      if (_editingIndex != null && _editingIndex == index) {
        _editingIndex = null;
        _colorController.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        // Adjust editing index due to remove shift
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Colors:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Color')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _availableColors.asMap().entries.map((entry) {
                int index = entry.key;
                String color = entry.value;
                return DataRow(cells: [
                  DataCell(Text('${index + 1}')), // ID starting at 1
                  DataCell(Text(color)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editColor(index),
                        tooltip: 'Edit',
                        color: Colors.deepPurple,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteColor(index),
                        tooltip: 'Delete',
                        color: Colors.red,
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(
                labelText:
                    _editingIndex == null ? 'Add New Color' : 'Edit Color',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: _editingIndex != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _editingIndex = null;
                            _colorController.clear();
                          });
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _addOrUpdateColor,
              child: Text(
                _editingIndex == null ? 'Add Color' : 'Update Color',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
