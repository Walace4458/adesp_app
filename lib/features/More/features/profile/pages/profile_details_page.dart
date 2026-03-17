import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'edit_profile_page.dart';

class ProfileDetailsPage extends StatefulWidget {
  final UserProfile user;

  const ProfileDetailsPage({super.key, required this.user});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {

  UserProfile get user => widget.user;

  @override
  Widget build(BuildContext context) {
    final percent = (user.completion * 100).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text("Meu Perfil")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 🔥 HEADER BONITO
          Row(
            children: [

              CircleAvatar(
                radius: 30,
                backgroundImage: user.avatarPath != null
                    ? FileImage(File(user.avatarPath!))
                    : null,
                child: user.avatarPath == null
                    ? Text(
                        user.name?.isNotEmpty == true
                            ? user.name![0].toUpperCase()
                            : "?",
                        style: const TextStyle(fontSize: 20),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      user.name?.isNotEmpty == true
                          ? user.name!
                          : "Sem nome",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text("$percent% completo"),

                    const SizedBox(height: 6),

                    LinearProgressIndicator(value: user.completion),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔥 BOTÃO EDITAR
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(user: user),
                ),
              );

              setState(() {});
            },
            child: const Text("Editar perfil"),
          ),

          const SizedBox(height: 20),

          /// 🔥 OPÇÕES
          _tile("Minhas células", Icons.groups),
          _tile("Notificações", Icons.notifications),
          _tile("Grupos", Icons.group),
          _tile("Carteirinha", Icons.badge),
          _tile("Meus cartões", Icons.credit_card),

        ],
      ),
    );
  }

  Widget _tile(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title em breve")),
          );
        },
      ),
    );
  }
}