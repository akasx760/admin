import 'package:flutter/material.dart';

class SizeSettingsPage extends StatefulWidget {
  const SizeSettingsPage({super.key});

  @override
  State<SizeSettingsPage> createState() => _SizeSettingsPageState();
}

class _SizeSettingsPageState extends State<SizeSettingsPage> {
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _dressCategories = [
    'Shirt', 'T-Shirt', 'Pants', 'Kurti', 'Saree',
    'Blouse', 'Jeans', 'Churidar', 'Skirt', 'Jacket',
  ];

  final List<Map<String, dynamic>> _products = [];
  int _productIdCounter = 1;

  int _rowsPerPage = 5;
  int _currentPage = 0;

  String? _selectedCategory;
  final TextEditingController _productNameController = TextEditingController();
  List<String> _selectedSizes = [];

  void _resetForm() {
    _selectedCategory = null;
    _productNameController.clear();
    _selectedSizes = [];
  }

  void _showAddEditDialog({Map<String, dynamic>? product}) {
    final bool isEditing = product != null;

    if (isEditing) {
      _selectedCategory = product['category'];
      _productNameController.text = product['name'];
      _selectedSizes = List<String>.from(product['sizes']);
    } else {
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(isEditing ? 'Edit Product' : 'Add Product'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    value: _selectedCategory,
                    items: _dressCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Select Sizes:'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSizes.map((size) {
                      final isSelected = _selectedSizes.contains(size);
                      return FilterChip(
                        label: Text(size),
                        selected: isSelected,
                        onSelected: (selected) {
                          setDialogState(() {
                            if (selected) {
                              _selectedSizes.add(size);
                            } else {
                              _selectedSizes.remove(size);
                            }
                          });
                        },
                        selectedColor: Colors.deepPurple.shade100,
                        checkmarkColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.deepPurple : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _resetForm();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  if (_selectedCategory != null &&
                      _productNameController.text.isNotEmpty &&
                      _selectedSizes.isNotEmpty) {
                    setState(() {
                      if (isEditing) {
                        product!['category'] = _selectedCategory!;
                        product['name'] = _productNameController.text;
                        product['sizes'] = List<String>.from(_selectedSizes);
                      } else {
                        _products.add({
                          'id': _productIdCounter++,
                          'category': _selectedCategory!,
                          'name': _productNameController.text,
                          'sizes': List<String>.from(_selectedSizes),
                        });
                      }
                    });
                    Navigator.pop(ctx);
                    _resetForm();
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct(int id) {
    setState(() {
      _products.removeWhere((product) => product['id'] == id);
      for (int i = 0; i < _products.length; i++) {
        _products[i]['id'] = i + 1;
      }
      _productIdCounter = _products.length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex = (_currentPage + 1) * _rowsPerPage;
    final List<Map<String, dynamic>> visibleProducts =
        _products.sublist(startIndex, endIndex > _products.length ? _products.length : endIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Size Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _products.isEmpty
                      ? const Center(child: Text('No products added yet.'))
                      : Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 500),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columnSpacing: 16,
                                  dataRowMinHeight: 48,
                                  dataRowMaxHeight: 56,
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade50),
                                  dataRowColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.hovered)) {
                                        return Colors.deepPurple.withOpacity(0.1);
                                      }
                                      return null;
                                    },
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Category')),
                                    DataColumn(label: Text('Product Name')),
                                    DataColumn(label: Text('Sizes')),
                                    DataColumn(label: Text('Edit')),
                                    DataColumn(label: Text('Delete')),
                                  ],
                                  rows: visibleProducts.map((product) {
                                    return DataRow(cells: [
                                      DataCell(Text(product['id'].toString())),
                                      DataCell(Text(product['category'])),
                                      DataCell(
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            product['name'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(
                                          (product['sizes'] as List<String>).join(', '))),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.deepPurple),
                                          onPressed: () =>
                                              _showAddEditDialog(product: product),
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon:
                                              const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () =>
                                              _deleteProduct(product['id']),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_products.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('Page ${_currentPage + 1}'),
                  IconButton(
                    onPressed: endIndex < _products.length
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}