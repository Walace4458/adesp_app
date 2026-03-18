import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserProfile get user => widget.user;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard("Dados básicos", context),
          _buildCard("Contato", context),
          _buildCard("Igreja", context),
          _buildCard("Opcional", context),
        ],
      ),
    );
  }

  Widget _buildCard(String title, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_rounded),
        onTap: () {
          switch (title) {
            case "Dados básicos":
              _openBasicData(context);
              break;
            case "Contato":
              _openContact(context);
              break;
            case "Igreja":
              _openChurch(context);
              break;
            case "Opcional":
              _openOptional(context);
              break;
          }
        },
      ),
    );
  }

  /// DADOS BÁSICOS
  void _openBasicData(BuildContext context) {
    final nameController = TextEditingController(text: user.name);
    final birthController = TextEditingController(text: user.birthDate);
    String gender = user.gender ?? "Masculino";

    _openSheet(
      context,
      title: "Dados básicos",
      children: [
        TextFormField(
          controller: nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(labelText: "Nome completo"),
          validator: (value) =>
              value == null || value.isEmpty ? "Nome obrigatório" : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: birthController,
          inputFormatters: [dateMask],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(labelText: "Data de nascimento"),
          validator: (value) =>
              value == null || value.isEmpty ? "Data obrigatória" : null,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: gender,
          items: ["Masculino", "Feminino"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => gender = value!,
          decoration: const InputDecoration(labelText: "Gênero"),
        ),
      ],
      onSave: () async {
        user.name = nameController.text;
        user.birthDate = birthController.text;
        user.gender = gender;

        await ProfileService.save(user);
      },
    );
  }

  /// CONTATO
  void _openContact(BuildContext context) {
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);

    _openSheet(
      context,
      title: "Contato",
      children: [
        TextFormField(
          controller: phoneController,
          inputFormatters: [phoneMask],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Telefone"),
          validator: (value) =>
              value == null || value.length < 14 ? "Telefone inválido" : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email"),
          validator: (value) {
            if (value == null || value.isEmpty) return "Email obrigatório";
            if (!value.contains("@")) return "Email inválido";
            return null;
          },
        ),
      ],
      onSave: () async {
        user.phone = phoneController.text;
        user.email = emailController.text;

        await ProfileService.save(user);
      },
    );
  }

  /// IGREJA
  void _openChurch(BuildContext context) {
    final churchController = TextEditingController(text: user.church);
    final ministryController = TextEditingController(text: user.ministry);

    _openSheet(
      context,
      title: "Igreja",
      children: [
        TextFormField(
          controller: churchController,
          decoration: const InputDecoration(labelText: "Nome da igreja"),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: ministryController,
          decoration: const InputDecoration(labelText: "Ministério"),
        ),
      ],
      onSave: () async {
        user.church = churchController.text;
        user.ministry = ministryController.text;

        await ProfileService.save(user);
      },
    );
  }

  /// OPCIONAL
  void _openOptional(BuildContext context) {
    final cpfController = TextEditingController(text: user.cpf);
    final rgController = TextEditingController(text: user.rg);

    _openSheet(
      context,
      title: "Opcional",
      children: [
        TextFormField(
          controller: cpfController,
          inputFormatters: [cpfMask],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "CPF"),
          validator: (value) {
            if (value == null || value.isEmpty) return "CPF obrigatório";
            if (!isValidCPF(value)) return "CPF inválido";
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: rgController,
          decoration: const InputDecoration(labelText: "RG"),
        ),
      ],
      onSave: () async {
        user.cpf = cpfController.text;
        user.rg = rgController.text;

        await ProfileService.save(user);
      },
    );
  }

  /// BASE COM UX PROFISSIONAL
  void _openSheet(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required Future<void> Function() onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Editar $title",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 15),
                ...children,
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          await onSave();

                          if (context.mounted) {
                            setState(() => isLoading = false);
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Perfil atualizado com sucesso!"),
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Salvar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// CPF VALIDATION (CORRIGIDO)
  bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }

    int firstDigit = (sum * 10) % 11;
    if (firstDigit == 10) firstDigit = 0;

    if (firstDigit != int.parse(cpf[9])) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }

    int secondDigit = (sum * 10) % 11;
    if (secondDigit == 10) secondDigit = 0;

    return secondDigit == int.parse(cpf[10]);
  }
}