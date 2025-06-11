import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetail {
  int orderId;
  String customerName;
  DateTime orderDate;
  double grandTotal;
  String paymentStatus;
  String paymentMethod;
  String fulfilmentStatus;
  String shippingPartner;
  String trackingNumber;
  String productSummary;
  double discountApplied;

  OrderDetail({
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.grandTotal,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.fulfilmentStatus,
    required this.shippingPartner,
    required this.trackingNumber,
    required this.productSummary,
    required this.discountApplied,
  });
}

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final List<OrderDetail> _orders = [
    OrderDetail(
      orderId: 1001,
      customerName: "Alice Johnson",
      orderDate: DateTime(2024, 5, 10),
      grandTotal: 2500.75,
      paymentStatus: "Paid",
      paymentMethod: "Credit Card",
      fulfilmentStatus: "Shipped",
      shippingPartner: "FedEx",
      trackingNumber: "FDX123456789",
      productSummary: "Cotton T-Shirt x2, Silk Scarf x1",
      discountApplied: 150.00,
    ),
    OrderDetail(
      orderId: 1002,
      customerName: "Bob Smith",
      orderDate: DateTime(2024, 5, 12),
      grandTotal: 3799.99,
      paymentStatus: "Pending",
      paymentMethod: "PayPal",
      fulfilmentStatus: "Processing",
      shippingPartner: "DHL",
      trackingNumber: "DHL987654321",
      productSummary: "Leather Jacket x1",
      discountApplied: 0.00,
    ),
    OrderDetail(
      orderId: 1003,
      customerName: "Catherine Zeta",
      orderDate: DateTime(2024, 5, 15),
      grandTotal: 1200.00,
      paymentStatus: "Paid",
      paymentMethod: "Cash",
      fulfilmentStatus: "Delivered",
      shippingPartner: "UPS",
      trackingNumber: "UPS456123789",
      productSummary: "Garden Chair x1",
      discountApplied: 100.00,
    ),
    OrderDetail(
      orderId: 1004,
      customerName: "David Lee",
      orderDate: DateTime(2024, 5, 18),
      grandTotal: 999.00,
      paymentStatus: "Failed",
      paymentMethod: "Bank Transfer",
      fulfilmentStatus: "Pending",
      shippingPartner: "USPS",
      trackingNumber: "USPS321654987",
      productSummary: "Sports Watch x1",
      discountApplied: 50.00,
    ),
    OrderDetail(
      orderId: 1005,
      customerName: "Eva Green",
      orderDate: DateTime(2024, 5, 20),
      grandTotal: 1599.50,
      paymentStatus: "Paid",
      paymentMethod: "Credit Card",
      fulfilmentStatus: "Shipped",
      shippingPartner: "FedEx",
      trackingNumber: "FDX111222333",
      productSummary: "Jewelry Set x1",
      discountApplied: 200.00,
    ),
    OrderDetail(
      orderId: 1006,
      customerName: "Frank White",
      orderDate: DateTime(2024, 5, 22),
      grandTotal: 4500.00,
      paymentStatus: "Paid",
      paymentMethod: "PayPal",
      fulfilmentStatus: "Delivered",
      shippingPartner: "DHL",
      trackingNumber: "DHL555666777",
      productSummary: "Furniture Set x1",
      discountApplied: 300.00,
    ),
    OrderDetail(
      orderId: 1007,
      customerName: "Grace Kelly",
      orderDate: DateTime(2024, 5, 25),
      grandTotal: 890.00,
      paymentStatus: "Pending",
      paymentMethod: "Cash",
      fulfilmentStatus: "Processing",
      shippingPartner: "Local Courier",
      trackingNumber: "LC987654321",
      productSummary: "Books x5",
      discountApplied: 25.00,
    ),
    OrderDetail(
      orderId: 1008,
      customerName: "Henry Adams",
      orderDate: DateTime(2024, 5, 28),
      grandTotal: 2300.00,
      paymentStatus: "Paid",
      paymentMethod: "Credit Card",
      fulfilmentStatus: "Delivered",
      shippingPartner: "UPS",
      trackingNumber: "UPS999888777",
      productSummary: "Automotive Accessories x3",
      discountApplied: 0.00,
    ),
    OrderDetail(
      orderId: 1009,
      customerName: "Isabel Moore",
      orderDate: DateTime(2024, 5, 30),
      grandTotal: 150.00,
      paymentStatus: "Paid",
      paymentMethod: "Bank Transfer",
      fulfilmentStatus: "Shipped",
      shippingPartner: "USPS",
      trackingNumber: "USPS123789456",
      productSummary: "Beauty Products x10",
      discountApplied: 15.00,
    ),
    OrderDetail(
      orderId: 1010,
      customerName: "Jack Turner",
      orderDate: DateTime(2024, 6, 1),
      grandTotal: 3200.00,
      paymentStatus: "Paid",
      paymentMethod: "Credit Card",
      fulfilmentStatus: "Processing",
      shippingPartner: "FedEx",
      trackingNumber: "FDX444555666",
      productSummary: "Sports Gear x4",
      discountApplied: 100.00,
    ),
  ];

  final int _rowsPerPage = 10;
  int _currentPage = 0;
  late ScrollController _scrollController;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _grandTotalController = TextEditingController();
  final TextEditingController _trackingNumberController = TextEditingController();
  final TextEditingController _productSummaryController = TextEditingController();
  final TextEditingController _discountAppliedController = TextEditingController();

  String? _selectedPaymentStatus;
  String? _selectedPaymentMethod;
  String? _selectedFulfilmentStatus;
  String? _selectedShippingPartner;

  DateTime? _selectedDate;
  int? _editingIndex;

  static const List<String> paymentStatusOptions = ['Paid', 'Pending', 'Failed'];
  static const List<String> paymentMethodOptions = ['Credit Card', 'PayPal', 'Cash', 'Bank Transfer'];
  static const List<String> fulfilmentStatusOptions = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
  static const List<String> shippingPartnerOptions = ['FedEx', 'DHL', 'UPS', 'USPS', 'Local Courier'];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _orderIdController.dispose();
    _customerNameController.dispose();
    _orderDateController.dispose();
    _grandTotalController.dispose();
    _trackingNumberController.dispose();
    _productSummaryController.dispose();
    _discountAppliedController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final initialDate = _selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _orderDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _openAddEditDialog({int? index}) {
    if (index != null) {
      _editingIndex = index;
      final order = _orders[index];
      _orderIdController.text = order.orderId.toString();
      _customerNameController.text = order.customerName;
      _orderDateController.text = DateFormat('yyyy-MM-dd').format(order.orderDate);
      _grandTotalController.text = order.grandTotal.toStringAsFixed(2);
      _trackingNumberController.text = order.trackingNumber;
      _productSummaryController.text = order.productSummary;
      _discountAppliedController.text = order.discountApplied.toStringAsFixed(2);
      _selectedPaymentStatus = order.paymentStatus;
      _selectedPaymentMethod = order.paymentMethod;
      _selectedFulfilmentStatus = order.fulfilmentStatus;
      _selectedShippingPartner = order.shippingPartner;
      _selectedDate = order.orderDate;
    } else {
      _editingIndex = null;
      _orderIdController.clear();
      _customerNameController.clear();
      _orderDateController.clear();
      _grandTotalController.clear();
      _trackingNumberController.clear();
      _productSummaryController.clear();
      _discountAppliedController.clear();
      _selectedPaymentStatus = null;
      _selectedPaymentMethod = null;
      _selectedFulfilmentStatus = null;
      _selectedShippingPartner = null;
      _selectedDate = null;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Text(
                    _editingIndex == null ? 'Add New Order Detail' : 'Edit Order Detail',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: [
                      SizedBox(
                        width: 180,
                        child: _buildTextField(
                          controller: _orderIdController,
                          label: 'Order ID',
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Order ID is required';
                            if (int.tryParse(val.trim()) == null) return 'Enter valid number';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: _buildTextField(
                          controller: _customerNameController,
                          label: 'Customer Name',
                          validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: GestureDetector(
                          onTap: () => _pickDate(context),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              controller: _orderDateController,
                              label: 'Order Date',
                              validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                              suffixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: _buildTextField(
                          controller: _grandTotalController,
                          label: 'Grand Total (₹)',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Required';
                            if (double.tryParse(val.trim()) == null) return 'Invalid amount';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _buildDropdownField(
                          label: 'Payment Status',
                          value: _selectedPaymentStatus,
                          items: paymentStatusOptions,
                          onChanged: (val) => setState(() => _selectedPaymentStatus = val),
                          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _buildDropdownField(
                          label: 'Payment Method',
                          value: _selectedPaymentMethod,
                          items: paymentMethodOptions,
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val),
                          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _buildDropdownField(
                          label: 'Fulfilment Status',
                          value: _selectedFulfilmentStatus,
                          items: fulfilmentStatusOptions,
                          onChanged: (val) => setState(() => _selectedFulfilmentStatus = val),
                          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _buildDropdownField(
                          label: 'Shipping Partner',
                          value: _selectedShippingPartner,
                          items: shippingPartnerOptions,
                          onChanged: (val) => setState(() => _selectedShippingPartner = val),
                          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _buildTextField(
                          controller: _trackingNumberController,
                          label: 'Tracking Number',
                          validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: _buildTextField(
                          controller: _productSummaryController,
                          label: 'Product Summary',
                          maxLines: 2,
                          validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: _buildTextField(
                          controller: _discountAppliedController,
                          label: 'Discount Applied',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Required';
                            if (double.tryParse(val.trim()) == null) return 'Invalid amount';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final order = OrderDetail(
                              orderId: int.parse(_orderIdController.text.trim()),
                              customerName: _customerNameController.text.trim(),
                              orderDate: DateFormat('yyyy-MM-dd').parse(_orderDateController.text.trim()),
                              grandTotal: double.parse(_grandTotalController.text.trim()),
                              paymentStatus: _selectedPaymentStatus ?? '',
                              paymentMethod: _selectedPaymentMethod ?? '',
                              fulfilmentStatus: _selectedFulfilmentStatus ?? '',
                              shippingPartner: _selectedShippingPartner ?? '',
                              trackingNumber: _trackingNumberController.text.trim(),
                              productSummary: _productSummaryController.text.trim(),
                              discountApplied: double.parse(_discountAppliedController.text.trim()),
                            );

                            setState(() {
                              if (_editingIndex == null) {
                                _orders.add(order);
                              } else {
                                _orders[_editingIndex!] = order;
                                _editingIndex = null;
                              }
                              _currentPage = ((_orders.length - 1) ~/ _rowsPerPage);
                            });

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          _editingIndex == null ? 'Add Order' : 'Update Order',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: validator,
      iconEnabledColor: Colors.deepPurple,
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  List<OrderDetail> get _pagedOrders {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    if (start > _orders.length) return [];
    return _orders.sublist(start, end > _orders.length ? _orders.length : end);
  }

  DataRow _buildDataRow(int index, OrderDetail order) {
    return DataRow(
      cells: [
        DataCell(Text(order.orderId.toString())),
        DataCell(Text(order.customerName)),
        DataCell(Text(DateFormat('yyyy-MM-dd').format(order.orderDate))),
        DataCell(Text('₹${order.grandTotal.toStringAsFixed(2)}')),
        DataCell(Text(order.paymentStatus)),
        DataCell(Text(order.paymentMethod)),
        DataCell(Text(order.fulfilmentStatus)),
        DataCell(Text(order.shippingPartner)),
        DataCell(Text(order.trackingNumber)),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(order.productSummary, overflow: TextOverflow.ellipsis),
          ),
        ),
        DataCell(Text('₹${order.discountApplied.toStringAsFixed(2)}')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                tooltip: 'Edit',
                onPressed: () => _openAddEditDialog(index: _currentPage * _rowsPerPage + index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
                onPressed: () {
                  final deleteIndex = _currentPage * _rowsPerPage + index;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Order'),
                      content: const Text('Are you sure you want to delete this order?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _orders.removeAt(deleteIndex);
                              if (_currentPage > 0 && _pagedOrders.isEmpty) {
                                _currentPage--;
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _scrollController.jumpTo(0);
      });
    }
  }

  void _nextPage() {
    final maxPage = (_orders.length / _rowsPerPage).ceil() - 1;
    if (_currentPage < maxPage) {
      setState(() {
        _currentPage++;
        _scrollController.jumpTo(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_orders.length / _rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: DataTable(
                            columnSpacing: 24,
                            headingRowColor: MaterialStateProperty.all(Colors.deepPurple.shade100),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple,
                              fontSize: 14,
                            ),
                            dataTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
                            columns: const [
                              DataColumn(label: Text('Order ID'), numeric: true),
                              DataColumn(label: Text('Customer Name')),
                              DataColumn(label: Text('Order Date')),
                              DataColumn(label: Text('Grand Total (₹)')),
                              DataColumn(label: Text('Payment Status')),
                              DataColumn(label: Text('Payment Method')),
                              DataColumn(label: Text('Fulfilment Status')),
                              DataColumn(label: Text('Shipping Partner')),
                              DataColumn(label: Text('Tracking Number')),
                              DataColumn(label: Text('Product Summary')),
                              DataColumn(label: Text('Discount Applied')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(_pagedOrders.length, (index) => _buildDataRow(index, _pagedOrders[index])),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Page ${_orders.isEmpty ? 0 : (_currentPage + 1)} of $totalPages',
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: _currentPage > 0 ? Colors.deepPurple : Colors.grey,
                    onPressed: _currentPage > 0 ? _prevPage : null,
                    tooltip: 'Previous Page',
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: (_currentPage < totalPages - 1) ? Colors.deepPurple : Colors.grey,
                    onPressed: (_currentPage < totalPages - 1) ? _nextPage : null,
                    tooltip: 'Next Page',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditDialog(),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add New Order',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
