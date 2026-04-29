import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'utils/library_storage.dart';

void main() {
  runApp(const BookshelfApp());
}

class BookshelfApp extends StatelessWidget {
  const BookshelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LibraryStorage()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'My Bookshelf',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
