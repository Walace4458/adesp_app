import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';

class RepositoryVideo {
  Future<List<MidiaItem>> fetchVideos() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      MidiaItem(
        id: '1',
        title: 'Video 1',
        thumbnail: 'https://img.youtube.com/vi/4WnieZDA-Vg/maxresdefault.jpg',
        subtitle: 'Video Culto',
        tags: {MidiaTag.featured},
        youtubeVideoId: 'dQw4w9WgXcQ'
      ),
      MidiaItem(
        id: '2',
        title: 'Video 2',
        thumbnail: 'https://picsum.photos/536/354',
        subtitle: 'Video Evento',
        tags: {MidiaTag.featured, MidiaTag.popular},
        youtubeVideoId: 'W-xU4XnsDB8'
      ),
      MidiaItem(
        id: '3',
        title: 'Video 3',
        thumbnail: 'https://picsum.photos/536/354',
        subtitle: 'Video naipe',
        tags: {MidiaTag.featured, MidiaTag.popular},
        youtubeVideoId: 'QSXpy49xLH4'
      ),
    ];
  }
}