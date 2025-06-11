import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final bool isEditing;

  const ProductEditPage({super.key, this.isEditing = false});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: 'Basic'),
            Tab(icon: Icon(Icons.photo_library), text: 'Media'),
            Tab(icon: Icon(Icons.monetization_on), text: 'Pricing'),
            Tab(icon: Icon(Icons.storage), text: 'Inventory'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Shipping'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildMediaTab(),
          _buildPricingTab(),
          _buildInventoryTab(),
          _buildShippingTab(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    return Center(
      child: Text('Media Upload Section'),
    );
  }

  Widget _buildPricingTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Discount'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Stock Quantity'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'SKU'),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Dimensions (LxWxH)'),
          ),
        ],
      ),
    );
  }
}
