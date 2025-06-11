import 'package:flutter/material.dart';
class StockAlertsPage extends StatelessWidget {
  const StockAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Low Stock Alerts')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: Text('Product ${index + 1}'),
            subtitle: Text('Only ${index + 2} items left'),
          ),
        ),
      ),
    );
  }
}