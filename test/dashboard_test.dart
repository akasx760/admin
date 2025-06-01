// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:admin/main.dart'; // Replace with actual project import

// void main() {
//   testWidgets('Dashboard UI loads and works', (WidgetTester tester) async {
//     // Pump the entire app
//     await tester.pumpWidget(MyApp());

//     // Allow animations and rendering to complete
//     await tester.pumpAndSettle();

//     // Check if the title is shown
//     expect(find.text('Dashboard'), findsOneWidget);

//     // Check if info cards are present
//     expect(find.text('Visits'), findsOneWidget);
//     expect(find.text('Bounce Rate'), findsOneWidget);
//     expect(find.text('Pageviews'), findsOneWidget);
//     expect(find.text('Growth Rate'), findsOneWidget);

//     // Check for the charts
//     expect(find.byType(LineChart), findsOneWidget);
//     expect(find.byType(PieChart), findsOneWidget);

//     // Simulate drawer opening
//     final scaffoldFinder = find.byType(Scaffold);
//     final ScaffoldState scaffoldState = tester.firstState(scaffoldFinder);
//     scaffoldState.openDrawer();
//     await tester.pumpAndSettle();

//     // Tap the 'Orders' drawer item
//     expect(find.text('Orders'), findsOneWidget);
//     await tester.tap(find.text('Orders'));
//     await tester.pumpAndSettle();

//     // Tap on one of the info cards
//     final cardFinder = find.text('Visits');
//     expect(cardFinder, findsOneWidget);
//     await tester.tap(cardFinder);
//     await tester.pumpAndSettle();

//     // Done
//   });
// }
