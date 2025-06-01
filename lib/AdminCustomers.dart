import 'package:flutter/material.dart';

class Customer {
  final String name;
  final String email;
  final String imageUrl;

  Customer({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> customers = [
    Customer(
      name: "Akash V",
      email: "akash@example.com",
      imageUrl: "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202503/yash-arrogant-242454218-16x9_0.jpg?VersionId=Ndf29lkOLUB5GMf0waB8ZfMyVHD.6S4r&size=690:388",
    ),
    Customer(
      name: "Ajay",
      email: "ajay@example.com",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREo9B7xS9hCo3qACKqf2HvDILb4JCq34Ux3g&s",
    ),
  ];

  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
  }

  void _editCustomer(int index) {
    final customer = customers[index];
    final nameController = TextEditingController(text: customer.name);
    final emailController = TextEditingController(text: customer.email);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                customers[index] = Customer(
                  name: nameController.text,
                  email: emailController.text,
                  imageUrl: customer.imageUrl,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addCustomer() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final defaultImage = "https://i.pravatar.cc/150?img=${customers.length + 1}";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                customers.add(Customer(
                  name: nameController.text,
                  email: emailController.text,
                  imageUrl: defaultImage,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Customers"),
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: customers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(customer.imageUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    customer.email,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        onPressed: () => _editCustomer(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCustomer(index),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _addCustomer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
