import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import '../../domain/entities/news_article.dart';

class NewsApiDatasource {
  final Dio _dio;

  static const _source = 'Vietstock';
  static const _stockNewsRssUrl = 'https://vietstock.vn/830/chung-khoan/co-phieu.rss';
  static const _browserHeaders = {
    'User-Agent': 'Mozilla/5.0',
    'Referer': 'https://vietstock.vn/',
    'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7',
  };

  NewsApiDatasource(this._dio);

  final _rssDateFormat = DateFormat('dd MMM yyyy HH:mm:ss', 'en_US');

  Future<List<NewsArticle>> getLatestNews({int page = 1}) async {
    final response = await _dio.get<String>(
      _stockNewsRssUrl,
      options: Options(
        responseType: ResponseType.plain,
        headers: {
          ..._browserHeaders,
          'Accept':
              'application/rss+xml,application/xml,text/xml;q=0.9,*/*;q=0.8',
        },
      ),
    );

    final rawXml = response.data;
    if (rawXml == null || rawXml.trim().isEmpty) return [];

    final document = xml.XmlDocument.parse(rawXml);
    return document
        .findAllElements('item')
        .map(_parseRssItem)
        .whereType<NewsArticle>()
        .toList();
  }

  Future<List<NewsArticle>> getNewsBySymbol(String symbol) async {
    final normalizedSymbol = symbol.trim().toUpperCase();
    final news = await getLatestNews();
    return news.where((article) {
      final relatedSymbols = article.relatedSymbols ?? const <String>[];
      return relatedSymbols.contains(normalizedSymbol);
    }).toList();
  }

