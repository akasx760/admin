import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ShopManagementApp());
}

class ShopManagementApp extends StatelessWidget {
  const ShopManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const ShopSettingsPage(),
    );
  }
}

class ShopSettingsPage extends StatefulWidget {
  const ShopSettingsPage({super.key});

  @override
  State<ShopSettingsPage> createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  // Shop Profile Management
  final TextEditingController _shopNameController = TextEditingController(text: 'My Fashion Store');
  final TextEditingController _shopDescriptionController = TextEditingController(text: 'Premium fashion for everyone');
  final TextEditingController _shopPhoneController = TextEditingController(text: '+1 (555) 123-4567');
  final TextEditingController _shopEmailController = TextEditingController(text: 'contact@myfashionstore.com');

  // Shop Location Management
  final List<Map<String, dynamic>> _shopLocations = [
    {
      'id': '1',
      'name': 'Main Store',
      'address': '123 Fashion St, New York, NY 10001',
      'latitude': 40.7128,
      'longitude': -74.0060,
      'isPrimary': true,
    },
    {
      'id': '2',
      'name': 'Downtown Branch',
      'address': '456 Style Ave, Brooklyn, NY 11201',
      'latitude': 40.6928,
      'longitude': -73.9903,
      'isPrimary': false,
    },
  ];
  final TextEditingController _newLocationNameController = TextEditingController();
  final TextEditingController _newLocationAddressController = TextEditingController();

