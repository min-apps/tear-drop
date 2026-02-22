import 'package:flutter_test/flutter_test.dart';
import 'package:teardrop/src/shared/extensions/youtube_url_parser.dart';

void main() {
  group('YoutubeUrlParser', () {
    test('parses standard watch URL', () {
      expect(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });

    test('parses short URL', () {
      expect(
        'https://youtu.be/dQw4w9WgXcQ'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });

    test('parses shorts URL', () {
      expect(
        'https://youtube.com/shorts/dQw4w9WgXcQ'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });

    test('parses embed URL', () {
      expect(
        'https://www.youtube.com/embed/dQw4w9WgXcQ'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });

    test('parses mobile URL', () {
      expect(
        'https://m.youtube.com/watch?v=dQw4w9WgXcQ'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });

    test('accepts plain video ID', () {
      expect('dQw4w9WgXcQ'.extractYoutubeId(), 'dQw4w9WgXcQ');
    });

    test('handles ID with hyphens and underscores', () {
      expect('RgKAFK5djSk'.extractYoutubeId(), 'RgKAFK5djSk');
      expect('09R8_2nJtjg'.extractYoutubeId(), '09R8_2nJtjg');
    });

    test('returns null for invalid URL', () {
      expect('not-a-url'.extractYoutubeId(), isNull);
      expect('https://google.com'.extractYoutubeId(), isNull);
      expect(''.extractYoutubeId(), isNull);
    });

    test('returns null for wrong length ID', () {
      expect('short'.extractYoutubeId(), isNull);
      expect('waytoolongforavideoid'.extractYoutubeId(), isNull);
    });

    test('handles URL with extra params', () {
      expect(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=30'.extractYoutubeId(),
        'dQw4w9WgXcQ',
      );
    });
  });
}
