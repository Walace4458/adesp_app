import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_details_page.dart';
import '../widgets/profile_avatar.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 UserProfile user = UserProfile();

    @override
    void initState() {
      super.initState();
      loadUser();
    }

    Future<void> loadUser() async {
      user = await ProfileService.load();
      setState(() {});
    }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        user.avatarPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (user.completion * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 👤 Avatar
            ProfileAvatar(
              imagePath: user.avatarPath,
              name: user.name ?? "",
              onTap: pickImage,
            ),

            const SizedBox(height: 12),

            /// 🧑 Nome
            Text(
              user.name == null || user.name!.isEmpty
                  ? "Sem nome"
                  : user.name!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// 📊 Porcentagem
            Text(
              "$percent% completo",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 6),

            LinearProgressIndicator(
              value: user.completion,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 25),

            /// 🔘 Botão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileDetailsPage(user: user),
                    ),
                  );

                  // 🔥 ISSO AQUI É O MAIS IMPORTANTE
                  setState(() {});
                },
                child: const Text("Ver meu perfil"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}