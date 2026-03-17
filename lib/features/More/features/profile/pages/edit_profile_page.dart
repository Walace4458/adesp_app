import 'package:flutter/material.dart';
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

  // 🧑 DADOS BÁSICOS
  void _openBasicData(BuildContext context) {
    final nameController = TextEditingController(text: user.name);
    final birthController = TextEditingController(text: user.birthDate);
    String gender = user.gender ?? "Masculino";

    _openSheet(
      context,
      title: "Dados básicos",
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Nome completo"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: birthController,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(labelText: "Data de nascimento"),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: gender,
          items: ["Masculino", "Feminino"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            gender = value!;
          },
          decoration: const InputDecoration(labelText: "Gênero"),
        ),
      ],
      onSave: () async {
        user.name = nameController.text;
        user.birthDate = birthController.text;
        user.gender = gender;

        await ProfileService.save(user);

        setState(() {});
      },
    );
  }

  // 📞 CONTATO
  void _openContact(BuildContext context) {
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);

    _openSheet(
      context,
      title: "Contato",
      children: [
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Telefone"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email"),
        ),
      ],
      onSave: () async {
        user.phone = phoneController.text;
        user.email = emailController.text;

        await ProfileService.save(user);

        setState(() {});
      },
    );
  }

  // ⛪ IGREJA
  void _openChurch(BuildContext context) {
    final churchController = TextEditingController(text: user.church);
    final ministryController = TextEditingController(text: user.ministry);

    _openSheet(
      context,
      title: "Igreja",
      children: [
        TextField(
          controller: churchController,
          decoration: const InputDecoration(labelText: "Nome da igreja"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: ministryController,
          decoration: const InputDecoration(labelText: "Ministério"),
        ),
      ],
      onSave: () async {
        user.church = churchController.text;
        user.ministry = ministryController.text;

        await ProfileService.save(user);

        setState(() {});
      },
    );
  }

  // ⭐ OPCIONAL
  void _openOptional(BuildContext context) {
    final cpfController = TextEditingController(text: user.cpf);
    final rgController = TextEditingController(text: user.rg);

    _openSheet(
      context,
      title: "Opcional",
      children: [
        TextField(
          controller: cpfController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "CPF"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: rgController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "RG"),
        ),
      ],
      onSave: () async {
        user.cpf = cpfController.text;
        user.rg = rgController.text;

        await ProfileService.save(user);

        setState(() {});
      },
    );
  }

  // 🧱 BASE REUTILIZÁVEL
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar $title",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
              ...children,
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await onSave();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        );
      },
    );
  }
}