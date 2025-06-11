import 'package:flutter/material.dart';

class Category {
  int id;
  String name;

  Category({required this.id, required this.name});
}

class CategorySettingsPage extends StatefulWidget {
  const CategorySettingsPage({Key? key}) : super(key: key);

  @override
  _CategorySettingsPageState createState() => _CategorySettingsPageState();
}

class _CategorySettingsPageState extends State<CategorySettingsPage> {
  final List<Category> _categories = [
    Category(id: 1, name: 'Electronics'),
    Category(id: 2, name: 'Clothing'),
    Category(id: 3, name: 'Books'),
    Category(id: 4, name: 'Furniture'),
    Category(id: 5, name: 'Toys'),
    Category(id: 6, name: 'Sports'),
    Category(id: 7, name: 'Groceries'),
    Category(id: 8, name: 'Beauty'),
    Category(id: 9, name: 'Automotive'),
    Category(id: 10, name: 'Garden'),
    Category(id: 11, name: 'Jewelry'),
    Category(id: 12, name: 'Music'),
  ];

  int? _editingIndex;
  final TextEditingController _categoryController = TextEditingController();

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  // Pagination variables
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void dispose() {
    _categoryController.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _reassignCategoryIds() {
    for (int i = 0; i < _categories.length; i++) {
      _categories[i].id = i + 1;
    }
  }

  void _openAddEditDialog({int? editIndex}) {
    if (editIndex != null) {
      _editingIndex = editIndex;
      _categoryController.text = _categories[editIndex].name;
    } else {
      _editingIndex = null;
      _categoryController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  editIndex == null ? 'Add Category' : 'Edit Category',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_categoryController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Category name cannot be empty')),
                        );
                        return;
                      }

                      setState(() {
                        if (_editingIndex != null) {
                          // Update category
                          _categories[_editingIndex!] = Category(
                            id: _categories[_editingIndex!].id,
                            name: _categoryController.text.trim(),
                          );
                        } else {
                          // Add new category with next ID
                          _categories.add(Category(
                            id: _categories.length + 1,
                            name: _categoryController.text.trim(),
                          ));
                        }

                        _reassignCategoryIds();
                        _editingIndex = null;
                        _categoryController.clear();

                        // After add/update, reset to first page to show new changes properly
                        _currentPage = 0;
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      _editingIndex == null ? 'Add Category' : 'Update Category',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeAt(index);
                _reassignCategoryIds();

                if (_editingIndex != null) {
                  if (_editingIndex == index) {
                    _editingIndex = null;
                    _categoryController.clear();
                  } else if (_editingIndex! > index) {
                    _editingIndex = _editingIndex! - 1;
                  }
                }

                // Adjust current page if needed
                final numPages = (_categories.length / _rowsPerPage).ceil();
                if (_currentPage >= numPages && _currentPage > 0) {
                  _currentPage = numPages - 1;
                }
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Calculate start and end index for the current page
    final int startIndex = _currentPage * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > _categories.length) {
      endIndex = _categories.length;
    }
    final List<Category> pageItems = _categories.sublist(startIndex, endIndex);

    return DataTable(
      columnSpacing: 20,
      headingRowColor: MaterialStateProperty.all(Colors.deepPurple[100]),
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
      columns: const [
        DataColumn(
          label: Text('ID'),
          numeric: true,
        ),
        DataColumn(
          label: Text('Category Name'),
        ),
        DataColumn(
          label: Text('Actions'),
        ),
      ],
      rows: List<DataRow>.generate(
        pageItems.length,
        (index) {
          final category = pageItems[index];
          // original index in _categories list for editing/deleting
          final originalIndex = startIndex + index;
          return DataRow(
            cells: [
              DataCell(Text(category.id.toString())),
              DataCell(Text(category.name)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      tooltip: 'Edit',
                      onPressed: () => _openAddEditDialog(editIndex: originalIndex),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _deleteCategory(originalIndex),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaginationControls() {
    final int numPages = (_categories.length / _rowsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Page ${_currentPage + 1} of $numPages'),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 0
                ? () {
                    setState(() {
                      _currentPage--;
                      // Scroll to top on page change
                      _verticalScrollController.jumpTo(0);
                    });
                  }
                : null,
            tooltip: 'Previous Page',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: (_currentPage < numPages - 1)
                ? () {
                    setState(() {
                      _currentPage++;
                      _verticalScrollController.jumpTo(0);
                    });
                  }
                : null,
            tooltip: 'Next Page',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Settings'),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _openAddEditDialog(),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories added yet.\nTap + to add new.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
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
                              child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                                child: _buildDataTable(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildPaginationControls(),
                  ],
                ),
        ),
      ),
    );
  }
}

