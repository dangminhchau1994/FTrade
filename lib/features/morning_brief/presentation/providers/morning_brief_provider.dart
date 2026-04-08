import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/morning_brief_datasource.dart';
import '../../data/models/morning_brief.dart';

final _datasource = MorningBriefDatasource();

final morningBriefProvider = FutureProvider<MorningBrief?>((ref) async {
  try {
    final brief = await _datasource.fetchBrief();
    debugPrint('📰 Morning brief fetched: ${brief?.date ?? "null"}');
    return brief;
  } catch (e, st) {
    debugPrint('📰 Morning brief fetch failed: $e');
    debugPrint('📰 Stack: $st');
    // Network failed — return cached
    return _datasource.getCachedBrief();
  }
});

// ── Feedback (Epic 3) ──

/// Tracks feedback state per brief date: { sectorId: isAccurate }
final feedbackProvider =
    StateNotifierProvider.family<FeedbackNotifier, Map<String, bool>, String>(
  (ref, briefDate) => FeedbackNotifier(briefDate, _datasource),
);

class FeedbackNotifier extends StateNotifier<Map<String, bool>> {
  final String briefDate;
  final MorningBriefDatasource _ds;

  FeedbackNotifier(this.briefDate, this._ds) : super({}) {
    _loadCached();
  }

  Future<void> _loadCached() async {
    final cached = await _ds.getFeedbacksForBrief(briefDate);
    if (mounted) state = cached;
  }

  Future<void> submit(String sectorId, bool isAccurate) async {
    state = {...state, sectorId: isAccurate};
    await _ds.submitFeedback(
      briefDate: briefDate,
      sectorId: sectorId,
      isAccurate: isAccurate,
    );
  }
}
