import 'package:flutter/material.dart';

class TestimoniesPage extends StatelessWidget{
  const TestimoniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testemunhos"),
      ),
      body: const Center(
        child: Text("Testemunhos da comunidade"),
      ),
    );
  }
}