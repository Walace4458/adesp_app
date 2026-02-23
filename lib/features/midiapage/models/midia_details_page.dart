import "package:flutter/material.dart";
import "package:flutter_application_1/features/midiapage/midia_player_page.dart";
import "midia_item.dart";

class MidiaDetailsPage extends StatelessWidget {
  final MidiaItem item;

  const MidiaDetailsPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // IMAGEM + GRADIENTE
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    item.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TEXTO E BOTÕES
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final id = item.youtubeVideoId.trim();
                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vídeo ainda não configurado.')),
                        );
                        return;
                      }
                      
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (_) => MidiaPlayerPage(item: item,))
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Assistir'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Compartilhar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}