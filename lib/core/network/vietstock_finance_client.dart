import 'package:dio/dio.dart';

class VietstockFinanceClient {
  VietstockFinanceClient(this._dio);

  final Dio _dio;

  final Map<String, _TokenCacheEntry> _tokenCache = {};

  static const _origin = 'https://finance.vietstock.vn';
  static final _tokenRegex = RegExp(
    r'name=__RequestVerificationToken type=hidden value=([^ >]+)',
  );

  Future<dynamic> postForm({
    required String url,
    required String referer,
    required Map<String, dynamic> data,
  }) async {
    final tokenEntry = await _getTokenEntry(referer);
    final payload = <String, dynamic>{
      ...data,
      '__RequestVerificationToken': tokenEntry.token,
    };

    final response = await _dio.post(
      url,
      data: payload.map((key, value) => MapEntry(key, '${value ?? ''}')),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Origin': _origin,
          'Referer': referer,
          'User-Agent': 'Mozilla/5.0',
          'X-Requested-With': 'XMLHttpRequest',
          if (tokenEntry.cookieHeader.isNotEmpty)
            'Cookie': tokenEntry.cookieHeader,
        },
      ),
    );

    return response.data;
  }

  Future<_TokenCacheEntry> _getTokenEntry(String referer) async {
    final now = DateTime.now();
    final cached = _tokenCache[referer];
    if (cached != null &&
        now.difference(cached.fetchedAt) < const Duration(minutes: 10)) {
      return cached;
    }

    final response = await _dio.get<String>(
      referer,
      options: Options(
        responseType: ResponseType.plain,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );

    final html = response.data ?? '';
    final match = _tokenRegex.firstMatch(html);
    if (match == null) {
      throw Exception('Could not extract Vietstock verification token.');
    }

    final entry = _TokenCacheEntry(
      token: match.group(1)!,
      cookieHeader: _extractCookieHeader(response.headers.map['set-cookie']),
      fetchedAt: now,
    );
    _tokenCache[referer] = entry;
    return entry;
  }

  String _extractCookieHeader(List<String>? setCookies) {
    if (setCookies == null || setCookies.isEmpty) {
      return '';
    }

    return setCookies
        .map((cookie) => cookie.split(';').first.trim())
        .where((cookie) => cookie.isNotEmpty)
        .join('; ');
  }
}

class _TokenCacheEntry {
  const _TokenCacheEntry({
    required this.token,
    required this.cookieHeader,
    required this.fetchedAt,
  });

  final String token;
  final String cookieHeader;
  final DateTime fetchedAt;
}
