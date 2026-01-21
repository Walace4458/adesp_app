import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Aprendendo Flutter'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
            Text("eu te amo"),
            Text("muito samara"),
            Card(child: Text("vou melhorar e te mostrar que sou capaz <3"))
            ]
          ),
        ),
      );
  }
}