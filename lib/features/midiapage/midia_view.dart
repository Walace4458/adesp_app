import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';
import 'package:flutter_application_1/features/midiapage/widget/midia_card.dart';
import 'package:flutter_application_1/features/notifications/models/empty_state.dart';

class MidiaView extends StatelessWidget {
  final bool isLoading;
  final List<MidiaItem> videos;

  const MidiaView({
    super.key,
    required this.isLoading,
    required this.videos,
  });

  List<MidiaItem> _byTag(MidiaTag tag) =>
      videos.where((v) => v.tags.contains(tag)).toList();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (videos.isEmpty) {
      return const EmptyState(
        icon: Icons.ondemand_video_rounded,
        title: 'Sem vídeos por aqui',
        subtitle: 'Quando a igreja publicar algo novo, vai aparecer aqui.',
      );
    }

    final featured = _byTag(MidiaTag.featured);
    final popular = _byTag(MidiaTag.popular);
    final continueWatching = _byTag(MidiaTag.continueWatching);
    final recents = videos; // todos são “recentes”

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        if (featured.isNotEmpty)
          _Section(
            title: 'Vídeos em destaque',
            height: 210,
            items: featured,
            cardVariant: MidiaCardVariant.featured,
          ),

        if (popular.isNotEmpty)
          _Section(
            title: 'Populares',
            height: 170,
            items: popular,
            cardVariant: MidiaCardVariant.normal,
          ),

        if (continueWatching.isNotEmpty)
          _Section(
            title: 'Continuar assistindo',
            height: 170,
            items: continueWatching,
            cardVariant: MidiaCardVariant.normal,
          ),

        _Section(
          title: 'Adicionados recentemente',
          height: 150,
          items: recents,
          cardVariant: MidiaCardVariant.compact,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final double height;
  final List<MidiaItem> items;
  final MidiaCardVariant cardVariant;

  const _Section({
    required this.title,
    required this.height,
    required this.items,
    required this.cardVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return MidiaCard(
                item: item,
                variant: cardVariant,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}