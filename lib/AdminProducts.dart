import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
runApp(const AdminApp());
}



class AdminApp extends StatelessWidget {
const AdminApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Admin Portal',
debugShowCheckedModeBanner: false,
theme: ThemeData(
textTheme: GoogleFonts.poppinsTextTheme(),
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
useMaterial3: true,
),
home: const AddProductPage(),
);
}
}

class AddProductPage extends StatefulWidget {
const AddProductPage({super.key});

@override
State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
final _formKey = GlobalKey<FormState>();
String productName = '';
String description = '';
double price = 0.0;
String size = '';
String category = 'Dress';
List<String> selectedColors = [];
List<String> imageUrls = [];
List<Map<String, dynamic>> colorVariants = [];
bool showVariantSection = false;

final List<String> availableColors = [
'Red',
'Blue',
'Green',
'Black',
'White',
'Yellow',
'Purple',
'Pink'
];

void addProduct() {
if (_formKey.currentState!.validate()) {
_formKey.currentState!.save();
print("""
Product: $productName
Price: $price
Description: $description
Colors: $selectedColors
Variants: $colorVariants
""");
// API call would go here
}
}

void addColorVariant() {
setState(() {
colorVariants.add({
'color': selectedColors.isNotEmpty ? selectedColors.first : '',
'images': [],
'sizes': ['S', 'M', 'L'],
'price': price,
});
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: Text(
'Add New Dress',
style: GoogleFonts.poppins(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
backgroundColor: Colors.deepPurple,
iconTheme: const IconThemeData(color: Colors.white),
),
body: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20.0),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
  // Product Image Upload
  Center(
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 50,
            color: Colors.deepPurple[300],
          ),
          const SizedBox(height: 10),
          Text(
            'Add Product Images',
            style: GoogleFonts.poppins(
              color: Colors.deepPurple,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 30),

  // Main Product Information Section
  Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),

          // Product Name
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Dress Name*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Required field' : null,
            onSaved: (value) => productName = value!,
          ),
          const SizedBox(height: 16),

          // Description
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Required field' : null,
            onSaved: (value) => description = value!,
          ),
          const SizedBox(height: 16),

          // Price
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Base Price (₹)*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'Required field' : null,
            onSaved: (value) => price = double.parse(value!),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Category*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
            ),
            value: category,
            items: const [
              DropdownMenuItem(value: 'Dress', child: Text('Dress')),
              DropdownMenuItem(value: 'Top', child: Text('Top')),
              DropdownMenuItem(value: 'Bottom', child: Text('Bottom')),
            ],
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 20),

  // Color Selection Section
  Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Colors*',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableColors.map((color) {
              return FilterChip(
                label: Text(color),
                selected: selectedColors.contains(color),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedColors.add(color);
                    } else {
                      selectedColors.remove(color);
                    }
                  });
                },
                selectedColor: Colors.deepPurple[100],
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: selectedColors.contains(color)
                      ? Colors.deepPurple
                      : Colors.black,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Color Variants',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: showVariantSection,
                onChanged: (value) {
                  setState(() {
                    showVariantSection = value;
                    if (value && selectedColors.isNotEmpty) {
                      addColorVariant();
                    }
                  });
                },
                activeColor: Colors.deepPurple,
              ),
            ],
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 20),

  // Color Variants Section (Conditional)
  if (showVariantSection && selectedColors.isNotEmpty)
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Variants',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        ...colorVariants.asMap().entries.map((entry) {
          int index = entry.key;
          var variant = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Variant ${index + 1}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () {
                          setState(() {
                            colorVariants.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: variant['color'],
                    items: selectedColors
                        .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        colorVariants[index]['color'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Upload Images for this Variant',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: variant['images'].length + 1,
                    itemBuilder: (context, imgIndex) {
                      if (imgIndex == variant['images'].length) {
                        return GestureDetector(
                          onTap: () {
                            // Implement image picker here
                            setState(() {
                              variant['images']
                                  .add('new_image_url');
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepPurple),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.deepPurple),
                          ),
                        );
                      }
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    variant['images'][imgIndex]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  variant['images']
                                      .removeAt(imgIndex);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Variant Price (\$)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: variant['price'].toString(),
                    onChanged: (value) {
                      setState(() {
                        variant['price'] = double.parse(value);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: addColorVariant,
          child: Text(
            'Add Another Variant',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),

  // Submit Button
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
      onPressed: addProduct,
      child: Text(
        "SAVE PRODUCT",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  ),
],
),
),
),
),
);
}
}