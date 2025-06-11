import 'package:flutter/material.dart';

class StatusUpdateDialog extends StatefulWidget {
  const StatusUpdateDialog({super.key});

  @override
  State<StatusUpdateDialog> createState() => _StatusUpdateDialogState();
}

class _StatusUpdateDialogState extends State<StatusUpdateDialog> {
  String _selectedStatus = 'Pending';
  final _trackingController = TextEditingController();

  void _confirmUpdate() {
    String trackingNumber = _trackingController.text.trim();

    // Example logic: You can modify this to update backend or state
    if (_selectedStatus == 'Shipped' && trackingNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tracking number')),
      );
      return;
    }

    // Return status and tracking number to parent if needed
    Navigator.pop(context, {
      'status': _selectedStatus,
      'trackingNumber': trackingNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Order Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
              DropdownMenuItem(value: 'Shipped', child: Text('Shipped')),
              DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
            ],
            onChanged: (value) => setState(() => _selectedStatus = value!),
          ),
          if (_selectedStatus == 'Shipped')
            TextField(
              controller: _trackingController,
              decoration: const InputDecoration(labelText: 'Tracking Number'),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _confirmUpdate,
          child: const Text('Update Status'),
        ),
      ],
    );
  }
}
