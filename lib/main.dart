import 'package:flutter/material.dart';
import 'package:admin/Admindashboard.dart'; // Only import what is used

void main() {
  runApp(const TextileDashboardApp());
}

class TextileDashboardApp extends StatelessWidget {
  const TextileDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Textile Admin Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
