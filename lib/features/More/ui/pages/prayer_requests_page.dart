import 'package:flutter/material.dart';

class PrayerRequestsPage extends StatelessWidget{
  const PrayerRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos de oração"),
      ),
      body: const Center(
        child: Text("Enviar pedido de oração"),
      ),
    );
  }
}