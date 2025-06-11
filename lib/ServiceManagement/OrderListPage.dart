import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusTabs(),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => OrderListItem(
                orderId: '#ORD${1000 + index}',
                status: index % 4 == 0 ? 'Pending' : 'Completed',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Filter Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Here you can add filter widgets like dropdowns or date pickers.'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Chip(label: Text('All')),
          Chip(label: Text('Pending')),
          Chip(label: Text('Completed')),
          Chip(label: Text('Cancelled')),
        ],
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final String orderId;
  final String status;

  const OrderListItem({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt),
      title: Text('Order $orderId'),
      subtitle: Text('Status: $status'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to order detail page (add OrderDetailPage if needed)
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(orderId: orderId)));
      },
    );
  }
}