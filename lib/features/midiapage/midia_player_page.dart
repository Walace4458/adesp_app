import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:share_plus/share_plus.dart';

class MidiaPlayerPage extends StatefulWidget {
  final MidiaItem item;

  const MidiaPlayerPage({
    super.key,
    required this.item,
  });

  @override
  State<MidiaPlayerPage> createState() => _MidiaPlayerPageState();
}

class _MidiaPlayerPageState extends State<MidiaPlayerPage> {
 bool _isPlaying = false;

Future<void> _onShare() async {
  final url = 'https://www.youtube.com/watch?v=${widget.item.youtubeVideoId}';

  await SharePlus.instance.share(
    ShareParams(
      text: 'Assista: $url',
    ),
  );
}


 late final YoutubePlayerController _controller;
 @override
 void initState() {
  super.initState();
  _controller = YoutubePlayerController.fromVideoId(
    videoId: widget.item.youtubeVideoId,
    autoPlay: true,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      showControls: true,
      playsInline: true,
    ),
    );
 }

 @override
void dispose(){
  _controller.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _isPlaying
                    ? YoutubePlayer(
                      controller: _controller,
                    ):
                  Stack (
                    children: [
                      Image.network(
                        widget.item.thumbnail,
                        fit: BoxFit.cover,
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
                      Positioned.fill(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPlaying = true;
                              });
                            },
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                            ),
                            iconSize: 72,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    widget.item.title,
                    style: Theme.of(context).textTheme.titleMedium
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!_isPlaying) {
                              setState(() => _isPlaying = true);
                            }
                            _controller.enterFullScreen();
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Assisitr'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _onShare,
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