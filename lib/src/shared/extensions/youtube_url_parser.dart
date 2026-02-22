extension YoutubeUrlParser on String {
  /// Extracts a YouTube video ID from various URL formats.
  /// Returns null if the string is not a valid YouTube URL or ID.
  ///
  /// Supports:
  /// - https://www.youtube.com/watch?v=VIDEO_ID
  /// - https://youtu.be/VIDEO_ID
  /// - https://youtube.com/shorts/VIDEO_ID
  /// - https://www.youtube.com/embed/VIDEO_ID
  /// - https://m.youtube.com/watch?v=VIDEO_ID
  /// - Plain video ID (11 characters, alphanumeric + - + _)
  String? extractYoutubeId() {
    // Already a plain video ID
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trim())) {
      return trim();
    }

    final uri = Uri.tryParse(trim());
    if (uri == null) return null;

    // youtu.be/VIDEO_ID
    if (uri.host == 'youtu.be' || uri.host == 'www.youtu.be') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      return _validateId(id);
    }

    // youtube.com variants
    if (uri.host.contains('youtube.com')) {
      // /watch?v=VIDEO_ID
      if (uri.queryParameters.containsKey('v')) {
        return _validateId(uri.queryParameters['v']);
      }

      // /shorts/VIDEO_ID, /embed/VIDEO_ID, /v/VIDEO_ID
      if (uri.pathSegments.length >= 2) {
        final type = uri.pathSegments[0];
        if (type == 'shorts' || type == 'embed' || type == 'v') {
          return _validateId(uri.pathSegments[1]);
        }
      }
    }

    return null;
  }

  static String? _validateId(String? id) {
    if (id == null) return null;
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(id)) return id;
    return null;
  }
}
