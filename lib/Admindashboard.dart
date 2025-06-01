import 'package:admin/AdminService.dart';
import 'package:admin/AdminShipping.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/AdminProducts.dart';
import 'package:admin/AdminOrders.dart';
import 'package:admin/AdminCustomers.dart';
import 'package:admin/ShopSettings.dart';
import 'package:admin/AdminFAQ.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OverviewPage(),
    AddProductPage(),
    ProjectManagementApp(),
    CustomerPage(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Products",
    "Orders",
    "Customers",
  ];

  void _onDrawerOptionSelected(String option) {
    Navigator.pop(context); // Close the drawer

    if (option == "Logout") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out")),
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$option selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, size: 30, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 10),
                  Text("Admin Panel", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("textile@shop.com", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Shop Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopSettingsPage()),
              );
            },
          ),

            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text("Shipping"),
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShippingManagementApp()),
            );
          },
              
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text("Services"),
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ServicesApp()),
            );
          },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text("FAQ"),
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQApp()),
            );
          },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => _onDrawerOptionSelected("Logout"),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
        ],
      ),
    );
  }
}

// ---------------------- Overview Page ----------------------

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  Widget _buildStatCard(String title, String value, String change, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor.withOpacity(0.9), bgColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      width: 160,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(change, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Icon(icon, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statCards = [
      _buildStatCard("Revenue", "\u20B91,20,000", "+10.2%", Colors.deepPurple, Icons.currency_rupee),
      _buildStatCard("Orders", "1,254", "+3.1%", Colors.black87, Icons.shopping_cart),
      _buildStatCard("Customers", "804", "+5.6%", Colors.deepPurple, Icons.people),
      _buildStatCard("Returns", "31", "-0.9%", Colors.black87, Icons.undo),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statCards,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User Growth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                SizedBox(height: 180, child: LineChartSample()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Device Traffic", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                SizedBox(height: 200, child: BarChartSample()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Line Chart ----------------------

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 2),
              FlSpot(2, 1.8),
              FlSpot(3, 2.5),
              FlSpot(4, 2.2),
              FlSpot(5, 3),
            ],
            isCurved: true,
            barWidth: 3,
            color: Colors.deepPurple,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Bar Chart ----------------------

class BarChartSample extends StatelessWidget {
  const BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: List.generate(6, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(
            toY: (10 + i * 2).toDouble(),
            color: i == 2 ? Colors.deepPurple : Colors.grey.shade400,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          )
        ])),
      ),
    );
  }
}
