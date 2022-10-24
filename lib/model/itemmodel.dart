import 'package:flutter/material.dart';

class Item {
  final String title;
  final Color color;
  final List<Item>? subsection;

  Item({required this.color, required this.title, this.subsection});
}
