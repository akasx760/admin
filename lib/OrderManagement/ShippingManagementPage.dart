import 'package:flutter/material.dart';

class ShippingManagementPage extends StatelessWidget {
  const ShippingManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Management'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildShippingCard(context, 'FedEx', '2 orders pending'),
          _buildShippingCard(context, 'DHL', '5 orders in transit'),
          _buildShippingCard(context, 'BlueDart', '1 delivery delayed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add shipping partner logic
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Add Shipping Partner',
      ),
    );
  }

  Widget _buildShippingCard(BuildContext context, String carrier, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.local_shipping, color: Colors.deepPurple),
        title: Text(carrier),
        subtitle: Text(status),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to detailed partner management page if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('View details for $carrier')),
          );
        },
      ),
    );
  }
}
