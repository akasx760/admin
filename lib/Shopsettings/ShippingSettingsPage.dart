import 'package:flutter/material.dart';

class ShippingPartner {
  int id;
  String name;
  String contactPerson;
  String phone;
  String address;

  ShippingPartner({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.address,
  });
}

class ShippingSettingsPage extends StatefulWidget {
  const ShippingSettingsPage({Key? key}) : super(key: key);

  @override
  State<ShippingSettingsPage> createState() => _ShippingSettingsPageState();
}

class _ShippingSettingsPageState extends State<ShippingSettingsPage> {
  List<ShippingPartner> _shippingPartners = [
    ShippingPartner(id: 1, name: 'FedEx', contactPerson: 'John Doe', phone: '123-456-7890', address: '123 FedEx St.'),
    ShippingPartner(id: 2, name: 'DHL', contactPerson: 'Jane Smith', phone: '987-654-3210', address: '456 DHL Ave.'),
    ShippingPartner(id: 3, name: 'UPS', contactPerson: 'Bob Johnson', phone: '555-123-4567', address: '789 UPS Blvd.'),
  ];

  int _rowsPerPage = 5;
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  ShippingPartner? _editingPartner;

  void _resetForm() {
    _editingPartner = null;
    _nameController.clear();
    _contactPersonController.clear();
    _phoneController.clear();
    _addressController.clear();
  }

  void _updateIds() {
    for (int i = 0; i < _shippingPartners.length; i++) {
      _shippingPartners[i].id = i + 1;
    }
  }

  void _showAddEditDialog({ShippingPartner? partner}) {
    final bool isEditing = partner != null;
    if (isEditing) {
      _editingPartner = partner;
      _nameController.text = partner.name;
      _contactPersonController.text = partner.contactPerson;
      _phoneController.text = partner.phone;
      _addressController.text = partner.address;
    } else {
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Partner' : 'Add Partner'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contactPersonController,
                  decoration: const InputDecoration(labelText: 'Contact Person'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetForm();
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (isEditing) {
                    partner!.name = _nameController.text.trim();
                    partner.contactPerson = _contactPersonController.text.trim();
                    partner.phone = _phoneController.text.trim();
                    partner.address = _addressController.text.trim();
                  } else {
                    _shippingPartners.add(
                      ShippingPartner(
                        id: _shippingPartners.length + 1,
                        name: _nameController.text.trim(),
                        contactPerson: _contactPersonController.text.trim(),
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                      ),
                    );
                  }
                });
                _resetForm();
                Navigator.pop(ctx);
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deletePartner(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure to delete this shipping partner?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _shippingPartners.removeWhere((e) => e.id == id);
                _updateIds();
                _currentPage = _currentPage.clamp(
                  0,
                  ((_shippingPartners.length - 1) / _rowsPerPage).floor(),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex = (_currentPage + 1) * _rowsPerPage;
    final visiblePartners = _shippingPartners.sublist(
      startIndex,
      endIndex > _shippingPartners.length ? _shippingPartners.length : endIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _shippingPartners.isEmpty
                  ? const Center(child: Text("No shipping partners found."))
                  : Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Contact Person')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Address')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Delete')),
                          ],
                          rows: visiblePartners.map((partner) {
                            return DataRow(cells: [
                              DataCell(Text(partner.id.toString())),
                              DataCell(Text(partner.name)),
                              DataCell(Text(partner.contactPerson)),
                              DataCell(Text(partner.phone)),
                              DataCell(Text(partner.address)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                  onPressed: () => _showAddEditDialog(partner: partner),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePartner(partner.id),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            if (_shippingPartners.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text("Page ${_currentPage + 1} of ${(_shippingPartners.length / _rowsPerPage).ceil()}"),
                  IconButton(
                    onPressed: endIndex < _shippingPartners.length
                        ? () => setState(() => _currentPage++)
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
