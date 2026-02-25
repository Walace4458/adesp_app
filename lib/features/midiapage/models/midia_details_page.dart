import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'midia_item.dart';
import 'package:flutter_application_1/features/midiapage/service/midia_actions_service.dart';

class MidiaDetailsPage extends StatefulWidget {
  final MidiaItem item;

  const MidiaDetailsPage({
    super.key,
    required this.item,
  });

  @override
  State<MidiaDetailsPage> createState() => _MidiaDetailsPageState();
}

class _MidiaDetailsPageState extends State<MidiaDetailsPage>
    with SingleTickerProviderStateMixin {
  bool _isOpening = false;
  late final AnimationController _watchFillCtrl;

@override
void initState() {
  super.initState();

  debugPrint(
    'DETAILS -> id=${widget.item.id} | title=${widget.item.title} | youtubeVideoId=${widget.item.youtubeVideoId}',
  );

  _watchFillCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
}

  @override
  void dispose() {
    _watchFillCtrl.dispose();
    super.dispose();
  }

  String get _videoId => widget.item.youtubeVideoId.trim();

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _onWatchPressed() async {
    final id = _videoId;

    if (id.isEmpty) {
      _snack('Vídeo ainda não configurado.');
      return;
    }

    setState(() => _isOpening = true);
    _watchFillCtrl
      ..reset()
      ..repeat(reverse: true); // fica mais bonito (vai e volta)

    try {
      final ok = await const MidiaActionsService().openVideo(id);
      if (!mounted) return;

      if (!ok) {
        _snack('Não foi possível abrir o vídeo.');
      }
    } catch (_) {
      if (mounted) _snack('Não foi possível abrir o vídeo.');
    } finally {
      if (!mounted) return;
      _watchFillCtrl.stop();
      _watchFillCtrl.reset();
      setState(() => _isOpening = false);
    }
  }

  Future<void> _shareVideo() async {
    final id = _videoId;

    if (id.isEmpty) {
      _snack('Vídeo ainda não configurado.');
      return;
    }

    final url = 'https://www.youtube.com/watch?v=$id';

    try {
      await SharePlus.instance.share(
        ShareParams(text: 'Assista: $url'),
      );
    } catch (_) {
      _snack('Não foi possível compartilhar.');
    }
  }

Widget _watchButton() {
  return SizedBox(
    height: 48,
    width: double.infinity,
    child: AnimatedBuilder(
      animation: _watchFillCtrl,
      builder: (context, _) {
        final fill = _isOpening ? _watchFillCtrl.value : 0.0;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.20), // borda fina
                width: 1,
              ),
              // “base” escura/transparente
              color: Colors.black.withOpacity(0.25),
            ),
            child: InkWell(
              onTap: _isOpening ? null : _onWatchPressed,
              child: Stack(
                children: [
                  // Barra roxa animada POR TRÁS
                  if (_isOpening)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: fill.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Conteúdo do botão
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isOpening ? 'Abrindo...' : 'Assistir',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_isOpening) ...[
                          const SizedBox(width: 10),
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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
                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child:
                            const Icon(Icons.broken_image_outlined, size: 40),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
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

                // BOTÃO ASSISTIR (custom com animação)
                _watchButton(),

                const SizedBox(height: 12),

                // BOTÃO COMPARTILHAR
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _shareVideo,
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