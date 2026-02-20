import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/midia_view.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';
import 'package:flutter_application_1/features/midiapage/repository_video.dart';
import 'package:flutter_application_1/features/notifications/models/empty_state.dart';

enum MidiaFilter { all, recents, featured, popular, continueWatching }

class MidiaPage extends StatefulWidget {
  final MidiaFilter filter;

  const MidiaPage({super.key, required this.filter});

  @override
  State<MidiaPage> createState() => _MidiaPageState();
}

class _MidiaPageState extends State<MidiaPage> {
  bool isLoading = true;
  List<MidiaItem> videos = [];

  final _repo = RepositoryVideo();

  List<MidiaItem> get _filteredVideos {
    switch (widget.filter) {
      case MidiaFilter.all:
      case MidiaFilter.recents:
        return videos;

      case MidiaFilter.featured:
        return videos.where((v) => v.tags.contains(MidiaTag.featured)).toList();

      case MidiaFilter.popular:
        return videos.where((v) => v.tags.contains(MidiaTag.popular)).toList();

      case MidiaFilter.continueWatching:
        return videos
            .where((v) => v.tags.contains(MidiaTag.continueWatching))
            .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final result = await _repo.fetchVideos();

    if (!mounted) return; // <- evita setState depois que saiu da tela

    setState(() {
      videos = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1) loading: deixa o MidiaView mostrar o loader
    if (isLoading) {
      return Scaffold(
        body: MidiaView(
          isLoading: true,
          videos: const [],
          filter: widget.filter,
        ),
      );
    }

    // 2) carregou: se o filtro não tem nada, mostra EmptyState "Nada por aqui"
    final filtered = _filteredVideos;

    if (filtered.isEmpty) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.ondemand_video_rounded,
          title: 'Nada por aqui',
          subtitle: 'Esse filtro não tem vídeos no momento.',
        ),
      );
    }

    // 3) caso normal
    return Scaffold(
      body: MidiaView(
        isLoading: false,
        videos: filtered,
        filter: widget.filter,
      ),
    );
  }
}