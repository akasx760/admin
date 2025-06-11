import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/AdminService.dart';
import 'package:admin/AdminShipping.dart';
import 'package:admin/OrderManagement/OrderDetailPage.dart';
import 'package:admin/OrderManagement/StatusUpdateDialog.dart';
import 'package:admin/ProductManagement/AddProductPage.dart';
import 'package:admin/ProductManagement/ProductListingPage.dart';
import 'package:admin/ServiceManagement/CategoryListPage.dart';
import 'package:admin/ServiceManagement/CustomerListPage.dart';
import 'package:admin/ServiceManagement/StockAlertsPage.dart';
import 'package:admin/AdminProducts.dart';
import 'package:admin/AdminOrders.dart';
import 'package:admin/AdminCustomers.dart';
import 'package:admin/ShopSettings.dart';
import 'package:admin/AdminFAQ.dart';
import 'package:admin/Shopsettings/SizeSettingsPage.dart';
import 'package:admin/Shopsettings/ColorSettingsPage.dart';
import 'package:admin/Shopsettings/CategorySettingsPage.dart';
import 'package:admin/Shopsettings/ShippingSettingsPage.dart';
import 'package:admin/Settings/Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard Pro',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        cardTheme: CardThemeData( // Updated to CardThemeData
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPageIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Widget> _pages = const [
    OverviewPage(),
    ShopSettingsPage(),
    ProductManagementPage(),
    ProjectManagementApp(),
    ServicesApp(),
    FAQApp(),
    ShippingManagementApp(),
    CustomerPage(),
    ProductListingPage(products: []),
    OrderDetailPage(),
    SettingsPage(),
  ];

  void _onDrawerOptionSelected(int index) {
    setState(() {
      _currentPageIndex = index;
      _isSearching = false;
    });
    Navigator.pop(context);
  }

  void _onLogout() {
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
                const SnackBar(content: Text("Logged out successfully")),
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentPageIndex) {
      case 0:
        return "Dashboard";
      case 1:
        return "Shop Settings";
      case 2:
        return "Add Product";
      case 3:
        return "Project Management";
      case 4:
        return "Services";
      case 5:
        return "FAQ";
      case 6:
        return "Shipping Management";
      case 7:
        return "Customer Page";
      case 8:
        return "Product Listing";
      case 9:
        return "Order Details";
      case 10:
        return "Settings";
      default:
        return "Admin Dashboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _pages[_currentPageIndex],
      floatingActionButton: _currentPageIndex == 0 ? _buildQuickActionButton() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _currentPageIndex == 0 && !_isSearching
          ? const Text("Dashboard")
          : _isSearching
              ? _buildSearchField()
              : Text(_getAppBarTitle()),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      actions: [
        if (_currentPageIndex == 0) _buildSearchIcon(),
        if (!_isSearching) ...[
          _buildNotificationsButton(),
          _buildProfileButton(),
        ],
      ],
    );
  }

  Widget _buildQuickActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
            height: 200,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add Product'),
                  onTap: () {
                    Navigator.pop(context);
                    _onDrawerOptionSelected(2);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Create Order'),
                  onTap: () {
                    Navigator.pop(context);
                    _onDrawerOptionSelected(9);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Add Customer'),
                  onTap: () {
                    Navigator.pop(context);
                    _onDrawerOptionSelected(7);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSearchIcon() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        setState(() {
          _isSearching = true;
        });
      },
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          // Implement search functionality
        },
        onSubmitted: (value) {
          // Handle search submission
        },
      ),
    );
  }

  Widget _buildNotificationsButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            _showNotificationsDialog();
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications (3)'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildNotificationItem('New order received', '5 min ago', Icons.shopping_cart),
              _buildNotificationItem('Low stock alert', '2 hours ago', Icons.warning),
              _buildNotificationItem('System update available', '1 day ago', Icons.system_update),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss All'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String time, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(time),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle notification tap
      },
    );
  }

  Widget _buildProfileButton() {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          _showProfileDialog(context);
        } else if (value == 'logout') {
          _onLogout();
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('My Profile'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Admin Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
            ),
            const SizedBox(height: 16),
            const Text("Admin User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("admin@kurzonetextile.com"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildExpansionTile('Shop Settings', [
            _buildDrawerSubItem('Size', Icons.straighten, SizeSettingsPage()),
            _buildDrawerSubItem('Color', Icons.color_lens, ColorSettingsPage()),
            _buildDrawerSubItem('Shipping Partner', Icons.local_shipping, ShippingSettingsPage()),
            _buildDrawerSubItem('Category', Icons.category, CategorySettingsPage()),
          ]),
          _buildExpansionTile('Product Management', [
            _buildDrawerSubItem('Add Product', Icons.upload_file, AddProductPage()),
            _buildDrawerSubItem('Product Listing', Icons.view_list, ProductListingPage(products: [])),
          ]),
          _buildExpansionTile('Order Management', [
            _buildDrawerSubItem('Order Detail', Icons.upload_file, OrderDetailPage()),
            _buildDrawerSubItem('Order List Page', Icons.assignment_outlined, Center(child: Text("Order List Page"))),
            _buildDrawerSubItem('Shipping Management', Icons.info_outline, Center(child: Text("Shipping Management"))),
            _buildDrawerSubItem('Status Update', Icons.edit_note, StatusUpdateDialog()),
          ]),
          _buildExpansionTile('Services', [
            _buildDrawerSubItem('Category List', Icons.upload_file, CategoryListPage()),
            _buildDrawerSubItem('Customer List', Icons.assignment_outlined, CustomerListPage()),
            _buildDrawerSubItem('Order List', Icons.info_outline, Center(child: Text("Order List"))),
            _buildDrawerSubItem('Stock Alerts', Icons.edit_note, StockAlertsPage()),
          ]),
          _buildDrawerItem(Icons.question_answer, 'FAQ', 5),
          _buildDrawerItem(Icons.local_shipping, 'Shipping', 6),
          _buildDrawerItem(Icons.person_add, 'Register Customer', 7),
          _buildDrawerItem(Icons.settings, 'Settings', 10),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _onLogout,
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _currentPageIndex == index,
      selectedTileColor: Colors.deepPurple.withOpacity(0.1),
      onTap: () => _onDrawerOptionSelected(index),
    );
  }

  ExpansionTile _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      leading: const Icon(Icons.settings),
      title: Text(title),
      initiallyExpanded: _currentPageIndex == 1,
      children: children,
    );
  }

  ListTile _buildDrawerSubItem(String title, IconData icon, Widget page) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, size: 20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
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
          _buildChartContainer("User   Growth", const LineChartSample()),
          const SizedBox(height: 20),
          _buildChartContainer("Device Traffic", const BarChartSample()),
        ],
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          SizedBox(height: 180, child: chart),
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

// ---------------------- Drawer Header ----------------------

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
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
          Text("Admin", style: TextStyle(color: Colors.white, fontSize: 18)),
          Text("KurZonetextile@shop.com", style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}