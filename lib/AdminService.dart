import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ServicesApp());
}

class ServicesApp extends StatelessWidget {
  const ServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const ServicesPage(),
    );
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Service> _services = [
    Service(
      id: 'SRV001',
      name: 'Express Delivery',
      description: '24-hour guaranteed delivery for urgent shipments',
      price: 12.99,
      duration: '24 hours',
      category: 'Delivery',
      image: 'assets/delivery.png',
      features: [
        'Real-time tracking',
        'Signature confirmation',
        'Insurance up to \$500'
      ],
    ),
    Service(
      id: 'SRV002',
      name: 'Gift Wrapping',
      description: 'Elegant gift wrapping with personalized message card',
      price: 5.99,
      duration: 'Adds 1 hour',
      category: 'Packaging',
      image: 'assets/gift.png',
      features: [
        '3 wrapping styles',
        'Free greeting card',
        'Custom message'
      ],
    ),
    Service(
      id: 'SRV003',
      name: 'Premium Support',
      description: 'Dedicated support line with 15-minute response guarantee',
      price: 9.99,
      duration: 'Monthly',
      category: 'Support',
      image: 'assets/support.png',
      features: [
        '24/7 availability',
        'Priority troubleshooting',
        'Dedicated agent'
      ],
    ),
    Service(
      id: 'SRV004',
      name: 'Installation',
      description: 'Professional product installation by certified technicians',
      price: 29.99,
      duration: '1-2 hours',
      category: 'Setup',
      image: 'assets/install.png',
      features: [
        'Same-day service',
        'Free consultation',
        '1-year warranty'
      ],
    ),
    Service(
      id: 'SRV005',
      name: 'Extended Warranty',
      description: 'Add 2 years to standard manufacturer warranty',
      price: 19.99,
      duration: '2 years',
      category: 'Protection',
      image: 'assets/warranty.png',
      features: [
        'Covers parts/labor',
        'In-home service',
        'Transferable'
      ],
    ),
  ];

  final List<String> _categories = [
    'All',
    'Delivery',
    'Packaging',
    'Support',
    'Setup',
    'Protection'
  ];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Service> get _filteredServices {
    return _services.where((service) {
      final matchesSearch = _searchQuery.isEmpty ||
          service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || service.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showAdvancedFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: Colors.deepPurple.withOpacity(0.2),
                          checkmarkColor: Colors.deepPurple,
                          labelStyle: TextStyle(
                            color: _selectedCategory == category
                                ? Colors.deepPurple
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Services List
          Expanded(
            child: _filteredServices.isEmpty
                ? const Center(
                    child: Text('No services match your search'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServices[index];
                      return ServiceCard(
                        service: service,
                        onTap: () => _showServiceDetails(service),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showServiceDetails(Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(service.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Service ID', service.id),
              _buildDetailRow('Category', service.category),
              _buildDetailRow('Price', '\$${service.price}'),
              _buildDetailRow('Duration', service.duration),
              const SizedBox(height: 16),
              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...service.features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  )),
              const SizedBox(height: 32),
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
                  onPressed: () {
                    // Add to cart functionality
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${service.name} added to cart'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Text(value),
        ],
      ),
    );
  }

  void _showAdvancedFilter() {
    double minPrice = 0;
    double maxPrice = 30;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Services'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Price Range'),
                    RangeSlider(
                      values: RangeValues(minPrice, maxPrice),
                      min: 0,
                      max: 50,
                      divisions: 10,
                      labels: RangeLabels(
                        '\$$minPrice',
                        '\$$maxPrice',
                      ),
                      onChanged: (values) {
                        setState(() {
                          minPrice = values.start;
                          maxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Categories'),
                    Wrap(
                      spacing: 8,
                      children: _categories.where((c) => c != 'All').map(
                        (category) {
                          return FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : 'All';
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedCategory = 'All';
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      // Apply filters
                    });
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration;
  final String category;
  final String image;
  final List<String> features;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.image,
    required this.features,
  });
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(service.image),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(service.category),
                          backgroundColor: Colors.deepPurple.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${service.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}