import 'package:flutter/material.dart';

import '../widgets/contribution_card.dart';

class ContributionPage extends StatelessWidget {
  const ContributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribuição"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Apoie este projeto 🙏",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Este aplicativo existe para levar a palavra de Deus "
              "a mais pessoas. Sua contribuição ajuda a manter "
              "o projeto ativo e em constante melhoria.",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 25),

            ContributionCard(
              title: "Café",
              price: "R\$5",
              description: "Ajude com um café para apoiar o projeto",
              icon: Icons.coffee,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecionado apoio Café ☕"),
                  ),
                );
              },
            ),

            ContributionCard(
              title: "Apoiar",
              price: "R\$10",
              description: "Contribuição para manter o app",
              icon: Icons.favorite,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecionado apoio 🙏"),
                  ),
                );
              },
            ),

            ContributionCard(
              title: "Sustentar",
              price: "R\$25",
              description: "Ajuda no desenvolvimento do aplicativo",
              icon: Icons.volunteer_activism,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecionado apoio 🔥"),
                  ),
                );
              },
            ),

            ContributionCard(
              title: "Parceiro",
              price: "R\$50",
              description: "Apoie fortemente o crescimento do projeto",
              icon: Icons.workspace_premium,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecionado apoio 💎"),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 15),

            const Text(
              "Ou contribua via PIX",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Chave PIX copiada"),
                  ),
                );
              },

              icon: const Icon(Icons.copy),
              label: const Text("Copiar chave PIX"),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Muito obrigado pelo seu apoio ❤️",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}