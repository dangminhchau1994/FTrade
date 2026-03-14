// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsArticleImpl _$$NewsArticleImplFromJson(Map<String, dynamic> json) =>
    _$NewsArticleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      summary: json['summary'] as String?,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      url: json['url'] as String?,
      relatedSymbols:
          (json['relatedSymbols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$$NewsArticleImplToJson(_$NewsArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'source': instance.source,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'summary': instance.summary,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'url': instance.url,
      'relatedSymbols': instance.relatedSymbols,
    };
