import 'package:flutter/material.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime joinDate;
  final int orderCount;
  final double totalSpent;
  final String status;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    this.orderCount = 0,
    this.totalSpent = 0,
    this.status = 'Active',
  });
  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? status,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      joinDate: joinDate,
      orderCount: orderCount,
      totalSpent: totalSpent,
      status: status ?? this.status,
    );
  }
}

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final List<Customer> _customers = List.generate(
    15,
    (index) => Customer(
      id: 'CUST-${1000 + index}',
      name: 'Customer ${index + 1}',
      email: 'customer${index + 1}@example.com',
      phone: '+1 (555) ${1000 + index}',
      joinDate: DateTime.now().subtract(Duration(days: index * 7)),
      orderCount: 5 + index,
      totalSpent: 100.0 + (index * 50.0),
      status: index % 4 == 0 ? 'Inactive' : 'Active',
    ),
  );

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<Customer> get _filteredCustomers {
    var results = _customers;
    
    if (_searchQuery.isNotEmpty) {
      results = results.where((customer) =>
          customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.phone.contains(_searchQuery)).toList();
    }
    
    if (_filterStatus != 'All') {
      results = results.where((customer) => customer.status == _filterStatus).toList();
    }
    
    return results;
  }

  void _showCustomerDetails(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID:', customer.id),
              _buildDetailRow('Email:', customer.email),
              _buildDetailRow('Phone:', customer.phone),
              _buildDetailRow('Join Date:', 
                  '${customer.joinDate.day}/${customer.joinDate.month}/${customer.joinDate.year}'),
              _buildDetailRow('Orders:', customer.orderCount.toString()),
              _buildDetailRow('Total Spent:', '\$${customer.totalSpent.toStringAsFixed(2)}'),
              _buildDetailRow('Status:', customer.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditCustomerDialog(Customer customer) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: customer.name);
    final _emailController = TextEditingController(text: customer.email);
    final _phoneController = TextEditingController(text: customer.phone);
    String _status = customer.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Customer'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                DropdownButtonFormField(
                  value: _status,
                  items: ['Active', 'Inactive'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) => _status = value!,
                  decoration: const InputDecoration(labelText: 'Status'),
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
        int index = _customers.indexOf(customer);
        _customers[index] = customer.copyWith(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          status: _status,
        );
      });
      Navigator.of(context).pop();
    }
  },
  child: const Text('Save'),
)

        ],
      ),
    );
  }

  void _showDeleteConfirmation(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Delete customer "${customer.name}"?'),
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
                _customers.remove(customer);
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
        title: const Text('Customer Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CustomerSearchDelegate(customers: _customers),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search customers',
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
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: ['All', 'Active', 'Inactive'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Orders'), numeric: true),
                  DataColumn(label: Text('Total'), numeric: true),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredCustomers.map((customer) {
                  return DataRow(
                    cells: [
                      DataCell(Text(customer.id)),
                      DataCell(
                        Text(customer.name),
                        onTap: () => _showCustomerDetails(context, customer),
                      ),
                      DataCell(Text(customer.email)),
                      DataCell(Text(customer.phone)),
                      DataCell(Text(customer.orderCount.toString())),
                      DataCell(Text('\$${customer.totalSpent.toStringAsFixed(2)}')),
                      DataCell(
                        Chip(
                          label: Text(customer.status),
                          backgroundColor: customer.status == 'Active'
                              ? Colors.green[100]
                              : Colors.red[100],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                              onPressed: () => _showEditCustomerDialog(customer),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(customer),
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

class _CustomerSearchDelegate extends SearchDelegate<Customer> {
  final List<Customer> customers;

  _CustomerSearchDelegate({required this.customers});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, customers.first),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = customers.where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()) ||
        customer.email.toLowerCase().contains(query.toLowerCase()) ||
        customer.phone.contains(query)).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          leading: CircleAvatar(child: Text(customer.name[0])),
          title: Text(customer.name),
          subtitle: Text(customer.email),
          trailing: Text('\$${customer.totalSpent.toStringAsFixed(2)}'),
          onTap: () => close(context, customer),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = customers.where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()) ||
        customer.email.toLowerCase().contains(query.toLowerCase()) ||
        customer.phone.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final customer = suggestions[index];
        return ListTile(
          leading: CircleAvatar(child: Text(customer.name[0])),
          title: Text(customer.name),
          subtitle: Text(customer.email),
          onTap: () => close(context, customer),
        );
      },
    );
  }
}