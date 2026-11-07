import 'package:flutter/material.dart';

class InspectionReportScreen extends StatelessWidget {
  final String id;
  const InspectionReportScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inspection $id')),
      body: Center(child: Text('Inspection report $id')),
    );
  }
}
