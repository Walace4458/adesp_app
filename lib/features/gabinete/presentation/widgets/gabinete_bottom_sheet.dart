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
  // 📱 FORMATADOR TELEFONE
  // =========================
  void _formatPhone(String value) {
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    final limited =
        numbers.length > 11 ? numbers.substring(0, 11) : numbers;

    String formatted = '';

    if (limited.isNotEmpty) formatted += '(';

    if (limited.length >= 2) {
      formatted += '${limited.substring(0, 2)}) ';
    } else {
      formatted += limited;
    }

    if (limited.length > 2) {
      if (limited.length >= 7) {
        formatted += limited.substring(2, 7);
      } else {
        formatted += limited.substring(2);
      }
    }

    if (limited.length >= 8) {
      formatted += '-${limited.substring(7)}';
    }

    phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 🔥 FIXA ALTURA
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // HANDLE
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

            // 🔥 SCROLL CONTROLADO
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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

                      _input(
                        controller: phoneController,
                        label: 'Telefone (WhatsApp)',
                        keyboardType: TextInputType.phone,
                        onChanged: _formatPhone,
                        validator: (v) {
                          if (v == null || v.length < 15) {
                            return 'Telefone inválido';
                          }
                          return null;
                        },
                      ),

                      // 🔥 DROPDOWN CORRIGIDO
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DropdownButtonFormField<String>(
                          onTap: () {
                            FocusScope.of(context).unfocus(); // 🔥 FECHA TECLADO
                          },
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
                          onChanged: (v) =>
                              setState(() => selectedCategory = v),
                          decoration: _decoration('Motivo'),
                          validator: (v) =>
                              v == null ? 'Selecione um motivo' : null,
                        ),
                      ),

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
                                const TextStyle(color: Colors.white54),
                            counterStyle:
                                const TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO FIXO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
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
                          setState(() => isLoading = false);
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirmar'),
              ),
            ),

            TextButton(
              onPressed: isLoading ? null : widget.onCancel,
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}