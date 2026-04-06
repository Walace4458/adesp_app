import 'package:flutter/material.dart';

class GabineteBottomSheet extends StatefulWidget {
  final Future<void> Function({
    required String name,
    required String phone,
    required String categoryId,
    required String note,
  }) onConfirm;

  final VoidCallback onCancel;

  const GabineteBottomSheet({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<GabineteBottomSheet> createState() => _GabineteBottomSheetState();
}

class _GabineteBottomSheetState extends State<GabineteBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();

  String? selectedCategory;

  final categories = [
    'Aconselhamento',
    'Oração',
    'Discipulado',
    'Família'
  ];

  bool isLoading = false;

  // =========================
  // 📱 FORMATA TELEFONE BR
  // =========================
  void _formatPhone(String value) {
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = numbers;

    if (numbers.length >= 2) {
      formatted = '(${numbers.substring(0, 2)})';
    }
    if (numbers.length >= 7) {
      formatted += ' ${numbers.substring(2, 7)}';
    }
    if (numbers.length >= 11) {
      formatted += '-${numbers.substring(7, 11)}';
    }

    phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =========================
              // HANDLE
              // =========================
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Agendar Gabinete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // NOME
              // =========================
              _input(
                controller: nameController,
                label: 'Nome completo',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Obrigatório';
                  }
                  if (v.trim().length < 3) {
                    return 'Nome muito curto';
                  }
                  return null;
                },
              ),

              // =========================
              // TELEFONE
              // =========================
              _input(
                controller: phoneController,
                label: 'Telefone (WhatsApp)',
                keyboardType: TextInputType.phone,
                onChanged: _formatPhone,
                validator: (v) {
                  if (v == null || v.length < 14) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),

              // =========================
              // CATEGORIA
              // =========================
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white),
                  value: selectedCategory,
                  items: categories
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v),
                  decoration: _decoration('Motivo'),
                  validator: (v) =>
                      v == null ? 'Selecione um motivo' : null,
                ),
              ),

              // =========================
              // RESUMO
              // =========================
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: noteController,
                  maxLength: 500,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Resumo').copyWith(
                    hintText: 'Descreva brevemente...',
                    hintStyle:
                        const TextStyle(color: Colors.white38),
                    counterStyle:
                        const TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // =========================
              // BOTÃO CONFIRMAR
              // =========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          await widget.onConfirm(
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            categoryId: selectedCategory!,
                            note: noteController.text.trim(),
                          );

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Confirmar'),
                ),
              ),

              // =========================
              // CANCELAR
              // =========================
              TextButton(
                onPressed: () {
                  widget.onCancel();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT PADRÃO
  // =========================
  Widget _input({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration(label),
        validator: validator,
      ),
    );
  }

  // =========================
  // DECORATION PADRÃO
  // =========================
  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}