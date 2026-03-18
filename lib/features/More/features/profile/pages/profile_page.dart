import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/More/features/cells/pages/my_cells_page.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  UserProfile user = UserProfile();
  bool isLoading = true;
  bool showData = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await ProfileService.load();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        actions: [

          // 👁️ BOTÃO COM ANIMAÇÃO
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                showData ? Icons.visibility_off : Icons.visibility,
                key: ValueKey(showData),
              ),
            ),
            onPressed: () {
              setState(() {
                showData = !showData;
              });
            },
          ),

          // ✏️ EDITAR
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(user: user),
                ),
              );

              await loadUser();
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          _buildHeader(),

          const SizedBox(height: 10),

          _buildActions(),

          const SizedBox(height: 10),

          // 🔥 ÁREA ANIMADA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },

                child: showData
                    ? Column(
                        key: const ValueKey("dados"),
                        children: [
                          _buildSection("Dados Básicos", [
                            _item("Nome", user.name),
                            _item("Nascimento", user.birthDate),
                            _item("Gênero", user.gender),
                          ]),

                          _buildSection("Contato", [
                            _item("Telefone", user.phone),
                            _item("Email", user.email),
                          ]),

                          _buildSection("Igreja", [
                            _item("Igreja", user.church),
                            _item("Ministério", user.ministry),
                          ]),

                          _buildSection("Documentos", [
                            _item("CPF", user.cpf),
                            _item("RG", user.rg),
                          ]),
                        ],
                      )
                    : const SizedBox(
                        key: ValueKey("vazio"),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 140,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),

        Column(
          children: [
            const SizedBox(height: 60),

            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user.avatarPath != null
                    ? AssetImage(user.avatarPath!)
                    : null,
                child: user.avatarPath == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user.name?.isNotEmpty == true ? user.name! : "Sem nome",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              user.email ?? "-",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  /// AÇÕES
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _actionItem(Icons.groups, "Minhas Células", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyCellsPage(),
              ),
            );
          }),
          _actionItem(Icons.event, "Meus Eventos", () {
            print("Ir para eventos");
          }),
          _actionItem(Icons.favorite, "Ministério", () {
            print("Ir para ministério");
          }),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  /// SEÇÃO
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  /// ITEM
  Widget _item(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}