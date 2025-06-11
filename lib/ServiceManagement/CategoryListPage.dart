import 'package:flutter/material.dart';

class Category {
  final String id;
  String name;
  String description;
  DateTime createdAt;
  bool isActive;

  Category({
    required this.id,
    required this.name,
    this.description = '',
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();
}

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final List<Category> _categories = List.generate(
    10,
    (index) => Category(
      id: 'CAT-${index + 1000}',
      name: 'Category ${index + 1}',
      description: 'Description for category ${index + 1}',
    ),
  );

  final _searchController = TextEditingController();
  String _searchQuery = '';

  List<Category> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories.where((category) =>
        category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        category.id.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _showAddEditCategoryDialog({Category? category}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: category?.name ?? '');
    final _descController = TextEditingController(text: category?.description ?? '');
    bool _isActive = category?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (category == null) {
                    // Add new category
                    _categories.add(Category(
                      id: 'CAT-${DateTime.now().millisecondsSinceEpoch}',
                      name: _nameController.text,
                      description: _descController.text,
                      isActive: _isActive,
                    ));
                  } else {
                    // Update existing category
                    category.name = _nameController.text;
                    category.description = _descController.text;
                    category.isActive = _isActive;
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(category == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Delete category "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _categories.remove(category);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(),
            tooltip: 'Add new category',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search categories',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Created At')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredCategories.map((category) {
                  return DataRow(
                    cells: [
                      DataCell(Text(category.id)),
                      DataCell(Text(category.name)),
                      DataCell(
                        Tooltip(
                          message: category.description,
                          child: Text(
                            category.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(category.isActive ? 'Active' : 'Inactive'),
                          backgroundColor:
                              category.isActive ? Colors.green[100] : Colors.red[100],
                        ),
                      ),
                      DataCell(Text(
                          '${category.createdAt.day}/${category.createdAt.month}/${category.createdAt.year}')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showAddEditCategoryDialog(category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(category),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}