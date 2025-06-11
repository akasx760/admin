import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  void _showFilters() {
    // You can implement actual filter logic or open a bottom sheet
    print("Filter icon tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Orders',
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickFilters(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => OrderListItem(
                orderNumber: '#${1000 + index}',
                status: index % 3 == 0
                    ? 'Pending'
                    : index % 3 == 1
                        ? 'Shipped'
                        : 'Delivered',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(label: const Text('All'), onSelected: (_) {}),
            const SizedBox(width: 8),
            FilterChip(label: const Text('Pending'), onSelected: (_) {}),
            const SizedBox(width: 8),
            FilterChip(label: const Text('Shipped'), onSelected: (_) {}),
            const SizedBox(width: 8),
            FilterChip(label: const Text('Delivered'), onSelected: (_) {}),
          ],
        ),
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final String orderNumber;
  final String status;

  const OrderListItem({
    super.key,
    required this.orderNumber,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(status),
          child: Text(orderNumber.substring(1)), // Show only number
        ),
        title: Text('Customer Name'),
        subtitle: Text('2 items • ₹999.00 • $status'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to detailed order view
        },
      ),
    );
  }
}
