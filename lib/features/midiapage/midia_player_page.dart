import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:share_plus/share_plus.dart';

import 'midia_player_view.dart'; // ajuste o caminho conforme sua pasta

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
  late final YoutubePlayerController _controller;

  bool get _hasDashInId => widget.item.youtubeVideoId.contains('-');

  Future<void> _startVideoWithFallback() async {
  final id = widget.item.youtubeVideoId;

  // garante que o player já foi montado no widget tree
  await WidgetsBinding.instance.endOfFrame;

  if (_hasDashInId) {
    // força o carregamento do vídeo pelo ID antes de tocar
    await _controller.cueVideoById(videoId: id);
  }

  await _controller.playVideo();
}

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.item.youtubeVideoId,
      autoPlay: false, // <- importante quando você começa mostrando preview
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
        playsInline: true,
        enableJavaScript: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

void _handlePlay() {
  if (_isPlaying) return;
  setState(() => _isPlaying = true);
  _startVideoWithFallback();
}

void _handleWatch() {
  if (!_isPlaying) {
    setState(() => _isPlaying = true);
    _startVideoWithFallback();
  }
  _controller.enterFullScreen();
}

  Future<void> _onShare() async {
    final url = 'https://www.youtube.com/watch?v=${widget.item.youtubeVideoId}';
    await SharePlus.instance.share(
      ShareParams(text: 'Assista: $url'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      // não coloque aspectRatio aqui porque sua View já usa AspectRatio(16/9)
      builder: (context, player) {
        return MidiaPlayerView(
          isPlaying: _isPlaying,
          thumbnailUrl: widget.item.thumbnail,
          player: player, // <- vem pronto do scaffold
          onPlay: _handlePlay,
          onWatch: _handleWatch,
          onShare: _onShare,
          title: widget.item.title,
          subtitle: widget.item.subtitle,
        );
      },
    );
  }
}