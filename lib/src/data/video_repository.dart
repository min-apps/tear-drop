/// Mock data repository for sad YouTube Shorts.
/// Replace these IDs with actual sad/emotional Shorts for production.
class VideoRepository {
  static const List<String> sadShortsIds = [
    'RgKAFK5djSk', // See You Again - Wiz Khalifa (emotional)
    'YQHsXMglC9A', // Hello - Adele (emotional)
    '09R8_2nJtjg', // Encore - Eminem (emotional)
    'fJ9rUzIMcZQ', // Bohemian Rhapsody - Queen (emotional)
    'LPn0K6bqjLM', // Additional emotional content
  ];

  /// Returns the list of sad YouTube Shorts video IDs.
  static List<String> getSadShortsIds() => List.from(sadShortsIds);

  /// Returns thumbnail URL for a video ID (for blurred background).
  static String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  /// Fallback thumbnail (hqdefault) when maxresdefault may not exist.
  static String getThumbnailUrlFallback(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
