import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String id;
  const PropertyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Property $id')),
      body: Center(child: Text('Property details for $id')),
    );
  }
}
