import 'package:flutter/material.dart';

class ContribuationPage extends StatelessWidget{
  const ContribuationPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribuição"),
      ),
      body: const Center(
        child: Text("Aqui você pode doar, ou dizimar!"),
      ),
    );
  }
}