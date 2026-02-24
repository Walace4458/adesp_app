import 'package:flutter/material.dart';

class MidiaPlayerView extends StatelessWidget {
  final bool isPlaying;
  final String thumbnailUrl;
  final Widget player;

  final VoidCallback onPlay;  // botão grande no preview
  final VoidCallback onWatch; // botão "Assistir"
  final VoidCallback onShare; // compartilhar

  final String title;
  final String subtitle;

  const MidiaPlayerView({
    super.key,
    required this.isPlaying,
    required this.thumbnailUrl,
    required this.player,
    required this.onPlay,
    required this.onWatch,
    required this.onShare,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos o que vai no topo (Vídeo ou Preview)
    final Widget topMedia = isPlaying
        ? player
        : _Preview(
            thumbnailUrl: thumbnailUrl,
            onPlay: onPlay,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
        actions: [
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        // Removi o SizedBox com altura travada que causava o overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ÁREA DO PLAYER / PREVIEW
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  // LayoutBuilder aqui garante que o player só carregue com tamanho válido
                  child: LayoutBuilder(
                    builder: (context, ctrs) {
                      if (ctrs.maxWidth < 10) return const SizedBox.shrink();
                      return topMedia;
                    },
                  ),
                ),
              ),
            ),

            // ÁREA DE TEXTO E BOTÕES (Rolável para evitar overflow)
            Expanded(
              child: ListView(
                // Use Physics para o scroll ser suave
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onWatch,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Assistir'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onShare,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Compartilhar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final String thumbnailUrl;
  final VoidCallback onPlay;

  const _Preview({
    required this.thumbnailUrl,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Adicionei um placeholder para caso a imagem demore a carregar
        Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.black12,
            child: const Icon(Icons.error),
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
        ),
        Center(
          child: IconButton(
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
            ),
            iconSize: 72,
          ),
        ),
      ],
    );
  }
}