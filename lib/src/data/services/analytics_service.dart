import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:teardrop/src/shared/constants/analytics_events.dart';

class AnalyticsService {
  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logVideoStarted(String youtubeId) =>
      _analytics.logEvent(name: AnalyticsEvents.videoStarted, parameters: {
        'youtube_id': youtubeId,
      });

  Future<void> logVideoPaused(String youtubeId, int durationSec) =>
      _analytics.logEvent(name: AnalyticsEvents.videoPaused, parameters: {
        'youtube_id': youtubeId,
        'duration_sec': durationSec,
      });

  Future<void> logVideoCompleted(String youtubeId, int durationSec) =>
      _analytics.logEvent(name: AnalyticsEvents.videoCompleted, parameters: {
        'youtube_id': youtubeId,
        'duration_sec': durationSec,
      });

  Future<void> logVideoExited(String youtubeId, int durationSec) =>
      _analytics.logEvent(name: AnalyticsEvents.videoExited, parameters: {
        'youtube_id': youtubeId,
        'duration_sec': durationSec,
      });

  Future<void> logFeedbackSubmitted(
          String youtubeId, int tearRating, List<String> tags) =>
      _analytics.logEvent(name: AnalyticsEvents.feedbackSubmitted, parameters: {
        'youtube_id': youtubeId,
        'tear_rating': tearRating,
        'tags': tags.join(','),
      });

  Future<void> logFeedbackSkipped(String youtubeId) =>
      _analytics.logEvent(name: AnalyticsEvents.feedbackSkipped, parameters: {
        'youtube_id': youtubeId,
      });

  Future<void> logLinkSaved(String youtubeId) =>
      _analytics.logEvent(name: AnalyticsEvents.linkSaved, parameters: {
        'youtube_id': youtubeId,
      });

  Future<void> logLinkDeleted(String youtubeId) =>
      _analytics.logEvent(name: AnalyticsEvents.linkDeleted, parameters: {
        'youtube_id': youtubeId,
      });

  Future<void> logPresetOpened(String presetId) =>
      _analytics.logEvent(name: AnalyticsEvents.presetOpened, parameters: {
        'preset_id': presetId,
      });

  Future<void> logTabChanged(String tabName) =>
      _analytics.logEvent(name: AnalyticsEvents.tabChanged, parameters: {
        'tab_name': tabName,
      });

  Future<void> logProfileViewed() =>
      _analytics.logEvent(name: AnalyticsEvents.profileViewed);
}
