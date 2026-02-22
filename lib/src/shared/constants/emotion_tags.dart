class EmotionTags {
  static const String touching = '감동';
  static const String farewell = '이별';
  static const String animal = '동물';
  static const String family = '가족';
  static const String sacrifice = '희생';
  static const String music = '음악';
  static const String movie = '영화';
  static const String other = '기타';

  static const List<String> all = [
    touching,
    farewell,
    animal,
    family,
    sacrifice,
    music,
    movie,
    other,
  ];

  static String tearTypeLabel(String topTag) {
    switch (topTag) {
      case touching:
        return '감동형 울보';
      case farewell:
        return '이별형 울보';
      case animal:
        return '동물형 울보';
      case family:
        return '가족형 울보';
      case sacrifice:
        return '희생형 울보';
      case music:
        return '음악형 울보';
      case movie:
        return '영화형 울보';
      default:
        return '눈물 초보';
    }
  }

  static String tearTypeEmoji(String topTag) {
    switch (topTag) {
      case touching:
        return '🥹';
      case farewell:
        return '💔';
      case animal:
        return '🐾';
      case family:
        return '👨‍👩‍👧‍👦';
      case sacrifice:
        return '🫡';
      case music:
        return '🎵';
      case movie:
        return '🎬';
      default:
        return '💧';
    }
  }
}