  // Business Hours
  final Map<String, Map<String, TimeOfDay>> _businessHours = {
    'Monday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 18, minute: 0)},
    'Tuesday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 18, minute: 0)},
    'Wednesday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 18, minute: 0)},
    'Thursday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 18, minute: 0)},
    'Friday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 20, minute: 0)},
    'Saturday': {'open': const TimeOfDay(hour: 10, minute: 0), 'close': const TimeOfDay(hour: 20, minute: 0)},
    'Sunday': {'open': const TimeOfDay(hour: 11, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
  };

  // Payment Methods
  final Map<String, bool> _paymentMethods = {
    'Credit Card': true,
    'PayPal': true,
    'Apple Pay': false,
    'Google Pay': false,
    'Bank Transfer': true,
    'Cash on Delivery': true,
  };

  // Size Management
  final List<String> _availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _selectedSizes = ['S', 'M', 'L'];
  final TextEditingController _newSizeController = TextEditingController();

  // Color Management
  final List<String> _availableColors = [
    'Red',
    'Blue',
    'Green',
    'Black',
    'White',
    'Yellow',
    'Purple'
  ];
  final List<String> _selectedColors = ['Red', 'Blue', 'Black'];
  final TextEditingController _newColorController = TextEditingController();

  // Shipping Partners
  final List<String> _shippingPartners = [
    'FedEx',
    'UPS',
    'DHL',
    'USPS',
    'Blue Dart',
    'Delhivery'
  ];
  String _selectedShippingPartner = 'FedEx';

  // Categories
  final List<String> _categories = [
    'Dresses',
    'Tops',
    'Bottoms',
    'Outerwear',
    'Accessories'
  ];
  final List<String> _selectedCategories = ['Dresses', 'Tops'];
  final TextEditingController _newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Shop Profile Management
            _buildSettingsCard(
              title: 'Shop Profile',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _shopNameController,
                    decoration: const InputDecoration(
                      labelText: 'Shop Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _shopDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Shop Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _shopPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _shopEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),

            // 2. Shop Location Management
            _buildSettingsCard(
              title: 'Shop Locations',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Locations:'),
                  const SizedBox(height: 8),
                  ..._shopLocations.map((location) => ListTile(
                    title: Text(location['name']),
                    subtitle: Text(location['address']),
                    trailing: location['isPrimary'] 
                        ? const Chip(label: Text('Primary'), backgroundColor: Colors.green)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.star_border),
                                onPressed: () => _setAsPrimaryLocation(location['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeLocation(location['id']),
                              ),
                            ],
                          ),
                  )).toList(),
                  const SizedBox(height: 16),
                  const Text('Add New Location:'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newLocationNameController,
                    decoration: const InputDecoration(
                      labelText: 'Location Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newLocationAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Full Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _addNewLocation,
                    child: const Text(
                      'Add Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Business Hours
            _buildSettingsCard(
              title: 'Business Hours',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Set your weekly business hours:'),
                  const SizedBox(height: 8),
                  ..._businessHours.entries.map((entry) => Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(entry.key),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectTime(context, entry.key, 'open'),
                              child: Text(
                                _formatTimeOfDay(entry.value['open']!),
                              ),
                            ),
                          ),
                          const Text('to'),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectTime(context, entry.key, 'close'),
                              child: Text(
                                _formatTimeOfDay(entry.value['close']!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  )).toList(),
                  SwitchListTile(
                    title: const Text('Open 24/7'),
                    value: false,
                    onChanged: (value) {
                      // Implement 24/7 logic
                    },
                  ),
                ],
              ),
            ),

            // 4. Payment Methods
            _buildSettingsCard(
              title: 'Payment Methods',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select available payment methods:'),
                  const SizedBox(height: 8),
                  ..._paymentMethods.entries.map((entry) => CheckboxListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethods[entry.key] = value!;
                      });
                    },
                  )).toList(),
                ],
              ),
            ),

            // Size Settings
            _buildSettingsCard(
              title: 'Size Options',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Sizes:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSizes.map((size) {
                      return FilterChip(
                        label: Text(size),
                        selected: _selectedSizes.contains(size),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSizes.add(size);
                            } else {
                              _selectedSizes.remove(size);
                            }
                          });
                        },
                        selectedColor: Colors.deepPurple.withOpacity(0.2),
                        checkmarkColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _selectedSizes.contains(size)
                              ? Colors.deepPurple
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newSizeController,
                          decoration: const InputDecoration(
                            labelText: 'Add New Size',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_newSizeController.text.isNotEmpty) {
                            setState(() {
                              _availableSizes.add(_newSizeController.text);
                              _newSizeController.clear();
                            });
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Color Settings
            _buildSettingsCard(
              title: 'Color Options',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Colors:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableColors.map((color) {
                      return FilterChip(
                        label: Text(color),
                        selected: _selectedColors.contains(color),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedColors.add(color);
                            } else {
                              _selectedColors.remove(color);
                            }
                          });
                        },
                        selectedColor: Colors.deepPurple.withOpacity(0.2),
                        checkmarkColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _selectedColors.contains(color)
                              ? Colors.deepPurple
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newColorController,
                          decoration: const InputDecoration(
                            labelText: 'Add New Color',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_newColorController.text.isNotEmpty) {
                            setState(() {
                              _availableColors.add(_newColorController.text);
                              _newColorController.clear();
                            });
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Shipping Settings
            _buildSettingsCard(
              title: 'Shipping Partners',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Default Shipping Partner:'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedShippingPartner,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _shippingPartners
                        .map((partner) => DropdownMenuItem(
                              value: partner,
                              child: Text(partner),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedShippingPartner = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Navigate to shipping partner management
                    },
                    child: const Text('Manage Shipping Partners'),
                  ),
                ],
              ),
            ),

            // Category Settings
            _buildSettingsCard(
              title: 'Product Categories',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Categories:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: _selectedCategories.contains(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        selectedColor: Colors.deepPurple.withOpacity(0.2),
                        checkmarkColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _selectedCategories.contains(category)
                              ? Colors.deepPurple
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newCategoryController,
                          decoration: const InputDecoration(
                            labelText: 'Add New Category',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_newCategoryController.text.isNotEmpty) {
                            setState(() {
                              _categories.add(_newCategoryController.text);
                              _newCategoryController.clear();
                            });
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Save Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveAllSettings,
                child: const Text(
                  'SAVE ALL SETTINGS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required Widget content}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _selectTime(BuildContext context, String day, String type) async {
    final initialTime = _businessHours[day]![type]!;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (pickedTime != null) {
      setState(() {
        _businessHours[day]![type] = pickedTime;
      });
    }
  }

  void _addNewLocation() {
    if (_newLocationNameController.text.isNotEmpty && 
        _newLocationAddressController.text.isNotEmpty) {
      setState(() {
        _shopLocations.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': _newLocationNameController.text,
          'address': _newLocationAddressController.text,
          'latitude': 0.0,
          'longitude': 0.0,
          'isPrimary': _shopLocations.isEmpty,
        });
        _newLocationNameController.clear();
        _newLocationAddressController.clear();
      });
    }
  }

  void _removeLocation(String id) {
    setState(() {
      _shopLocations.removeWhere((loc) => loc['id'] == id);
    });
  }

  void _setAsPrimaryLocation(String id) {
    setState(() {
      for (var location in _shopLocations) {
        location['isPrimary'] = location['id'] == id;
      }
    });
  }

  void _saveAllSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All shop settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}