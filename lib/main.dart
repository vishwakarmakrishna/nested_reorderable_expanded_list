import 'package:flutter/material.dart';
import 'views/all_section_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '@ig_krishnakumar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AllSections(title: 'Nested Reorderable Expandable List'),
    );
  }
}
