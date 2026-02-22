import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teardrop/src/data/repositories/saved_link_repository.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/shared/extensions/youtube_url_parser.dart';
import 'package:teardrop/src/theme.dart';

class AddLinkSheet extends ConsumerStatefulWidget {
  const AddLinkSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddLinkSheet(),
    );
  }

  @override
  ConsumerState<AddLinkSheet> createState() => _AddLinkSheetState();
}

class _AddLinkSheetState extends ConsumerState<AddLinkSheet> {
  final _controller = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    final videoId = text.extractYoutubeId();
    if (videoId == null) {
      setState(() => _error = '유효한 YouTube URL을 입력해주세요');
      return;
    }

    setState(() {
      _error = null;
      _saving = true;
    });

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;
      await SavedLinkRepository().addLink(
        uid: user.uid,
        youtubeId: videoId,
      );
      try {
        AnalyticsService().logLinkSaved(videoId);
      } catch (_) {}
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _error = '저장 실패: $e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'YouTube 링크 추가',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TearDropTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'YouTube URL 붙여넣기',
              errorText: _error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('저장'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
