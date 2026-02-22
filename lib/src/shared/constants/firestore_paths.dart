class FirestorePaths {
  static String user(String uid) => 'users/$uid';
  static String savedLinks(String uid) => 'users/$uid/saved_links';
  static String savedLink(String uid, String linkId) =>
      'users/$uid/saved_links/$linkId';
  static String reactions(String uid) => 'users/$uid/reactions';
  static String reaction(String uid, String reactionId) =>
      'users/$uid/reactions/$reactionId';
  static String videoStats(String youtubeId) => 'video_stats/$youtubeId';
}
