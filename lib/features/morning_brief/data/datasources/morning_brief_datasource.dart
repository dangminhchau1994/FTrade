import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/morning_brief.dart';

const _cacheBoxName = 'morning_brief_cache';
const _feedbackBoxName = 'feedback_cache';
const _maxCachedDays = 7;

class MorningBriefDatasource {
  final Dio _dio;

  MorningBriefDatasource({Dio? dio}) : _dio = dio ?? Dio();

  Future<String> _idToken() async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('📰 currentUser: ${user?.uid}');
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();
    return token ?? (throw Exception('Failed to get ID token'));
  }

  Future<MorningBrief?> fetchBrief({String? date}) async {
    final token = await _idToken();
    final url = '${AppConstants.functionsBaseUrl}/morningBriefs';
    debugPrint('📰 Fetching brief from: $url');

    final response = await _dio.get<Map<String, dynamic>>(
      url,
      queryParameters: date != null ? {'date': date} : null,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    debugPrint('📰 Response: ${response.statusCode} ${response.data}');

    if (response.data?['success'] == true && response.data?['data'] != null) {
      final brief = MorningBrief.fromJson(response.data!['data'] as Map<String, dynamic>);
      await _saveToCache(brief);
      return brief;
    }
    return null;
  }

  Future<MorningBrief?> getCachedBrief() async {
    final box = await _openBox();
    if (box.isEmpty) return null;

    final keys = box.keys.cast<String>().toList()..sort();
    final latestKey = keys.last;
    final raw = box.get(latestKey) as String?;
    if (raw == null) return null;

    return MorningBrief.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _saveToCache(MorningBrief brief) async {
    final box = await _openBox();
    await box.put(brief.date, jsonEncode(brief.toJson()));

    // Evict oldest if over limit
    if (box.length > _maxCachedDays) {
      final keys = box.keys.cast<String>().toList()..sort();
      for (var i = 0; i < box.length - _maxCachedDays; i++) {
        await box.delete(keys[i]);
      }
    }
  }

  Future<Box> _openBox() => Hive.openBox(_cacheBoxName);

  // ── Feedback (Epic 3) ──

  /// Submit feedback for a sector prediction
  Future<void> submitFeedback({
    required String briefDate,
    required String sectorId,
    required bool isAccurate,
  }) async {
    // Save locally first (optimistic)
    await _saveFeedbackLocal(briefDate, sectorId, isAccurate);

    // Then sync to backend
    try {
      final token = await _idToken();
      await _dio.post<Map<String, dynamic>>(
        '${AppConstants.functionsBaseUrl}/feedback',
        data: {
          'briefDate': briefDate,
          'sectorId': sectorId,
          'isAccurate': isAccurate,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (_) {
      // Offline — local save is enough, will sync later
    }
  }

  /// Get feedbacks for a brief date (local cache, with optional remote sync)
  Future<Map<String, bool>> getFeedbacksForBrief(String briefDate) async {
    final local = await _getLocalFeedbacks(briefDate);
    if (local.isNotEmpty) return local;

    // Try remote
    try {
      final token = await _idToken();
      final resp = await _dio.get<Map<String, dynamic>>(
        '${AppConstants.functionsBaseUrl}/feedback/$briefDate',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (resp.data?['success'] == true && resp.data?['data'] != null) {
        final list = resp.data!['data'] as List;
        final result = <String, bool>{};
        for (final item in list) {
          result[item['sectorId'] as String] = item['isAccurate'] as bool;
        }
        // Cache locally
        for (final entry in result.entries) {
          await _saveFeedbackLocal(briefDate, entry.key, entry.value);
        }
        return result;
      }
    } catch (_) {
      // Offline
    }
    return {};
  }

  Future<void> _saveFeedbackLocal(String briefDate, String sectorId, bool isAccurate) async {
    final box = await Hive.openBox(_feedbackBoxName);
    await box.put('${briefDate}_$sectorId', isAccurate);
  }

  Future<Map<String, bool>> _getLocalFeedbacks(String briefDate) async {
    final box = await Hive.openBox(_feedbackBoxName);
    final result = <String, bool>{};
    for (final key in box.keys) {
      final k = key as String;
      if (k.startsWith('${briefDate}_')) {
        final sectorId = k.substring(briefDate.length + 1);
        result[sectorId] = box.get(k) as bool;
      }
    }
    return result;
  }
}
