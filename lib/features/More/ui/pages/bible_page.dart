import 'package:flutter/material.dart';

class BiblePage extends StatelessWidget{
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bíblia"),
      ),
      body: const Center(
        child: Text("Leitura da bíblia"),
      ),
    );
  }
}