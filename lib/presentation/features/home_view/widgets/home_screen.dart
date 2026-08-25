

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('v.1.0.0'),
      ),
    );
  }
}