import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ebook_app/main.dart';

void main() {
  testWidgets('Bookshelf App smoke test', (WidgetTester tester) async {
    // 1. Mock the device storage so our ThemeProvider and LibraryStorage don't crash
    SharedPreferences.setMockInitialValues({});

    // 2. Build our app and trigger a frame using the correct class name
    await tester.pumpWidget(const BookshelfApp());

    // 3. Wait for the mocked SharedPreferences to finish loading and UI to settle
    await tester.pumpAndSettle();

    // 4. Verify that our Home Screen has rendered successfully
    // We expect to find the App Bar title and the greeting text
    expect(find.text('My Bookshelf'), findsWidgets);
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Reader'), findsOneWidget);

    // 5. Verify that the Counter App elements are officially gone
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}