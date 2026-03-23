import 'package:flutter/material.dart';

import '../models/interested_model.dart';
import '../services/cell_service.dart';

class AddPersonPage extends StatefulWidget {
  final String cellId;

  const AddPersonPage({
    super.key,
    required this.cellId,
  });

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  InterestedStatus _status = InterestedStatus.novo;
  bool _isLoading = false;

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final person = InterestedModel(
      id: DateTime.now().toString(),
      name: _nameController.text.trim(),
      status: _status,
    );

    // 🔥 AGORA FUNCIONA
    CellService.addInterested(
      cellId: widget.cellId,
      interested: person,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Pessoa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Digite um nome";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<InterestedStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: InterestedStatus.novo,
                    child: Text("Novo"),
                  ),
                  DropdownMenuItem(
                    value: InterestedStatus.visitou,
                    child: Text("Visitou"),
                  ),
                  DropdownMenuItem(
                    value: InterestedStatus.membro,
                    child: Text("Membro"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}