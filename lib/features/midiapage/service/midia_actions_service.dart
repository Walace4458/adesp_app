import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';


class MidiaActionsService {
  const MidiaActionsService();

  bool _isBlank(String? s) => s == null || s.trim().isEmpty;

  Uri? buildYoutubeWebUri(String? videoId) {
    if (_isBlank(videoId)) return null;
    final id = videoId!.trim();
    return Uri.parse('https://www.youtube.com/watch?v=$id');
  }

  Future<bool> openVideo(String? videoId) async {
    if (_isBlank(videoId)) return false;

    final id = videoId!.trim();

    final appUri = Uri.parse('vnd.youtube:$id');
    
    final webUri = Uri.parse('https://www.youtube.com/watch?v=$id');

    try {
      if (await canLaunchUrl(appUri)) {
        return await launchUrl(
          appUri,
          mode: LaunchMode.externalApplication,
        );
      }

      if (await canLaunchUrl(webUri)) {
        return await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }

      return false;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('openVideo eror: $e');
        debugPrint('$st');
      }
      return false;
    }
  }
}