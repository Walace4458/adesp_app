import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/midia_view.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';
import 'package:flutter_application_1/features/midiapage/repository_video.dart';


class MidiaPage extends StatefulWidget {
  const MidiaPage({super.key});

  @override
  State<MidiaPage> createState() => _MidiaPageState();
}

class _MidiaPageState extends State<MidiaPage> {
  bool isLoading = true;
  List<MidiaItem> videos = [];

  final _repo = RepositoryVideo();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final result = await _repo.fetchVideos();
    setState(() {
      videos = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MidiaView(
        isLoading: isLoading,
        videos: videos,
      ),
    );
  }
}
