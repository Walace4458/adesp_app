import 'package:flutter/material.dart';

Future<void> openAddPersonModal({
  required BuildContext context,
  required Function(String name) onAdd,
}) async {
  final controller = TextEditingController();

  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Adicionar pessoa"),

            const SizedBox(height: 10,),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Digite o nome",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;

                  onAdd(name);
                  Navigator.pop(context);
                },
                child: const Text("Adicionar"),
              ),
            )
          ],
        ),
      );
    }
  );
}