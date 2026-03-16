import 'package:flutter/material.dart';

class SubmitTestimonyPage extends StatefulWidget {
  const SubmitTestimonyPage({super.key});

  @override
  State<SubmitTestimonyPage> createState() => _SubmitTestimonyPageState();
}

class _SubmitTestimonyPageState extends State<SubmitTestimonyPage> {
  final nameController = TextEditingController();
  final testimonyController = TextEditingController();

  bool anonymous = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Testemunho"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// Campo nome
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Seu nome",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// Campo testemunho
            TextField(
              controller: testimonyController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Seu testemunho",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Checkbox anônimo
            CheckboxListTile(
              title: const Text("Enviar como anônimo"),
              value: anonymous,
              onChanged: (value) {
                setState(() {
                  anonymous = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 16),

            /// Botão enviar
            ElevatedButton(
              onPressed: () {

                final name = anonymous
                    ? "Anônimo"
                    : nameController.text.trim();

                final message = testimonyController.text.trim();

                if (name.isEmpty || message.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Preencha todos os campos"),
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Testemunho enviado!"),
                  ),
                );

                Navigator.pop(context);
              },

              child: const Text("Enviar"),
            )
          ],
        ),
      ),
    );
  }
}