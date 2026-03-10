import 'package:flutter/material.dart';

class PrayerRequestsPage extends StatefulWidget{
  const PrayerRequestsPage ({super.key});

  @override
  State<PrayerRequestsPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestsPage> {
  final TextEditingController _controller = TextEditingController();

  bool anonymous = false;

  void submitPrayer() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva seu pedido de oração'),),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pedido enviado"),),
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pedidos de oração"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Seu pedido",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20,),

            CheckboxListTile(
              title: const Text("Enviar como anônimo"),
              value: anonymous,
              onChanged: (value) {
                setState(() {
                  anonymous = value ?? false;
                });
              },
              ),

              const SizedBox(height: 20,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitPrayer, 
                  child: const Text("Enviar Pedido"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}