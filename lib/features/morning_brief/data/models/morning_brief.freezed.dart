// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'morning_brief.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockMention _$StockMentionFromJson(Map<String, dynamic> json) {
  return _StockMention.fromJson(json);
}

/// @nodoc
mixin _$StockMention {
  String get symbol => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this StockMention to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockMention
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockMentionCopyWith<StockMention> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMentionCopyWith<$Res> {
  factory $StockMentionCopyWith(
    StockMention value,
    $Res Function(StockMention) then,
  ) = _$StockMentionCopyWithImpl<$Res, StockMention>;
  @useResult
  $Res call({String symbol, String reason});
}

/// @nodoc
class _$StockMentionCopyWithImpl<$Res, $Val extends StockMention>
    implements $StockMentionCopyWith<$Res> {
  _$StockMentionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockMention
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? symbol = null, Object? reason = null}) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            reason:
                null == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockMentionImplCopyWith<$Res>
    implements $StockMentionCopyWith<$Res> {
  factory _$$StockMentionImplCopyWith(
    _$StockMentionImpl value,
    $Res Function(_$StockMentionImpl) then,
  ) = __$$StockMentionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String symbol, String reason});
}

/// @nodoc
class __$$StockMentionImplCopyWithImpl<$Res>
    extends _$StockMentionCopyWithImpl<$Res, _$StockMentionImpl>
    implements _$$StockMentionImplCopyWith<$Res> {
  __$$StockMentionImplCopyWithImpl(
    _$StockMentionImpl _value,
    $Res Function(_$StockMentionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockMention
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? symbol = null, Object? reason = null}) {
    return _then(
      _$StockMentionImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        reason:
            null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMentionImpl implements _StockMention {
  const _$StockMentionImpl({required this.symbol, required this.reason});

  factory _$StockMentionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMentionImplFromJson(json);

  @override
  final String symbol;
  @override
  final String reason;

  @override
  String toString() {
    return 'StockMention(symbol: $symbol, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMentionImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, reason);

  /// Create a copy of StockMention
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMentionImplCopyWith<_$StockMentionImpl> get copyWith =>
      __$$StockMentionImplCopyWithImpl<_$StockMentionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMentionImplToJson(this);
  }
}

abstract class _StockMention implements StockMention {
  const factory _StockMention({
    required final String symbol,
    required final String reason,
  }) = _$StockMentionImpl;

  factory _StockMention.fromJson(Map<String, dynamic> json) =
      _$StockMentionImpl.fromJson;

  @override
  String get symbol;
  @override
  String get reason;

  /// Create a copy of StockMention
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockMentionImplCopyWith<_$StockMentionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SectorAnalysis _$SectorAnalysisFromJson(Map<String, dynamic> json) {
  return _SectorAnalysis.fromJson(json);
}

/// @nodoc
mixin _$SectorAnalysis {
  String get sectorId => throw _privateConstructorUsedError;
  String get sectorName => throw _privateConstructorUsedError;
  SectorImpact get impact => throw _privateConstructorUsedError;
  String get impactSummary => throw _privateConstructorUsedError;
  String get analysis => throw _privateConstructorUsedError;
  List<StockMention> get stocks => throw _privateConstructorUsedError;
  String get disclaimer => throw _privateConstructorUsedError;

  /// Serializes this SectorAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectorAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectorAnalysisCopyWith<SectorAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectorAnalysisCopyWith<$Res> {
  factory $SectorAnalysisCopyWith(
    SectorAnalysis value,
    $Res Function(SectorAnalysis) then,
  ) = _$SectorAnalysisCopyWithImpl<$Res, SectorAnalysis>;
  @useResult
  $Res call({
    String sectorId,
    String sectorName,
    SectorImpact impact,
    String impactSummary,
    String analysis,
    List<StockMention> stocks,
    String disclaimer,
  });
}

/// @nodoc
class _$SectorAnalysisCopyWithImpl<$Res, $Val extends SectorAnalysis>
    implements $SectorAnalysisCopyWith<$Res> {
  _$SectorAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectorAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectorId = null,
    Object? sectorName = null,
    Object? impact = null,
    Object? impactSummary = null,
    Object? analysis = null,
    Object? stocks = null,
    Object? disclaimer = null,
  }) {
    return _then(
      _value.copyWith(
            sectorId:
                null == sectorId
                    ? _value.sectorId
                    : sectorId // ignore: cast_nullable_to_non_nullable
                        as String,
            sectorName:
                null == sectorName
                    ? _value.sectorName
                    : sectorName // ignore: cast_nullable_to_non_nullable
                        as String,
            impact:
                null == impact
                    ? _value.impact
                    : impact // ignore: cast_nullable_to_non_nullable
                        as SectorImpact,
            impactSummary:
                null == impactSummary
                    ? _value.impactSummary
                    : impactSummary // ignore: cast_nullable_to_non_nullable
                        as String,
            analysis:
                null == analysis
                    ? _value.analysis
                    : analysis // ignore: cast_nullable_to_non_nullable
                        as String,
            stocks:
                null == stocks
                    ? _value.stocks
                    : stocks // ignore: cast_nullable_to_non_nullable
                        as List<StockMention>,
            disclaimer:
                null == disclaimer
                    ? _value.disclaimer
                    : disclaimer // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SectorAnalysisImplCopyWith<$Res>
    implements $SectorAnalysisCopyWith<$Res> {
  factory _$$SectorAnalysisImplCopyWith(
    _$SectorAnalysisImpl value,
    $Res Function(_$SectorAnalysisImpl) then,
  ) = __$$SectorAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sectorId,
    String sectorName,
    SectorImpact impact,
    String impactSummary,
    String analysis,
    List<StockMention> stocks,
    String disclaimer,
  });
}

/// @nodoc
class __$$SectorAnalysisImplCopyWithImpl<$Res>
    extends _$SectorAnalysisCopyWithImpl<$Res, _$SectorAnalysisImpl>
    implements _$$SectorAnalysisImplCopyWith<$Res> {
  __$$SectorAnalysisImplCopyWithImpl(
    _$SectorAnalysisImpl _value,
    $Res Function(_$SectorAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SectorAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectorId = null,
    Object? sectorName = null,
    Object? impact = null,
    Object? impactSummary = null,
    Object? analysis = null,
    Object? stocks = null,
    Object? disclaimer = null,
  }) {
    return _then(
      _$SectorAnalysisImpl(
        sectorId:
            null == sectorId
                ? _value.sectorId
                : sectorId // ignore: cast_nullable_to_non_nullable
                    as String,
        sectorName:
            null == sectorName
                ? _value.sectorName
                : sectorName // ignore: cast_nullable_to_non_nullable
                    as String,
        impact:
            null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
                    as SectorImpact,
        impactSummary:
            null == impactSummary
                ? _value.impactSummary
                : impactSummary // ignore: cast_nullable_to_non_nullable
                    as String,
        analysis:
            null == analysis
                ? _value.analysis
                : analysis // ignore: cast_nullable_to_non_nullable
                    as String,
        stocks:
            null == stocks
                ? _value._stocks
                : stocks // ignore: cast_nullable_to_non_nullable
                    as List<StockMention>,
        disclaimer:
            null == disclaimer
                ? _value.disclaimer
                : disclaimer // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SectorAnalysisImpl implements _SectorAnalysis {
  const _$SectorAnalysisImpl({
    required this.sectorId,
    required this.sectorName,
    required this.impact,
    required this.impactSummary,
    required this.analysis,
    required final List<StockMention> stocks,
    this.disclaimer =
        'Thông tin mang tính tham khảo, không phải tư vấn đầu tư.',
  }) : _stocks = stocks;

  factory _$SectorAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectorAnalysisImplFromJson(json);

  @override
  final String sectorId;
  @override
  final String sectorName;
  @override
  final SectorImpact impact;
  @override
  final String impactSummary;
  @override
  final String analysis;
  final List<StockMention> _stocks;
  @override
  List<StockMention> get stocks {
    if (_stocks is EqualUnmodifiableListView) return _stocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stocks);
  }

  @override
  @JsonKey()
  final String disclaimer;

  @override
  String toString() {
    return 'SectorAnalysis(sectorId: $sectorId, sectorName: $sectorName, impact: $impact, impactSummary: $impactSummary, analysis: $analysis, stocks: $stocks, disclaimer: $disclaimer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectorAnalysisImpl &&
            (identical(other.sectorId, sectorId) ||
                other.sectorId == sectorId) &&
            (identical(other.sectorName, sectorName) ||
                other.sectorName == sectorName) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.impactSummary, impactSummary) ||
                other.impactSummary == impactSummary) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            const DeepCollectionEquality().equals(other._stocks, _stocks) &&
            (identical(other.disclaimer, disclaimer) ||
                other.disclaimer == disclaimer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sectorId,
    sectorName,
    impact,
    impactSummary,
    analysis,
    const DeepCollectionEquality().hash(_stocks),
    disclaimer,
  );

  /// Create a copy of SectorAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectorAnalysisImplCopyWith<_$SectorAnalysisImpl> get copyWith =>
      __$$SectorAnalysisImplCopyWithImpl<_$SectorAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SectorAnalysisImplToJson(this);
  }
}

abstract class _SectorAnalysis implements SectorAnalysis {
  const factory _SectorAnalysis({
    required final String sectorId,
    required final String sectorName,
    required final SectorImpact impact,
    required final String impactSummary,
    required final String analysis,
    required final List<StockMention> stocks,
    final String disclaimer,
  }) = _$SectorAnalysisImpl;

  factory _SectorAnalysis.fromJson(Map<String, dynamic> json) =
      _$SectorAnalysisImpl.fromJson;

  @override
  String get sectorId;
  @override
  String get sectorName;
  @override
  SectorImpact get impact;
  @override
  String get impactSummary;
  @override
  String get analysis;
  @override
  List<StockMention> get stocks;
  @override
  String get disclaimer;

  /// Create a copy of SectorAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectorAnalysisImplCopyWith<_$SectorAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MorningBrief _$MorningBriefFromJson(Map<String, dynamic> json) {
  return _MorningBrief.fromJson(json);
}

/// @nodoc
mixin _$MorningBrief {
  String get date => throw _privateConstructorUsedError;
  List<String> get summary => throw _privateConstructorUsedError;
  List<SectorAnalysis> get sectors => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isFallback => throw _privateConstructorUsedError;
  String? get fallbackReason => throw _privateConstructorUsedError;

  /// Serializes this MorningBrief to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MorningBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MorningBriefCopyWith<MorningBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MorningBriefCopyWith<$Res> {
  factory $MorningBriefCopyWith(
    MorningBrief value,
    $Res Function(MorningBrief) then,
  ) = _$MorningBriefCopyWithImpl<$Res, MorningBrief>;
  @useResult
  $Res call({
    String date,
    List<String> summary,
    List<SectorAnalysis> sectors,
    DateTime createdAt,
    bool isFallback,
    String? fallbackReason,
  });
}

/// @nodoc
class _$MorningBriefCopyWithImpl<$Res, $Val extends MorningBrief>
    implements $MorningBriefCopyWith<$Res> {
  _$MorningBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MorningBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? summary = null,
    Object? sectors = null,
    Object? createdAt = null,
    Object? isFallback = null,
    Object? fallbackReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as String,
            summary:
                null == summary
                    ? _value.summary
                    : summary // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            sectors:
                null == sectors
                    ? _value.sectors
                    : sectors // ignore: cast_nullable_to_non_nullable
                        as List<SectorAnalysis>,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isFallback:
                null == isFallback
                    ? _value.isFallback
                    : isFallback // ignore: cast_nullable_to_non_nullable
                        as bool,
            fallbackReason:
                freezed == fallbackReason
                    ? _value.fallbackReason
                    : fallbackReason // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MorningBriefImplCopyWith<$Res>
    implements $MorningBriefCopyWith<$Res> {
  factory _$$MorningBriefImplCopyWith(
    _$MorningBriefImpl value,
    $Res Function(_$MorningBriefImpl) then,
  ) = __$$MorningBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    List<String> summary,
    List<SectorAnalysis> sectors,
    DateTime createdAt,
    bool isFallback,
    String? fallbackReason,
  });
}

/// @nodoc
class __$$MorningBriefImplCopyWithImpl<$Res>
    extends _$MorningBriefCopyWithImpl<$Res, _$MorningBriefImpl>
    implements _$$MorningBriefImplCopyWith<$Res> {
  __$$MorningBriefImplCopyWithImpl(
    _$MorningBriefImpl _value,
    $Res Function(_$MorningBriefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MorningBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? summary = null,
    Object? sectors = null,
    Object? createdAt = null,
    Object? isFallback = null,
    Object? fallbackReason = freezed,
  }) {
    return _then(
      _$MorningBriefImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as String,
        summary:
            null == summary
                ? _value._summary
                : summary // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        sectors:
            null == sectors
                ? _value._sectors
                : sectors // ignore: cast_nullable_to_non_nullable
                    as List<SectorAnalysis>,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isFallback:
            null == isFallback
                ? _value.isFallback
                : isFallback // ignore: cast_nullable_to_non_nullable
                    as bool,
        fallbackReason:
            freezed == fallbackReason
                ? _value.fallbackReason
                : fallbackReason // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MorningBriefImpl implements _MorningBrief {
  const _$MorningBriefImpl({
    required this.date,
    required final List<String> summary,
    required final List<SectorAnalysis> sectors,
    required this.createdAt,
    this.isFallback = false,
    this.fallbackReason,
  }) : _summary = summary,
       _sectors = sectors;

  factory _$MorningBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$MorningBriefImplFromJson(json);

  @override
  final String date;
  final List<String> _summary;
  @override
  List<String> get summary {
    if (_summary is EqualUnmodifiableListView) return _summary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_summary);
  }

  final List<SectorAnalysis> _sectors;
  @override
  List<SectorAnalysis> get sectors {
    if (_sectors is EqualUnmodifiableListView) return _sectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sectors);
  }

  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isFallback;
  @override
  final String? fallbackReason;

  @override
  String toString() {
    return 'MorningBrief(date: $date, summary: $summary, sectors: $sectors, createdAt: $createdAt, isFallback: $isFallback, fallbackReason: $fallbackReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MorningBriefImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._summary, _summary) &&
            const DeepCollectionEquality().equals(other._sectors, _sectors) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isFallback, isFallback) ||
                other.isFallback == isFallback) &&
            (identical(other.fallbackReason, fallbackReason) ||
                other.fallbackReason == fallbackReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    const DeepCollectionEquality().hash(_summary),
    const DeepCollectionEquality().hash(_sectors),
    createdAt,
    isFallback,
    fallbackReason,
  );

  /// Create a copy of MorningBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MorningBriefImplCopyWith<_$MorningBriefImpl> get copyWith =>
      __$$MorningBriefImplCopyWithImpl<_$MorningBriefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MorningBriefImplToJson(this);
  }
}

abstract class _MorningBrief implements MorningBrief {
  const factory _MorningBrief({
    required final String date,
    required final List<String> summary,
    required final List<SectorAnalysis> sectors,
    required final DateTime createdAt,
    final bool isFallback,
    final String? fallbackReason,
  }) = _$MorningBriefImpl;

  factory _MorningBrief.fromJson(Map<String, dynamic> json) =
      _$MorningBriefImpl.fromJson;

  @override
  String get date;
  @override
  List<String> get summary;
  @override
  List<SectorAnalysis> get sectors;
  @override
  DateTime get createdAt;
  @override
  bool get isFallback;
  @override
  String? get fallbackReason;

  /// Create a copy of MorningBrief
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MorningBriefImplCopyWith<_$MorningBriefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
