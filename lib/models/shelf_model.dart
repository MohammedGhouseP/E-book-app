import 'package:flutter/material.dart';
import 'book_model.dart';

class Shelf {
  final String id;
  final String name;
  final IconData icon;
  final List<Book> books;

  const Shelf({
    required this.id,
    required this.name,
    required this.icon,
    required this.books,
  });

  int get bookCount => books.length;
}