  Future<NewsArticle> getNewsDetail(String id) async {
    final url = _decodeArticleId(id);
    final response = await _dio.get<String>(
      url,
      options: Options(
        responseType: ResponseType.plain,
        headers: {
          ..._browserHeaders,
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      ),
    );

    final rawHtml = response.data;
    if (rawHtml == null || rawHtml.trim().isEmpty) {
      throw Exception('No article content found');
    }

    final document = html_parser.parse(rawHtml);
    final title =
        _extractMetaContent(document, property: 'og:title')
            ?.replaceFirst(RegExp(r'\s*\|\s*Vietstock$'), '')
            .trim() ??
        document.querySelector('h1.article-title')?.text.trim() ??
        'Vietstock';
    final summary =
        _extractMetaContent(document, property: 'og:description') ??
        _extractMetaContent(document, name: 'description');
    final imageUrl = _normalizeUrl(
      _extractMetaContent(document, property: 'og:image'),
    );
    final publishedAt =
        _parseIsoDate(
          _extractMetaContent(document, property: 'article:published_time'),
        ) ??
        DateTime.now();
    final content = _extractArticleBody(document);
    final relatedSymbols = _extractRelatedSymbols(
      [
        title,
        if (summary != null) summary,
        if (content.isNotEmpty) content,
      ].join('\n'),
    );

    return NewsArticle(
      id: _encodeArticleId(url),
      title: title,
      source: _source,
      publishedAt: publishedAt,
      summary: _nullIfEmpty(summary),
      content: _nullIfEmpty(content),
      imageUrl: imageUrl,
      url: url,
      relatedSymbols: relatedSymbols.isEmpty ? null : relatedSymbols,
    );
  }

  NewsArticle? _parseRssItem(xml.XmlElement item) {
    final title = _elementText(item, 'title');
    final url = _normalizeUrl(_elementText(item, 'link'));
    final pubDate = _parseRssDate(_elementText(item, 'pubDate'));

    if (title == null || url == null || pubDate == null) {
      return null;
    }

    final description = _parseDescription(_elementText(item, 'description'));
    final relatedSymbols = _extractRelatedSymbols(
      [
        title,
        if (description.summary.isNotEmpty) description.summary,
      ].join('\n'),
    );

    return NewsArticle(
      id: _encodeArticleId(url),
      title: title,
      source: _source,
      publishedAt: pubDate,
      summary: _nullIfEmpty(description.summary),
      imageUrl: description.imageUrl,
      url: url,
      relatedSymbols: relatedSymbols.isEmpty ? null : relatedSymbols,
    );
  }

  _ParsedDescription _parseDescription(String? rawDescription) {
    if (rawDescription == null || rawDescription.trim().isEmpty) {
      return const _ParsedDescription(summary: '');
    }

    final fragment = html_parser.parseFragment(rawDescription);
    final imageUrl = _normalizeUrl(
      fragment.querySelector('img')?.attributes['src'],
    );
    final summary = _normalizeWhitespace(fragment.text ?? '');

    return _ParsedDescription(
      summary: summary,
      imageUrl: imageUrl,
    );
  }

  String _extractArticleBody(dom.Document document) {
    final body = document.querySelector('#vst_detail');
    if (body == null) return '';

    final paragraphs = body
        .querySelectorAll('p.pHead, p.pBody')
        .map((node) => _normalizeWhitespace(node.text))
        .where((text) => text.isNotEmpty)
        .toList();

    if (paragraphs.isNotEmpty) {
      return paragraphs.join('\n\n');
    }

    return _normalizeWhitespace(body.text);
  }

  String? _elementText(xml.XmlElement parent, String name) {
    final element = parent.getElement(name);
    if (element == null) return null;
    final value = element.innerText.trim();
    return value.isEmpty ? null : value;
  }

  String? _extractMetaContent(
    dom.Document document, {
    String? property,
    String? name,
  }) {
    dom.Element? node;
    if (property != null) {
      node = document.querySelector('meta[property="$property"]');
    }
    node ??= name != null ? document.querySelector('meta[name="$name"]') : null;
    final value = node?.attributes['content']?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  DateTime? _parseIsoDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  DateTime? _parseRssDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    final match = RegExp(
      r'^[A-Za-z]{3},\s(\d{2}\s[A-Za-z]{3}\s\d{4}\s\d{2}:\d{2}:\d{2})\s([+-]\d{4})$',
    ).firstMatch(raw.trim());
    if (match == null) return null;

    final datePart = match.group(1)!;
    final offsetPart = match.group(2)!;
    final localTime = _rssDateFormat.parseUtc(datePart);
    final sign = offsetPart.startsWith('-') ? -1 : 1;
    final hours = int.parse(offsetPart.substring(1, 3));
    final minutes = int.parse(offsetPart.substring(3, 5));
    final offset = Duration(hours: hours, minutes: minutes);

    return sign >= 0
        ? localTime.subtract(offset).toLocal()
        : localTime.add(offset).toLocal();
  }

  List<String> _extractRelatedSymbols(String text) {
    final symbols = <String>{};

    void collect(RegExp pattern) {
      for (final match in pattern.allMatches(text)) {
        final candidate = match.group(1)?.trim().toUpperCase();
        if (candidate != null && _isLikelySymbol(candidate)) {
          symbols.add(candidate);
        }
      }
    }

    collect(
      RegExp(r'\b(?:HOSE|HNX|UPCOM|UPCOMINDEX|UPCoM|UpCOM):\s*([A-Z]{2,5})\b'),
    );
    collect(
      RegExp(
        r'\b(?:cổ phiếu|mã)\s+([A-Z]{2,5})\b',
        caseSensitive: false,
        unicode: true,
      ),
    );
    collect(RegExp(r'\(([A-Z]{2,5})\)'));

    return symbols.toList();
  }

  bool _isLikelySymbol(String value) {
    const excluded = {
      'HOSE',
      'HNX',
      'UPCOM',
      'VNINDEX',
      'UPCOMINDEX',
      'ETF',
      'FILI',
      'AI',
    };

    return RegExp(r'^[A-Z]{2,5}$').hasMatch(value) &&
        !excluded.contains(value);
  }

  String _encodeArticleId(String url) => Uri.encodeComponent(url);

  String _decodeArticleId(String id) {
    if (id.startsWith('http://') || id.startsWith('https://')) {
      return _normalizeUrl(id) ?? id;
    }
    return _normalizeUrl(Uri.decodeComponent(id)) ?? id;
  }

  String? _normalizeUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;

    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null) return null;
    if (uri.scheme == 'http') {
      return uri.replace(scheme: 'https').toString();
    }
    if (uri.scheme.isEmpty) {
      return 'https://${rawUrl.trim()}';
    }
    return uri.toString();
  }

  String _normalizeWhitespace(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String? _nullIfEmpty(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}

class _ParsedDescription {
  final String summary;
  final String? imageUrl;

  const _ParsedDescription({
    required this.summary,
    this.imageUrl,
  });
}
