import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin/main.dart';

void main() {
  testWidgets('Dashboard navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const TextileDashboardApp());

    // Check initial page
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Products Page'), findsNothing);

    // Navigate to Products
    await tester.tap(find.byIcon(Icons.shopping_bag));
    await tester.pumpAndSettle();

    expect(find.text('Products Page'), findsOneWidget);

    // Navigate to Orders
    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pumpAndSettle();

    expect(find.text('Orders Page'), findsOneWidget);

    // Navigate to Customers
    await tester.tap(find.byIcon(Icons.people));
    await tester.pumpAndSettle();

    expect(find.text('Customers Page'), findsOneWidget);
  });
}
