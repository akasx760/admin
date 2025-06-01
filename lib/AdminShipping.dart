import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/Admindashboard.dart';

void main() {
  runApp(const ShippingManagementApp());
}

class ShippingManagementApp extends StatelessWidget {
  const ShippingManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const ShippingManagementPage(),
    );
  }
}

class ShippingManagementPage extends StatefulWidget {
  const ShippingManagementPage({super.key});

  @override
  State<ShippingManagementPage> createState() => _ShippingManagementPageState();
}

class _ShippingManagementPageState extends State<ShippingManagementPage> {
  final List<Map<String, dynamic>> _shippingPartners = [
    {
      'name': 'FedEx',
      'logo': 'assets/fedex.png',
      'domestic': true,
      'international': true,
      'rates': [
        {'weight': '0-1kg', 'price': 5.99},
        {'weight': '1-3kg', 'price': 8.99},
        {'weight': '3-5kg', 'price': 12.99},
      ]
    },
    {
      'name': 'UPS',
      'logo': 'assets/ups.png',
      'domestic': true,
      'international': false,
      'rates': [
        {'weight': '0-1kg', 'price': 6.49},
        {'weight': '1-3kg', 'price': 9.49},
        {'weight': '3-5kg', 'price': 13.49},
      ]
    },
    {
      'name': 'DHL',
      'logo': 'assets/dhl.png',
      'domestic': false,
      'international': true,
      'rates': [
        {'weight': '0-1kg', 'price': 7.99},
        {'weight': '1-3kg', 'price': 10.99},
        {'weight': '3-5kg', 'price': 15.99},
      ]
    },
  ];

  final List<Map<String, dynamic>> _shippingZones = [
    {
      'name': 'Local',
      'regions': ['City A', 'City B'],
      'deliveryTime': '1-2 days',
      'freeThreshold': 50.00,
    },
    {
      'name': 'National',
      'regions': ['State X', 'State Y'],
      'deliveryTime': '3-5 days',
      'freeThreshold': 100.00,
    },
    {
      'name': 'International',
      'regions': ['Country M', 'Country N'],
      'deliveryTime': '7-14 days',
      'freeThreshold': 200.00,
    },
  ];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    

onPressed: () {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }
},


  ),
          title: const Text('Shipping Management'),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.local_shipping)), 
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.settings)),
            ],
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search and Filter Bar
              if (_selectedTab == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search shipping partners...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              
              // Main Content Area
              Expanded(
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    // Partners Tab
                    _buildShippingPartnersList(),

                    // Zones Tab
                    _buildShippingZonesList(),

                    // Settings Tab
                    _buildShippingSettings(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _selectedTab != 2
            ? FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  if (_selectedTab == 0) {
                    _showAddPartnerDialog();
                  } else {
                    _showAddZoneDialog();
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildShippingPartnersList() {
    return ListView.builder(
      itemCount: _shippingPartners.length,
      itemBuilder: (context, index) {
        final partner = _shippingPartners[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.withOpacity(0.1),
              child: Text(partner['name'][0]),
            ),
            title: Text(
              partner['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${partner['domestic'] ? 'Domestic' : ''}'
              '${partner['domestic'] && partner['international'] ? ' • ' : ''}'
              '${partner['international'] ? 'International' : ''}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shipping Rates:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...partner['rates'].map<Widget>((rate) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(rate['weight']),
                            Text('\$${rate['price']}'),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _showEditPartnerDialog(partner),
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _showDeletePartnerConfirmation(index),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShippingZonesList() {
    return ListView.builder(
      itemCount: _shippingZones.length,
      itemBuilder: (context, index) {
        final zone = _shippingZones[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.map,
                color: Colors.deepPurple,
              ),
            ),
            title: Text(
              zone['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery: ${zone['deliveryTime']}'),
                Text('Free shipping over \$${zone['freeThreshold']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditZoneDialog(zone),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteZoneConfirmation(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShippingSettings() {
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Policy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter your shipping policy here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Return Policy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter your return policy here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Free Shipping Threshold'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.deepPurple,
                ),
                SwitchListTile(
                  title: const Text('Allow International Shipping'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Save Settings',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddPartnerDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    bool domestic = true;
    bool international = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shipping Partner'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Partner Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                const Text('Service Areas:'),
                CheckboxListTile(
                  title: const Text('Domestic'),
                  value: domestic,
                  onChanged: (value) {
                    setState(() {
                      domestic = value!;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
                CheckboxListTile(
                  title: const Text('International'),
                  value: international,
                  onChanged: (value) {
                    setState(() {
                      international = value!;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  _shippingPartners.add({
                    'name': nameController.text,
                    'domestic': domestic,
                    'international': international,
                    'rates': [
                      {'weight': '0-1kg', 'price': 0.0},
                      {'weight': '1-3kg', 'price': 0.0},
                      {'weight': '3-5kg', 'price': 0.0},
                    ]
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPartnerDialog(Map<String, dynamic> partner) {
    // Similar to add dialog but with existing values
    // Implementation would be similar to _showAddPartnerDialog
    // but with initial values and update logic
  }

  void _showDeletePartnerConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Delete ${_shippingPartners[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _shippingPartners.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddZoneDialog() {
    // Similar implementation pattern as partner dialog
    // Would include fields for zone name, regions, delivery time, etc.
  }

  void _showEditZoneDialog(Map<String, dynamic> zone) {
    // Similar to add zone dialog but with existing values
  }

  void _showDeleteZoneConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Delete ${_shippingZones[index]['name']} zone?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _shippingZones.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}