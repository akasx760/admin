import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({Key? key}) : super(key: key);

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  int _nextProductId = 1;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'productName': 'Cotton T-Shirt',
      'categories': ['Apparel', 'Summer Wear'],
      'oldPrice': 25.99,
      'newPrice': 19.99,
      'description': 'Comfortable 100% cotton t-shirt perfect for summer days.',
      'features': ['100% Cotton', 'Machine Washable', 'Multiple Colors'],
      'stockQuantity': 100,
      'images': [], // Add initial empty images list
    },
    {
      'id': 2,
      'productName': 'Silk Scarf',
      'categories': ['Accessories', 'Luxury'],
      'oldPrice': 59.99,
      'newPrice': 49.99,
      'description': 'Elegant pure silk scarf with handmade patterns.',
      'features': ['Pure Silk', 'Handmade', 'Elegant Design'],
      'stockQuantity': 50,
      'images': [],
    },
    {
      'id': 3,
      'productName': 'Wool Sweater',
      'categories': ['Winter Wear', 'Knits'],
      'oldPrice': 79.99,
      'newPrice': 65.99,
      'description': 'Warm merino wool sweater for cold winter days.',
      'features': ['Merino Wool', 'Warm', 'Unisex'],
      'stockQuantity': 30,
      'images': [],
    },
  ];

  @override
  void initState() {
    super.initState();
    if (_products.isNotEmpty) {
      _nextProductId = _products.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final lowerSearch = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          product['productName'].toString().toLowerCase().contains(lowerSearch) ||
          product['description'].toString().toLowerCase().contains(lowerSearch) ||
          product['features']
              .map((f) => f.toString().toLowerCase())
              .any((feature) => feature.contains(lowerSearch));
      final matchesCategory = _selectedCategory == 'All' ||
          product['categories'].map((c) => c.toString()).contains(_selectedCategory);

      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> _addNewProduct() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoriesController = TextEditingController();
    final TextEditingController oldPriceController = TextEditingController();
    final TextEditingController newPriceController = TextEditingController();
    final TextEditingController featuresController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController stockQuantityController = TextEditingController();
    List<XFile>? imageFiles = [];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add New Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Product Name', 'Enter product name', autofocus: true),
                  const SizedBox(height: 8),
                  _buildTextField(categoriesController, 'Categories', 'Comma separated categories'),
                  const SizedBox(height: 8),
                  _buildTextField(oldPriceController, 'Old Price', 'Enter original price',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 8),
                  _buildTextField(newPriceController, 'New Price', 'Enter current price',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 8),
                  _buildTextField(stockQuantityController, 'Stock Quantity', 'Enter stock quantity',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  _buildTextField(descriptionController, 'Description', 'Enter product description',
                      maxLines: 4, minLines: 3),
                  const SizedBox(height: 8),
                  _buildTextField(featuresController, 'Features', 'Comma separated features',
                      maxLines: 3),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text('Select Images'),
                    onPressed: () async {
                      final pickedFiles = await _picker.pickMultiImage();
                      if (pickedFiles != null) {
                        setStateDialog(() {
                          imageFiles = pickedFiles;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (imageFiles != null && imageFiles!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: imageFiles!
                          .map((file) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(file.path),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product name is required')),
                    );
                    return;
                  }
                  setState(() {
                    _products.add({
                      'id': _nextProductId++,
                      'productName': nameController.text.trim(),
                      'categories': categoriesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      'oldPrice': double.tryParse(oldPriceController.text) ?? 0.0,
                      'newPrice': double.tryParse(newPriceController.text) ?? 0.0,
                      'description': descriptionController.text.trim(),
                      'features': featuresController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      'stockQuantity': int.tryParse(stockQuantityController.text) ?? 0,
                      'images': imageFiles!.map((file) => file.path).toList(),
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add Product'),
              ),
            ],
          );
        });
      },
    );
  }

  void _editProduct(int id) {
    final productIndex = _products.indexWhere((p) => p['id'] == id);
    if (productIndex == -1) return;

    final product = _products[productIndex];
    final TextEditingController nameController = TextEditingController(text: product['productName']);
    final TextEditingController categoriesController = TextEditingController(text: product['categories'].join(', '));
    final TextEditingController oldPriceController = TextEditingController(text: product['oldPrice'].toString());
    final TextEditingController newPriceController = TextEditingController(text: product['newPrice'].toString());
    final TextEditingController descriptionController = TextEditingController(text: product['description']);
    final TextEditingController featuresController = TextEditingController(text: product['features'].join(', '));
    final TextEditingController stockQuantityController =
        TextEditingController(text: product['stockQuantity'].toString());
    List<String> imagePaths = List<String>.from(product['images'] ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Edit Product #${product['id']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Product Name', null),
                  const SizedBox(height: 8),
                  _buildTextField(categoriesController, 'Categories (comma separated)', null),
                  const SizedBox(height: 8),
                  _buildTextField(oldPriceController, 'Old Price', null,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 8),
                  _buildTextField(newPriceController, 'New Price', null,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 8),
                  _buildTextField(stockQuantityController, 'Stock Quantity', null,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  _buildTextField(descriptionController, 'Description', null, maxLines: 4, minLines: 3),
                  const SizedBox(height: 8),
                  _buildTextField(featuresController, 'Features (comma separated)', null, maxLines: 3),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text('Select Images'),
                    onPressed: () async {
                      final pickedFiles = await _picker.pickMultiImage();
                      if (pickedFiles != null) {
                        setStateDialog(() {
                          imagePaths = pickedFiles.map((file) => file.path).toList();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (imagePaths.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: imagePaths
                          .map((path) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(path),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _products[productIndex] = {
                      'id': id,
                      'productName': nameController.text.trim(),
                      'categories': categoriesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      'oldPrice': double.tryParse(oldPriceController.text) ?? 0.0,
                      'newPrice': double.tryParse(newPriceController.text) ?? 0.0,
                      'description': descriptionController.text.trim(),
                      'features': featuresController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      'stockQuantity': int.tryParse(stockQuantityController.text) ?? 0,
                      'images': imagePaths,
                    };
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String? hintText,
      {TextInputType? keyboardType, bool autofocus = false, int? maxLines, int? minLines}) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          'Product Management',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildFilterControls(),
              const SizedBox(height: 20),
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          'No products found.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Scrollbar(
                        controller: _verticalScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _verticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                                columnSpacing: 20,
                                dataRowHeight: 80,
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Product Name')),
                                  DataColumn(label: Text('Categories')),
                                  DataColumn(label: Text('Old Price'), numeric: true),
                                  DataColumn(label: Text('New Price'), numeric: true),
                                  DataColumn(label: Text('Stock Quantity'), numeric: true),
                                  DataColumn(label: Text('Description')),
                                  DataColumn(label: Text('Features')),
                                  DataColumn(label: Text('Images')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: filteredProducts.map((product) {
                                  final images = product['images'] as List<dynamic>? ?? [];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(product['id'].toString())),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 200),
                                          child: Text(
                                            product['productName'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 200),
                                          child: Text(
                                            product['categories'].join(', '),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text('\$${product['oldPrice'].toStringAsFixed(2)}')),
                                      DataCell(Text('\$${product['newPrice'].toStringAsFixed(2)}')),
                                      DataCell(Text(product['stockQuantity'].toString())),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 250),
                                          child: Text(
                                            product['description'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 250),
                                          child: Text(
                                            product['features'].join(', '),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          height: 70,
                                          width: 150,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: images.map((imgPath) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(6),
                                                  child: Image.file(
                                                    File(imgPath.toString()),
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 20),
                                              color: Colors.deepPurple,
                                              onPressed: () => _editProduct(product['id']),
                                              tooltip: 'Edit',
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 20),
                                              color: Colors.red,
                                              onPressed: () => _deleteProduct(product['id']),
                                              tooltip: 'Delete',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        tooltip: 'Add New Product',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        elevation: 6,
      ),
    );
  }

  void _deleteProduct(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p['id'] == id);
                // Update IDs to be sequential after deletion
                for (int i = 0; i < _products.length; i++) {
                  _products[i]['id'] = i + 1;
                }
                _nextProductId = _products.length + 1;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product #$id deleted'),
                  backgroundColor: Colors.red[400],
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    final categories = [
      'All',
      'Apparel',
      'Accessories',
      'Summer Wear',
      'Winter Wear',
      'Luxury',
      'Knits'
    ];

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            borderRadius: BorderRadius.circular(12),
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            items: categories
                .map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
