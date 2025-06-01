import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/admindashboard.dart';  // adjust path accordingly


void main() {
  runApp(const FAQApp());
}

class FAQApp extends StatelessWidget {
  const FAQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const FAQPage(),
    );
  }
}

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I track my order?',
      answer:
          'You can track your order by logging into your account and visiting the "My Orders" section. We also send email updates with tracking links at each stage of delivery.',
      category: 'Orders',
    ),
    FAQItem(
      question: 'What payment methods do you accept?',
      answer:
          'We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and bank transfers. Some regions may have additional payment options available.',
      category: 'Payments',
    ),
    FAQItem(
      question: 'How long does shipping take?',
      answer:
          'Standard shipping takes 3-5 business days domestically and 7-14 days internationally. Express options are available at checkout for faster delivery.',
      category: 'Shipping',
    ),
    FAQItem(
      question: 'What is your return policy?',
      answer:
          'We offer a 30-day return policy for unused items in their original packaging. Please contact our support team to initiate a return and receive a prepaid shipping label.',
      category: 'Returns',
    ),
    FAQItem(
      question: 'How do I contact customer support?',
      answer:
          'Our support team is available 24/7 via live chat on our website or by email at support@example.com. Response time is typically under 2 hours during business days.',
      category: 'Support',
    ),
    FAQItem(
      question: 'Do you offer international shipping?',
      answer:
          'Yes, we ship to over 100 countries worldwide. International shipping rates and delivery times are calculated at checkout based on your location.',
      category: 'Shipping',
    ),
    FAQItem(
      question: 'Can I change or cancel my order?',
      answer:
          'Orders can be modified or cancelled within 1 hour of placement. After that, please contact our support team immediately as we process orders quickly.',
      category: 'Orders',
    ),
    FAQItem(
      question: 'How do I apply a discount code?',
      answer:
          'Enter your code in the "Promo Code" field during checkout. The discount will be applied to your order total before payment.',
      category: 'Payments',
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<String> get _categories {
    final categories = _faqs.map((faq) => faq.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<FAQItem> get _filteredFAQs {
    return _faqs.where((faq) {
      final matchesSearch = _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || faq.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);

},

        ),
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
                    hintText: 'Search FAQs...',
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

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredFAQs.length,
              itemBuilder: (context, index) {
                final faq = _filteredFAQs[index];
                return FAQCard(faq: faq);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _showContactSupportDialog(context);
        },
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final questionController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Your Email',
                    hintText: 'example@email.com',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'Your Question',
                    hintText: 'Type your question here...',
                  ),
                  maxLines: 4,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your question' : null,
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
                // In a real app, you would send this to your support system
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your question has been submitted!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class FAQCard extends StatefulWidget {
  final FAQItem faq;

  const FAQCard({super.key, required this.faq});

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(widget.faq.answer),
                const SizedBox(height: 8),
                Chip(
                  label: Text(widget.faq.category),
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}