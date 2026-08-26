
import 'package:flutter/material.dart';

class CrudPackplan extends StatelessWidget {
  const CrudPackplan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create/Update Pack Plan'),
      ),
      body: const Center(
        child: Text('CRUD operations for Pack Plan will be here'),
      ),
    );
  }
}