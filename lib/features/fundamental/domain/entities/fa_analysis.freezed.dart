// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fa_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PiotroskiScore _$PiotroskiScoreFromJson(Map<String, dynamic> json) {
  return _PiotroskiScore.fromJson(json);
}

/// @nodoc
mixin _$PiotroskiScore {
  int get totalScore =>
      throw _privateConstructorUsedError; // Profitability (4 points)
  bool get positiveNetIncome => throw _privateConstructorUsedError;
  bool get positiveROA => throw _privateConstructorUsedError;
  bool get positiveCFO => throw _privateConstructorUsedError;
  bool get cfoGreaterThanNetIncome =>
      throw _privateConstructorUsedError; // Leverage & Liquidity (3 points)
  bool get lowerLeverage => throw _privateConstructorUsedError;
  bool get higherCurrentRatio => throw _privateConstructorUsedError;
  bool get noNewShares =>
      throw _privateConstructorUsedError; // Efficiency (2 points)
  bool get higherGrossMargin => throw _privateConstructorUsedError;
  bool get higherAssetTurnover => throw _privateConstructorUsedError;

  /// Serializes this PiotroskiScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PiotroskiScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PiotroskiScoreCopyWith<PiotroskiScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PiotroskiScoreCopyWith<$Res> {
  factory $PiotroskiScoreCopyWith(
    PiotroskiScore value,
    $Res Function(PiotroskiScore) then,
  ) = _$PiotroskiScoreCopyWithImpl<$Res, PiotroskiScore>;
  @useResult
  $Res call({
    int totalScore,
    bool positiveNetIncome,
    bool positiveROA,
    bool positiveCFO,
    bool cfoGreaterThanNetIncome,
    bool lowerLeverage,
    bool higherCurrentRatio,
    bool noNewShares,
    bool higherGrossMargin,
    bool higherAssetTurnover,
  });
}

/// @nodoc
class _$PiotroskiScoreCopyWithImpl<$Res, $Val extends PiotroskiScore>
    implements $PiotroskiScoreCopyWith<$Res> {
  _$PiotroskiScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PiotroskiScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScore = null,
    Object? positiveNetIncome = null,
    Object? positiveROA = null,
    Object? positiveCFO = null,
    Object? cfoGreaterThanNetIncome = null,
    Object? lowerLeverage = null,
    Object? higherCurrentRatio = null,
    Object? noNewShares = null,
    Object? higherGrossMargin = null,
    Object? higherAssetTurnover = null,
  }) {
    return _then(
      _value.copyWith(
            totalScore:
                null == totalScore
                    ? _value.totalScore
                    : totalScore // ignore: cast_nullable_to_non_nullable
                        as int,
            positiveNetIncome:
                null == positiveNetIncome
                    ? _value.positiveNetIncome
                    : positiveNetIncome // ignore: cast_nullable_to_non_nullable
                        as bool,
            positiveROA:
                null == positiveROA
                    ? _value.positiveROA
                    : positiveROA // ignore: cast_nullable_to_non_nullable
                        as bool,
            positiveCFO:
                null == positiveCFO
                    ? _value.positiveCFO
                    : positiveCFO // ignore: cast_nullable_to_non_nullable
                        as bool,
            cfoGreaterThanNetIncome:
                null == cfoGreaterThanNetIncome
                    ? _value.cfoGreaterThanNetIncome
                    : cfoGreaterThanNetIncome // ignore: cast_nullable_to_non_nullable
                        as bool,
            lowerLeverage:
                null == lowerLeverage
                    ? _value.lowerLeverage
                    : lowerLeverage // ignore: cast_nullable_to_non_nullable
                        as bool,
            higherCurrentRatio:
                null == higherCurrentRatio
                    ? _value.higherCurrentRatio
                    : higherCurrentRatio // ignore: cast_nullable_to_non_nullable
                        as bool,
            noNewShares:
                null == noNewShares
                    ? _value.noNewShares
                    : noNewShares // ignore: cast_nullable_to_non_nullable
                        as bool,
            higherGrossMargin:
                null == higherGrossMargin
                    ? _value.higherGrossMargin
                    : higherGrossMargin // ignore: cast_nullable_to_non_nullable
                        as bool,
            higherAssetTurnover:
                null == higherAssetTurnover
                    ? _value.higherAssetTurnover
                    : higherAssetTurnover // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PiotroskiScoreImplCopyWith<$Res>
    implements $PiotroskiScoreCopyWith<$Res> {
  factory _$$PiotroskiScoreImplCopyWith(
    _$PiotroskiScoreImpl value,
    $Res Function(_$PiotroskiScoreImpl) then,
  ) = __$$PiotroskiScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalScore,
    bool positiveNetIncome,
    bool positiveROA,
    bool positiveCFO,
    bool cfoGreaterThanNetIncome,
    bool lowerLeverage,
    bool higherCurrentRatio,
    bool noNewShares,
    bool higherGrossMargin,
    bool higherAssetTurnover,
  });
}

/// @nodoc
class __$$PiotroskiScoreImplCopyWithImpl<$Res>
    extends _$PiotroskiScoreCopyWithImpl<$Res, _$PiotroskiScoreImpl>
    implements _$$PiotroskiScoreImplCopyWith<$Res> {
  __$$PiotroskiScoreImplCopyWithImpl(
    _$PiotroskiScoreImpl _value,
    $Res Function(_$PiotroskiScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PiotroskiScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScore = null,
    Object? positiveNetIncome = null,
    Object? positiveROA = null,
    Object? positiveCFO = null,
    Object? cfoGreaterThanNetIncome = null,
    Object? lowerLeverage = null,
    Object? higherCurrentRatio = null,
    Object? noNewShares = null,
    Object? higherGrossMargin = null,
    Object? higherAssetTurnover = null,
  }) {
    return _then(
      _$PiotroskiScoreImpl(
        totalScore:
            null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                    as int,
        positiveNetIncome:
            null == positiveNetIncome
                ? _value.positiveNetIncome
                : positiveNetIncome // ignore: cast_nullable_to_non_nullable
                    as bool,
        positiveROA:
            null == positiveROA
                ? _value.positiveROA
                : positiveROA // ignore: cast_nullable_to_non_nullable
                    as bool,
        positiveCFO:
            null == positiveCFO
                ? _value.positiveCFO
                : positiveCFO // ignore: cast_nullable_to_non_nullable
                    as bool,
        cfoGreaterThanNetIncome:
            null == cfoGreaterThanNetIncome
                ? _value.cfoGreaterThanNetIncome
                : cfoGreaterThanNetIncome // ignore: cast_nullable_to_non_nullable
                    as bool,
        lowerLeverage:
            null == lowerLeverage
                ? _value.lowerLeverage
                : lowerLeverage // ignore: cast_nullable_to_non_nullable
                    as bool,
        higherCurrentRatio:
            null == higherCurrentRatio
                ? _value.higherCurrentRatio
                : higherCurrentRatio // ignore: cast_nullable_to_non_nullable
                    as bool,
        noNewShares:
            null == noNewShares
                ? _value.noNewShares
                : noNewShares // ignore: cast_nullable_to_non_nullable
                    as bool,
        higherGrossMargin:
            null == higherGrossMargin
                ? _value.higherGrossMargin
                : higherGrossMargin // ignore: cast_nullable_to_non_nullable
                    as bool,
        higherAssetTurnover:
            null == higherAssetTurnover
                ? _value.higherAssetTurnover
                : higherAssetTurnover // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PiotroskiScoreImpl implements _PiotroskiScore {
  const _$PiotroskiScoreImpl({
    required this.totalScore,
    required this.positiveNetIncome,
    required this.positiveROA,
    required this.positiveCFO,
    required this.cfoGreaterThanNetIncome,
    required this.lowerLeverage,
    required this.higherCurrentRatio,
    required this.noNewShares,
    required this.higherGrossMargin,
    required this.higherAssetTurnover,
  });

  factory _$PiotroskiScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$PiotroskiScoreImplFromJson(json);

  @override
  final int totalScore;
  // Profitability (4 points)
  @override
  final bool positiveNetIncome;
  @override
  final bool positiveROA;
  @override
  final bool positiveCFO;
  @override
  final bool cfoGreaterThanNetIncome;
  // Leverage & Liquidity (3 points)
  @override
  final bool lowerLeverage;
  @override
  final bool higherCurrentRatio;
  @override
  final bool noNewShares;
  // Efficiency (2 points)
  @override
  final bool higherGrossMargin;
  @override
  final bool higherAssetTurnover;

  @override
  String toString() {
    return 'PiotroskiScore(totalScore: $totalScore, positiveNetIncome: $positiveNetIncome, positiveROA: $positiveROA, positiveCFO: $positiveCFO, cfoGreaterThanNetIncome: $cfoGreaterThanNetIncome, lowerLeverage: $lowerLeverage, higherCurrentRatio: $higherCurrentRatio, noNewShares: $noNewShares, higherGrossMargin: $higherGrossMargin, higherAssetTurnover: $higherAssetTurnover)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PiotroskiScoreImpl &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.positiveNetIncome, positiveNetIncome) ||
                other.positiveNetIncome == positiveNetIncome) &&
            (identical(other.positiveROA, positiveROA) ||
                other.positiveROA == positiveROA) &&
            (identical(other.positiveCFO, positiveCFO) ||
                other.positiveCFO == positiveCFO) &&
            (identical(
                  other.cfoGreaterThanNetIncome,
                  cfoGreaterThanNetIncome,
                ) ||
                other.cfoGreaterThanNetIncome == cfoGreaterThanNetIncome) &&
            (identical(other.lowerLeverage, lowerLeverage) ||
                other.lowerLeverage == lowerLeverage) &&
            (identical(other.higherCurrentRatio, higherCurrentRatio) ||
                other.higherCurrentRatio == higherCurrentRatio) &&
            (identical(other.noNewShares, noNewShares) ||
                other.noNewShares == noNewShares) &&
            (identical(other.higherGrossMargin, higherGrossMargin) ||
                other.higherGrossMargin == higherGrossMargin) &&
            (identical(other.higherAssetTurnover, higherAssetTurnover) ||
                other.higherAssetTurnover == higherAssetTurnover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalScore,
    positiveNetIncome,
    positiveROA,
    positiveCFO,
    cfoGreaterThanNetIncome,
    lowerLeverage,
    higherCurrentRatio,
    noNewShares,
    higherGrossMargin,
    higherAssetTurnover,
  );

  /// Create a copy of PiotroskiScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PiotroskiScoreImplCopyWith<_$PiotroskiScoreImpl> get copyWith =>
      __$$PiotroskiScoreImplCopyWithImpl<_$PiotroskiScoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PiotroskiScoreImplToJson(this);
  }
}

abstract class _PiotroskiScore implements PiotroskiScore {
  const factory _PiotroskiScore({
    required final int totalScore,
    required final bool positiveNetIncome,
    required final bool positiveROA,
    required final bool positiveCFO,
    required final bool cfoGreaterThanNetIncome,
    required final bool lowerLeverage,
    required final bool higherCurrentRatio,
    required final bool noNewShares,
    required final bool higherGrossMargin,
    required final bool higherAssetTurnover,
  }) = _$PiotroskiScoreImpl;

  factory _PiotroskiScore.fromJson(Map<String, dynamic> json) =
      _$PiotroskiScoreImpl.fromJson;

  @override
  int get totalScore; // Profitability (4 points)
  @override
  bool get positiveNetIncome;
  @override
  bool get positiveROA;
  @override
  bool get positiveCFO;
  @override
  bool get cfoGreaterThanNetIncome; // Leverage & Liquidity (3 points)
  @override
  bool get lowerLeverage;
  @override
  bool get higherCurrentRatio;
  @override
  bool get noNewShares; // Efficiency (2 points)
  @override
  bool get higherGrossMargin;
  @override
  bool get higherAssetTurnover;

  /// Create a copy of PiotroskiScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PiotroskiScoreImplCopyWith<_$PiotroskiScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AltmanZScore _$AltmanZScoreFromJson(Map<String, dynamic> json) {
  return _AltmanZScore.fromJson(json);
}

/// @nodoc
mixin _$AltmanZScore {
  double get zScore => throw _privateConstructorUsedError;
  String get zone =>
      throw _privateConstructorUsedError; // 'safe', 'grey', 'distress'
  String get model => throw _privateConstructorUsedError; // 'original' | 'em'
  double get x1 =>
      throw _privateConstructorUsedError; // Working Capital / Total Assets
  double get x2 =>
      throw _privateConstructorUsedError; // Retained Earnings / Total Assets
  double get x3 => throw _privateConstructorUsedError; // EBIT / Total Assets
  double get x4 =>
      throw _privateConstructorUsedError; // Market Cap / Total Liabilities
  double get x5 => throw _privateConstructorUsedError;

  /// Serializes this AltmanZScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AltmanZScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AltmanZScoreCopyWith<AltmanZScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AltmanZScoreCopyWith<$Res> {
  factory $AltmanZScoreCopyWith(
    AltmanZScore value,
    $Res Function(AltmanZScore) then,
  ) = _$AltmanZScoreCopyWithImpl<$Res, AltmanZScore>;
  @useResult
  $Res call({
    double zScore,
    String zone,
    String model,
    double x1,
    double x2,
    double x3,
    double x4,
    double x5,
  });
}

/// @nodoc
class _$AltmanZScoreCopyWithImpl<$Res, $Val extends AltmanZScore>
    implements $AltmanZScoreCopyWith<$Res> {
  _$AltmanZScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AltmanZScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zScore = null,
    Object? zone = null,
    Object? model = null,
    Object? x1 = null,
    Object? x2 = null,
    Object? x3 = null,
    Object? x4 = null,
    Object? x5 = null,
  }) {
    return _then(
      _value.copyWith(
            zScore:
                null == zScore
                    ? _value.zScore
                    : zScore // ignore: cast_nullable_to_non_nullable
                        as double,
            zone:
                null == zone
                    ? _value.zone
                    : zone // ignore: cast_nullable_to_non_nullable
                        as String,
            model:
                null == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as String,
            x1:
                null == x1
                    ? _value.x1
                    : x1 // ignore: cast_nullable_to_non_nullable
                        as double,
            x2:
                null == x2
                    ? _value.x2
                    : x2 // ignore: cast_nullable_to_non_nullable
                        as double,
            x3:
                null == x3
                    ? _value.x3
                    : x3 // ignore: cast_nullable_to_non_nullable
                        as double,
            x4:
                null == x4
                    ? _value.x4
                    : x4 // ignore: cast_nullable_to_non_nullable
                        as double,
            x5:
                null == x5
                    ? _value.x5
                    : x5 // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AltmanZScoreImplCopyWith<$Res>
    implements $AltmanZScoreCopyWith<$Res> {
  factory _$$AltmanZScoreImplCopyWith(
    _$AltmanZScoreImpl value,
    $Res Function(_$AltmanZScoreImpl) then,
  ) = __$$AltmanZScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double zScore,
    String zone,
    String model,
    double x1,
    double x2,
    double x3,
    double x4,
    double x5,
  });
}

/// @nodoc
class __$$AltmanZScoreImplCopyWithImpl<$Res>
    extends _$AltmanZScoreCopyWithImpl<$Res, _$AltmanZScoreImpl>
    implements _$$AltmanZScoreImplCopyWith<$Res> {
  __$$AltmanZScoreImplCopyWithImpl(
    _$AltmanZScoreImpl _value,
    $Res Function(_$AltmanZScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AltmanZScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zScore = null,
    Object? zone = null,
    Object? model = null,
    Object? x1 = null,
    Object? x2 = null,
    Object? x3 = null,
    Object? x4 = null,
    Object? x5 = null,
  }) {
    return _then(
      _$AltmanZScoreImpl(
        zScore:
            null == zScore
                ? _value.zScore
                : zScore // ignore: cast_nullable_to_non_nullable
                    as double,
        zone:
            null == zone
                ? _value.zone
                : zone // ignore: cast_nullable_to_non_nullable
                    as String,
        model:
            null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                    as String,
        x1:
            null == x1
                ? _value.x1
                : x1 // ignore: cast_nullable_to_non_nullable
                    as double,
        x2:
            null == x2
                ? _value.x2
                : x2 // ignore: cast_nullable_to_non_nullable
                    as double,
        x3:
            null == x3
                ? _value.x3
                : x3 // ignore: cast_nullable_to_non_nullable
                    as double,
        x4:
            null == x4
                ? _value.x4
                : x4 // ignore: cast_nullable_to_non_nullable
                    as double,
        x5:
            null == x5
                ? _value.x5
                : x5 // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AltmanZScoreImpl implements _AltmanZScore {
  const _$AltmanZScoreImpl({
    required this.zScore,
    required this.zone,
    required this.model,
    required this.x1,
    required this.x2,
    required this.x3,
    required this.x4,
    required this.x5,
  });

  factory _$AltmanZScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AltmanZScoreImplFromJson(json);

  @override
  final double zScore;
  @override
  final String zone;
  // 'safe', 'grey', 'distress'
  @override
  final String model;
  // 'original' | 'em'
  @override
  final double x1;
  // Working Capital / Total Assets
  @override
  final double x2;
  // Retained Earnings / Total Assets
  @override
  final double x3;
  // EBIT / Total Assets
  @override
  final double x4;
  // Market Cap / Total Liabilities
  @override
  final double x5;

  @override
  String toString() {
    return 'AltmanZScore(zScore: $zScore, zone: $zone, model: $model, x1: $x1, x2: $x2, x3: $x3, x4: $x4, x5: $x5)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AltmanZScoreImpl &&
            (identical(other.zScore, zScore) || other.zScore == zScore) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.x1, x1) || other.x1 == x1) &&
            (identical(other.x2, x2) || other.x2 == x2) &&
            (identical(other.x3, x3) || other.x3 == x3) &&
            (identical(other.x4, x4) || other.x4 == x4) &&
            (identical(other.x5, x5) || other.x5 == x5));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, zScore, zone, model, x1, x2, x3, x4, x5);

  /// Create a copy of AltmanZScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AltmanZScoreImplCopyWith<_$AltmanZScoreImpl> get copyWith =>
      __$$AltmanZScoreImplCopyWithImpl<_$AltmanZScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AltmanZScoreImplToJson(this);
  }
}

abstract class _AltmanZScore implements AltmanZScore {
  const factory _AltmanZScore({
    required final double zScore,
    required final String zone,
    required final String model,
    required final double x1,
    required final double x2,
    required final double x3,
    required final double x4,
    required final double x5,
  }) = _$AltmanZScoreImpl;

  factory _AltmanZScore.fromJson(Map<String, dynamic> json) =
      _$AltmanZScoreImpl.fromJson;

  @override
  double get zScore;
  @override
  String get zone; // 'safe', 'grey', 'distress'
  @override
  String get model; // 'original' | 'em'
  @override
  double get x1; // Working Capital / Total Assets
  @override
  double get x2; // Retained Earnings / Total Assets
  @override
  double get x3; // EBIT / Total Assets
  @override
  double get x4; // Market Cap / Total Liabilities
  @override
  double get x5;

  /// Create a copy of AltmanZScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AltmanZScoreImplCopyWith<_$AltmanZScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DuPontAnalysis _$DuPontAnalysisFromJson(Map<String, dynamic> json) {
  return _DuPontAnalysis.fromJson(json);
}

/// @nodoc
mixin _$DuPontAnalysis {
  String get period => throw _privateConstructorUsedError;
  double get roe => throw _privateConstructorUsedError;
  double get netMargin => throw _privateConstructorUsedError;
  double get assetTurnover => throw _privateConstructorUsedError;
  double get equityMultiplier => throw _privateConstructorUsedError;

  /// Serializes this DuPontAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DuPontAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DuPontAnalysisCopyWith<DuPontAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DuPontAnalysisCopyWith<$Res> {
  factory $DuPontAnalysisCopyWith(
    DuPontAnalysis value,
    $Res Function(DuPontAnalysis) then,
  ) = _$DuPontAnalysisCopyWithImpl<$Res, DuPontAnalysis>;
  @useResult
  $Res call({
    String period,
    double roe,
    double netMargin,
    double assetTurnover,
    double equityMultiplier,
  });
}

/// @nodoc
class _$DuPontAnalysisCopyWithImpl<$Res, $Val extends DuPontAnalysis>
    implements $DuPontAnalysisCopyWith<$Res> {
  _$DuPontAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DuPontAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? roe = null,
    Object? netMargin = null,
    Object? assetTurnover = null,
    Object? equityMultiplier = null,
  }) {
    return _then(
      _value.copyWith(
            period:
                null == period
                    ? _value.period
                    : period // ignore: cast_nullable_to_non_nullable
                        as String,
            roe:
                null == roe
                    ? _value.roe
                    : roe // ignore: cast_nullable_to_non_nullable
                        as double,
            netMargin:
                null == netMargin
                    ? _value.netMargin
                    : netMargin // ignore: cast_nullable_to_non_nullable
                        as double,
            assetTurnover:
                null == assetTurnover
                    ? _value.assetTurnover
                    : assetTurnover // ignore: cast_nullable_to_non_nullable
                        as double,
            equityMultiplier:
                null == equityMultiplier
                    ? _value.equityMultiplier
                    : equityMultiplier // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DuPontAnalysisImplCopyWith<$Res>
    implements $DuPontAnalysisCopyWith<$Res> {
  factory _$$DuPontAnalysisImplCopyWith(
    _$DuPontAnalysisImpl value,
    $Res Function(_$DuPontAnalysisImpl) then,
  ) = __$$DuPontAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String period,
    double roe,
    double netMargin,
    double assetTurnover,
    double equityMultiplier,
  });
}

/// @nodoc
class __$$DuPontAnalysisImplCopyWithImpl<$Res>
    extends _$DuPontAnalysisCopyWithImpl<$Res, _$DuPontAnalysisImpl>
    implements _$$DuPontAnalysisImplCopyWith<$Res> {
  __$$DuPontAnalysisImplCopyWithImpl(
    _$DuPontAnalysisImpl _value,
    $Res Function(_$DuPontAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DuPontAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? roe = null,
    Object? netMargin = null,
    Object? assetTurnover = null,
    Object? equityMultiplier = null,
  }) {
    return _then(
      _$DuPontAnalysisImpl(
        period:
            null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                    as String,
        roe:
            null == roe
                ? _value.roe
                : roe // ignore: cast_nullable_to_non_nullable
                    as double,
        netMargin:
            null == netMargin
                ? _value.netMargin
                : netMargin // ignore: cast_nullable_to_non_nullable
                    as double,
        assetTurnover:
            null == assetTurnover
                ? _value.assetTurnover
                : assetTurnover // ignore: cast_nullable_to_non_nullable
                    as double,
        equityMultiplier:
            null == equityMultiplier
                ? _value.equityMultiplier
                : equityMultiplier // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DuPontAnalysisImpl implements _DuPontAnalysis {
  const _$DuPontAnalysisImpl({
    required this.period,
    required this.roe,
    required this.netMargin,
    required this.assetTurnover,
    required this.equityMultiplier,
  });

  factory _$DuPontAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$DuPontAnalysisImplFromJson(json);

  @override
  final String period;
  @override
  final double roe;
  @override
  final double netMargin;
  @override
  final double assetTurnover;
  @override
  final double equityMultiplier;

  @override
  String toString() {
    return 'DuPontAnalysis(period: $period, roe: $roe, netMargin: $netMargin, assetTurnover: $assetTurnover, equityMultiplier: $equityMultiplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuPontAnalysisImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.roe, roe) || other.roe == roe) &&
            (identical(other.netMargin, netMargin) ||
                other.netMargin == netMargin) &&
            (identical(other.assetTurnover, assetTurnover) ||
                other.assetTurnover == assetTurnover) &&
            (identical(other.equityMultiplier, equityMultiplier) ||
                other.equityMultiplier == equityMultiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    roe,
    netMargin,
    assetTurnover,
    equityMultiplier,
  );

  /// Create a copy of DuPontAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuPontAnalysisImplCopyWith<_$DuPontAnalysisImpl> get copyWith =>
      __$$DuPontAnalysisImplCopyWithImpl<_$DuPontAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DuPontAnalysisImplToJson(this);
  }
}

abstract class _DuPontAnalysis implements DuPontAnalysis {
  const factory _DuPontAnalysis({
    required final String period,
    required final double roe,
    required final double netMargin,
    required final double assetTurnover,
    required final double equityMultiplier,
  }) = _$DuPontAnalysisImpl;

  factory _DuPontAnalysis.fromJson(Map<String, dynamic> json) =
      _$DuPontAnalysisImpl.fromJson;

  @override
  String get period;
  @override
  double get roe;
  @override
  double get netMargin;
  @override
  double get assetTurnover;
  @override
  double get equityMultiplier;

  /// Create a copy of DuPontAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuPontAnalysisImplCopyWith<_$DuPontAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GrowthMetrics _$GrowthMetricsFromJson(Map<String, dynamic> json) {
  return _GrowthMetrics.fromJson(json);
}

/// @nodoc
mixin _$GrowthMetrics {
  String get period => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get netIncome => throw _privateConstructorUsedError;
  double? get revenueGrowthQoQ => throw _privateConstructorUsedError;
  double? get revenueGrowthYoY => throw _privateConstructorUsedError;
  double? get netIncomeGrowthQoQ => throw _privateConstructorUsedError;
  double? get netIncomeGrowthYoY => throw _privateConstructorUsedError;

  /// Serializes this GrowthMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrowthMetricsCopyWith<GrowthMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrowthMetricsCopyWith<$Res> {
  factory $GrowthMetricsCopyWith(
    GrowthMetrics value,
    $Res Function(GrowthMetrics) then,
  ) = _$GrowthMetricsCopyWithImpl<$Res, GrowthMetrics>;
  @useResult
  $Res call({
    String period,
    double revenue,
    double netIncome,
    double? revenueGrowthQoQ,
    double? revenueGrowthYoY,
    double? netIncomeGrowthQoQ,
    double? netIncomeGrowthYoY,
  });
}

/// @nodoc
class _$GrowthMetricsCopyWithImpl<$Res, $Val extends GrowthMetrics>
    implements $GrowthMetricsCopyWith<$Res> {
  _$GrowthMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? revenue = null,
    Object? netIncome = null,
    Object? revenueGrowthQoQ = freezed,
    Object? revenueGrowthYoY = freezed,
    Object? netIncomeGrowthQoQ = freezed,
    Object? netIncomeGrowthYoY = freezed,
  }) {
    return _then(
      _value.copyWith(
            period:
                null == period
                    ? _value.period
                    : period // ignore: cast_nullable_to_non_nullable
                        as String,
            revenue:
                null == revenue
                    ? _value.revenue
                    : revenue // ignore: cast_nullable_to_non_nullable
                        as double,
            netIncome:
                null == netIncome
                    ? _value.netIncome
                    : netIncome // ignore: cast_nullable_to_non_nullable
                        as double,
            revenueGrowthQoQ:
                freezed == revenueGrowthQoQ
                    ? _value.revenueGrowthQoQ
                    : revenueGrowthQoQ // ignore: cast_nullable_to_non_nullable
                        as double?,
            revenueGrowthYoY:
                freezed == revenueGrowthYoY
                    ? _value.revenueGrowthYoY
                    : revenueGrowthYoY // ignore: cast_nullable_to_non_nullable
                        as double?,
            netIncomeGrowthQoQ:
                freezed == netIncomeGrowthQoQ
                    ? _value.netIncomeGrowthQoQ
                    : netIncomeGrowthQoQ // ignore: cast_nullable_to_non_nullable
                        as double?,
            netIncomeGrowthYoY:
                freezed == netIncomeGrowthYoY
                    ? _value.netIncomeGrowthYoY
                    : netIncomeGrowthYoY // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GrowthMetricsImplCopyWith<$Res>
    implements $GrowthMetricsCopyWith<$Res> {
  factory _$$GrowthMetricsImplCopyWith(
    _$GrowthMetricsImpl value,
    $Res Function(_$GrowthMetricsImpl) then,
  ) = __$$GrowthMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String period,
    double revenue,
    double netIncome,
    double? revenueGrowthQoQ,
    double? revenueGrowthYoY,
    double? netIncomeGrowthQoQ,
    double? netIncomeGrowthYoY,
  });
}

/// @nodoc
class __$$GrowthMetricsImplCopyWithImpl<$Res>
    extends _$GrowthMetricsCopyWithImpl<$Res, _$GrowthMetricsImpl>
    implements _$$GrowthMetricsImplCopyWith<$Res> {
  __$$GrowthMetricsImplCopyWithImpl(
    _$GrowthMetricsImpl _value,
    $Res Function(_$GrowthMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? revenue = null,
    Object? netIncome = null,
    Object? revenueGrowthQoQ = freezed,
    Object? revenueGrowthYoY = freezed,
    Object? netIncomeGrowthQoQ = freezed,
    Object? netIncomeGrowthYoY = freezed,
  }) {
    return _then(
      _$GrowthMetricsImpl(
        period:
            null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                    as String,
        revenue:
            null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                    as double,
        netIncome:
            null == netIncome
                ? _value.netIncome
                : netIncome // ignore: cast_nullable_to_non_nullable
                    as double,
        revenueGrowthQoQ:
            freezed == revenueGrowthQoQ
                ? _value.revenueGrowthQoQ
                : revenueGrowthQoQ // ignore: cast_nullable_to_non_nullable
                    as double?,
        revenueGrowthYoY:
            freezed == revenueGrowthYoY
                ? _value.revenueGrowthYoY
                : revenueGrowthYoY // ignore: cast_nullable_to_non_nullable
                    as double?,
        netIncomeGrowthQoQ:
            freezed == netIncomeGrowthQoQ
                ? _value.netIncomeGrowthQoQ
                : netIncomeGrowthQoQ // ignore: cast_nullable_to_non_nullable
                    as double?,
        netIncomeGrowthYoY:
            freezed == netIncomeGrowthYoY
                ? _value.netIncomeGrowthYoY
                : netIncomeGrowthYoY // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GrowthMetricsImpl implements _GrowthMetrics {
  const _$GrowthMetricsImpl({
    required this.period,
    required this.revenue,
    required this.netIncome,
    this.revenueGrowthQoQ,
    this.revenueGrowthYoY,
    this.netIncomeGrowthQoQ,
    this.netIncomeGrowthYoY,
  });

  factory _$GrowthMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrowthMetricsImplFromJson(json);

  @override
  final String period;
  @override
  final double revenue;
  @override
  final double netIncome;
  @override
  final double? revenueGrowthQoQ;
  @override
  final double? revenueGrowthYoY;
  @override
  final double? netIncomeGrowthQoQ;
  @override
  final double? netIncomeGrowthYoY;

  @override
  String toString() {
    return 'GrowthMetrics(period: $period, revenue: $revenue, netIncome: $netIncome, revenueGrowthQoQ: $revenueGrowthQoQ, revenueGrowthYoY: $revenueGrowthYoY, netIncomeGrowthQoQ: $netIncomeGrowthQoQ, netIncomeGrowthYoY: $netIncomeGrowthYoY)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrowthMetricsImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.netIncome, netIncome) ||
                other.netIncome == netIncome) &&
            (identical(other.revenueGrowthQoQ, revenueGrowthQoQ) ||
                other.revenueGrowthQoQ == revenueGrowthQoQ) &&
            (identical(other.revenueGrowthYoY, revenueGrowthYoY) ||
                other.revenueGrowthYoY == revenueGrowthYoY) &&
            (identical(other.netIncomeGrowthQoQ, netIncomeGrowthQoQ) ||
                other.netIncomeGrowthQoQ == netIncomeGrowthQoQ) &&
            (identical(other.netIncomeGrowthYoY, netIncomeGrowthYoY) ||
                other.netIncomeGrowthYoY == netIncomeGrowthYoY));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    revenue,
    netIncome,
    revenueGrowthQoQ,
    revenueGrowthYoY,
    netIncomeGrowthQoQ,
    netIncomeGrowthYoY,
  );

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrowthMetricsImplCopyWith<_$GrowthMetricsImpl> get copyWith =>
      __$$GrowthMetricsImplCopyWithImpl<_$GrowthMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrowthMetricsImplToJson(this);
  }
}

abstract class _GrowthMetrics implements GrowthMetrics {
  const factory _GrowthMetrics({
    required final String period,
    required final double revenue,
    required final double netIncome,
    final double? revenueGrowthQoQ,
    final double? revenueGrowthYoY,
    final double? netIncomeGrowthQoQ,
    final double? netIncomeGrowthYoY,
  }) = _$GrowthMetricsImpl;

  factory _GrowthMetrics.fromJson(Map<String, dynamic> json) =
      _$GrowthMetricsImpl.fromJson;

  @override
  String get period;
  @override
  double get revenue;
  @override
  double get netIncome;
  @override
  double? get revenueGrowthQoQ;
  @override
  double? get revenueGrowthYoY;
  @override
  double? get netIncomeGrowthQoQ;
  @override
  double? get netIncomeGrowthYoY;

  /// Create a copy of GrowthMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrowthMetricsImplCopyWith<_$GrowthMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ValuationResult _$ValuationResultFromJson(Map<String, dynamic> json) {
  return _ValuationResult.fromJson(json);
}

/// @nodoc
mixin _$ValuationResult {
  double get currentPrice =>
      throw _privateConstructorUsedError; // Graham Number
  double? get grahamNumber => throw _privateConstructorUsedError;
  double? get grahamUpside => throw _privateConstructorUsedError; // %
  // PEG
  double? get pegRatio => throw _privateConstructorUsedError;
  double? get earningsGrowthRate =>
      throw _privateConstructorUsedError; // avg YoY %
  // DCF (2-stage FCFF)
  double? get dcfValue => throw _privateConstructorUsedError; // per share, đồng
  double? get dcfUpside => throw _privateConstructorUsedError; // %
  // EV/EBITDA
  double? get evEbitda => throw _privateConstructorUsedError;
  double? get ebitdaBillion => throw _privateConstructorUsedError; // tỷ đồng
  double? get enterpriseValueBillion =>
      throw _privateConstructorUsedError; // tỷ đồng
  // FCF Yield
  double? get fcfYield => throw _privateConstructorUsedError; // %
  double? get freeCashFlowBillion => throw _privateConstructorUsedError;

  /// Serializes this ValuationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValuationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValuationResultCopyWith<ValuationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValuationResultCopyWith<$Res> {
  factory $ValuationResultCopyWith(
    ValuationResult value,
    $Res Function(ValuationResult) then,
  ) = _$ValuationResultCopyWithImpl<$Res, ValuationResult>;
  @useResult
  $Res call({
    double currentPrice,
    double? grahamNumber,
    double? grahamUpside,
    double? pegRatio,
    double? earningsGrowthRate,
    double? dcfValue,
    double? dcfUpside,
    double? evEbitda,
    double? ebitdaBillion,
    double? enterpriseValueBillion,
    double? fcfYield,
    double? freeCashFlowBillion,
  });
}

/// @nodoc
class _$ValuationResultCopyWithImpl<$Res, $Val extends ValuationResult>
    implements $ValuationResultCopyWith<$Res> {
  _$ValuationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValuationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPrice = null,
    Object? grahamNumber = freezed,
    Object? grahamUpside = freezed,
    Object? pegRatio = freezed,
    Object? earningsGrowthRate = freezed,
    Object? dcfValue = freezed,
    Object? dcfUpside = freezed,
    Object? evEbitda = freezed,
    Object? ebitdaBillion = freezed,
    Object? enterpriseValueBillion = freezed,
    Object? fcfYield = freezed,
    Object? freeCashFlowBillion = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentPrice:
                null == currentPrice
                    ? _value.currentPrice
                    : currentPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            grahamNumber:
                freezed == grahamNumber
                    ? _value.grahamNumber
                    : grahamNumber // ignore: cast_nullable_to_non_nullable
                        as double?,
            grahamUpside:
                freezed == grahamUpside
                    ? _value.grahamUpside
                    : grahamUpside // ignore: cast_nullable_to_non_nullable
                        as double?,
            pegRatio:
                freezed == pegRatio
                    ? _value.pegRatio
                    : pegRatio // ignore: cast_nullable_to_non_nullable
                        as double?,
            earningsGrowthRate:
                freezed == earningsGrowthRate
                    ? _value.earningsGrowthRate
                    : earningsGrowthRate // ignore: cast_nullable_to_non_nullable
                        as double?,
            dcfValue:
                freezed == dcfValue
                    ? _value.dcfValue
                    : dcfValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            dcfUpside:
                freezed == dcfUpside
                    ? _value.dcfUpside
                    : dcfUpside // ignore: cast_nullable_to_non_nullable
                        as double?,
            evEbitda:
                freezed == evEbitda
                    ? _value.evEbitda
                    : evEbitda // ignore: cast_nullable_to_non_nullable
                        as double?,
            ebitdaBillion:
                freezed == ebitdaBillion
                    ? _value.ebitdaBillion
                    : ebitdaBillion // ignore: cast_nullable_to_non_nullable
                        as double?,
            enterpriseValueBillion:
                freezed == enterpriseValueBillion
                    ? _value.enterpriseValueBillion
                    : enterpriseValueBillion // ignore: cast_nullable_to_non_nullable
                        as double?,
            fcfYield:
                freezed == fcfYield
                    ? _value.fcfYield
                    : fcfYield // ignore: cast_nullable_to_non_nullable
                        as double?,
            freeCashFlowBillion:
                freezed == freeCashFlowBillion
                    ? _value.freeCashFlowBillion
                    : freeCashFlowBillion // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ValuationResultImplCopyWith<$Res>
    implements $ValuationResultCopyWith<$Res> {
  factory _$$ValuationResultImplCopyWith(
    _$ValuationResultImpl value,
    $Res Function(_$ValuationResultImpl) then,
  ) = __$$ValuationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double currentPrice,
    double? grahamNumber,
    double? grahamUpside,
    double? pegRatio,
    double? earningsGrowthRate,
    double? dcfValue,
    double? dcfUpside,
    double? evEbitda,
    double? ebitdaBillion,
    double? enterpriseValueBillion,
    double? fcfYield,
    double? freeCashFlowBillion,
  });
}

/// @nodoc
class __$$ValuationResultImplCopyWithImpl<$Res>
    extends _$ValuationResultCopyWithImpl<$Res, _$ValuationResultImpl>
    implements _$$ValuationResultImplCopyWith<$Res> {
  __$$ValuationResultImplCopyWithImpl(
    _$ValuationResultImpl _value,
    $Res Function(_$ValuationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ValuationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPrice = null,
    Object? grahamNumber = freezed,
    Object? grahamUpside = freezed,
    Object? pegRatio = freezed,
    Object? earningsGrowthRate = freezed,
    Object? dcfValue = freezed,
    Object? dcfUpside = freezed,
    Object? evEbitda = freezed,
    Object? ebitdaBillion = freezed,
    Object? enterpriseValueBillion = freezed,
    Object? fcfYield = freezed,
    Object? freeCashFlowBillion = freezed,
  }) {
    return _then(
      _$ValuationResultImpl(
        currentPrice:
            null == currentPrice
                ? _value.currentPrice
                : currentPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        grahamNumber:
            freezed == grahamNumber
                ? _value.grahamNumber
                : grahamNumber // ignore: cast_nullable_to_non_nullable
                    as double?,
        grahamUpside:
            freezed == grahamUpside
                ? _value.grahamUpside
                : grahamUpside // ignore: cast_nullable_to_non_nullable
                    as double?,
        pegRatio:
            freezed == pegRatio
                ? _value.pegRatio
                : pegRatio // ignore: cast_nullable_to_non_nullable
                    as double?,
        earningsGrowthRate:
            freezed == earningsGrowthRate
                ? _value.earningsGrowthRate
                : earningsGrowthRate // ignore: cast_nullable_to_non_nullable
                    as double?,
        dcfValue:
            freezed == dcfValue
                ? _value.dcfValue
                : dcfValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        dcfUpside:
            freezed == dcfUpside
                ? _value.dcfUpside
                : dcfUpside // ignore: cast_nullable_to_non_nullable
                    as double?,
        evEbitda:
            freezed == evEbitda
                ? _value.evEbitda
                : evEbitda // ignore: cast_nullable_to_non_nullable
                    as double?,
        ebitdaBillion:
            freezed == ebitdaBillion
                ? _value.ebitdaBillion
                : ebitdaBillion // ignore: cast_nullable_to_non_nullable
                    as double?,
        enterpriseValueBillion:
            freezed == enterpriseValueBillion
                ? _value.enterpriseValueBillion
                : enterpriseValueBillion // ignore: cast_nullable_to_non_nullable
                    as double?,
        fcfYield:
            freezed == fcfYield
                ? _value.fcfYield
                : fcfYield // ignore: cast_nullable_to_non_nullable
                    as double?,
        freeCashFlowBillion:
            freezed == freeCashFlowBillion
                ? _value.freeCashFlowBillion
                : freeCashFlowBillion // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ValuationResultImpl implements _ValuationResult {
  const _$ValuationResultImpl({
    required this.currentPrice,
    this.grahamNumber,
    this.grahamUpside,
    this.pegRatio,
    this.earningsGrowthRate,
    this.dcfValue,
    this.dcfUpside,
    this.evEbitda,
    this.ebitdaBillion,
    this.enterpriseValueBillion,
    this.fcfYield,
    this.freeCashFlowBillion,
  });

  factory _$ValuationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValuationResultImplFromJson(json);

  @override
  final double currentPrice;
  // Graham Number
  @override
  final double? grahamNumber;
  @override
  final double? grahamUpside;
  // %
  // PEG
  @override
  final double? pegRatio;
  @override
  final double? earningsGrowthRate;
  // avg YoY %
  // DCF (2-stage FCFF)
  @override
  final double? dcfValue;
  // per share, đồng
  @override
  final double? dcfUpside;
  // %
  // EV/EBITDA
  @override
  final double? evEbitda;
  @override
  final double? ebitdaBillion;
  // tỷ đồng
  @override
  final double? enterpriseValueBillion;
  // tỷ đồng
  // FCF Yield
  @override
  final double? fcfYield;
  // %
  @override
  final double? freeCashFlowBillion;

  @override
  String toString() {
    return 'ValuationResult(currentPrice: $currentPrice, grahamNumber: $grahamNumber, grahamUpside: $grahamUpside, pegRatio: $pegRatio, earningsGrowthRate: $earningsGrowthRate, dcfValue: $dcfValue, dcfUpside: $dcfUpside, evEbitda: $evEbitda, ebitdaBillion: $ebitdaBillion, enterpriseValueBillion: $enterpriseValueBillion, fcfYield: $fcfYield, freeCashFlowBillion: $freeCashFlowBillion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValuationResultImpl &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.grahamNumber, grahamNumber) ||
                other.grahamNumber == grahamNumber) &&
            (identical(other.grahamUpside, grahamUpside) ||
                other.grahamUpside == grahamUpside) &&
            (identical(other.pegRatio, pegRatio) ||
                other.pegRatio == pegRatio) &&
            (identical(other.earningsGrowthRate, earningsGrowthRate) ||
                other.earningsGrowthRate == earningsGrowthRate) &&
            (identical(other.dcfValue, dcfValue) ||
                other.dcfValue == dcfValue) &&
            (identical(other.dcfUpside, dcfUpside) ||
                other.dcfUpside == dcfUpside) &&
            (identical(other.evEbitda, evEbitda) ||
                other.evEbitda == evEbitda) &&
            (identical(other.ebitdaBillion, ebitdaBillion) ||
                other.ebitdaBillion == ebitdaBillion) &&
            (identical(other.enterpriseValueBillion, enterpriseValueBillion) ||
                other.enterpriseValueBillion == enterpriseValueBillion) &&
            (identical(other.fcfYield, fcfYield) ||
                other.fcfYield == fcfYield) &&
            (identical(other.freeCashFlowBillion, freeCashFlowBillion) ||
                other.freeCashFlowBillion == freeCashFlowBillion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPrice,
    grahamNumber,
    grahamUpside,
    pegRatio,
    earningsGrowthRate,
    dcfValue,
    dcfUpside,
    evEbitda,
    ebitdaBillion,
    enterpriseValueBillion,
    fcfYield,
    freeCashFlowBillion,
  );

  /// Create a copy of ValuationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValuationResultImplCopyWith<_$ValuationResultImpl> get copyWith =>
      __$$ValuationResultImplCopyWithImpl<_$ValuationResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ValuationResultImplToJson(this);
  }
}

abstract class _ValuationResult implements ValuationResult {
  const factory _ValuationResult({
    required final double currentPrice,
    final double? grahamNumber,
    final double? grahamUpside,
    final double? pegRatio,
    final double? earningsGrowthRate,
    final double? dcfValue,
    final double? dcfUpside,
    final double? evEbitda,
    final double? ebitdaBillion,
    final double? enterpriseValueBillion,
    final double? fcfYield,
    final double? freeCashFlowBillion,
  }) = _$ValuationResultImpl;

  factory _ValuationResult.fromJson(Map<String, dynamic> json) =
      _$ValuationResultImpl.fromJson;

  @override
  double get currentPrice; // Graham Number
  @override
  double? get grahamNumber;
  @override
  double? get grahamUpside; // %
  // PEG
  @override
  double? get pegRatio;
  @override
  double? get earningsGrowthRate; // avg YoY %
  // DCF (2-stage FCFF)
  @override
  double? get dcfValue; // per share, đồng
  @override
  double? get dcfUpside; // %
  // EV/EBITDA
  @override
  double? get evEbitda;
  @override
  double? get ebitdaBillion; // tỷ đồng
  @override
  double? get enterpriseValueBillion; // tỷ đồng
  // FCF Yield
  @override
  double? get fcfYield; // %
  @override
  double? get freeCashFlowBillion;

  /// Create a copy of ValuationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValuationResultImplCopyWith<_$ValuationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RiskMetrics _$RiskMetricsFromJson(Map<String, dynamic> json) {
  return _RiskMetrics.fromJson(json);
}

/// @nodoc
mixin _$RiskMetrics {
  double get volatility =>
      throw _privateConstructorUsedError; // annualized %, std dev of daily returns
  double get beta => throw _privateConstructorUsedError; // vs VN-Index
  double get maxDrawdown =>
      throw _privateConstructorUsedError; // worst peak-to-trough %
  double get sharpeRatio => throw _privateConstructorUsedError;

  /// Serializes this RiskMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RiskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiskMetricsCopyWith<RiskMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskMetricsCopyWith<$Res> {
  factory $RiskMetricsCopyWith(
    RiskMetrics value,
    $Res Function(RiskMetrics) then,
  ) = _$RiskMetricsCopyWithImpl<$Res, RiskMetrics>;
  @useResult
  $Res call({
    double volatility,
    double beta,
    double maxDrawdown,
    double sharpeRatio,
  });
}

/// @nodoc
class _$RiskMetricsCopyWithImpl<$Res, $Val extends RiskMetrics>
    implements $RiskMetricsCopyWith<$Res> {
  _$RiskMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volatility = null,
    Object? beta = null,
    Object? maxDrawdown = null,
    Object? sharpeRatio = null,
  }) {
    return _then(
      _value.copyWith(
            volatility:
                null == volatility
                    ? _value.volatility
                    : volatility // ignore: cast_nullable_to_non_nullable
                        as double,
            beta:
                null == beta
                    ? _value.beta
                    : beta // ignore: cast_nullable_to_non_nullable
                        as double,
            maxDrawdown:
                null == maxDrawdown
                    ? _value.maxDrawdown
                    : maxDrawdown // ignore: cast_nullable_to_non_nullable
                        as double,
            sharpeRatio:
                null == sharpeRatio
                    ? _value.sharpeRatio
                    : sharpeRatio // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RiskMetricsImplCopyWith<$Res>
    implements $RiskMetricsCopyWith<$Res> {
  factory _$$RiskMetricsImplCopyWith(
    _$RiskMetricsImpl value,
    $Res Function(_$RiskMetricsImpl) then,
  ) = __$$RiskMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double volatility,
    double beta,
    double maxDrawdown,
    double sharpeRatio,
  });
}

/// @nodoc
class __$$RiskMetricsImplCopyWithImpl<$Res>
    extends _$RiskMetricsCopyWithImpl<$Res, _$RiskMetricsImpl>
    implements _$$RiskMetricsImplCopyWith<$Res> {
  __$$RiskMetricsImplCopyWithImpl(
    _$RiskMetricsImpl _value,
    $Res Function(_$RiskMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RiskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volatility = null,
    Object? beta = null,
    Object? maxDrawdown = null,
    Object? sharpeRatio = null,
  }) {
    return _then(
      _$RiskMetricsImpl(
        volatility:
            null == volatility
                ? _value.volatility
                : volatility // ignore: cast_nullable_to_non_nullable
                    as double,
        beta:
            null == beta
                ? _value.beta
                : beta // ignore: cast_nullable_to_non_nullable
                    as double,
        maxDrawdown:
            null == maxDrawdown
                ? _value.maxDrawdown
                : maxDrawdown // ignore: cast_nullable_to_non_nullable
                    as double,
        sharpeRatio:
            null == sharpeRatio
                ? _value.sharpeRatio
                : sharpeRatio // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskMetricsImpl implements _RiskMetrics {
  const _$RiskMetricsImpl({
    required this.volatility,
    required this.beta,
    required this.maxDrawdown,
    required this.sharpeRatio,
  });

  factory _$RiskMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskMetricsImplFromJson(json);

  @override
  final double volatility;
  // annualized %, std dev of daily returns
  @override
  final double beta;
  // vs VN-Index
  @override
  final double maxDrawdown;
  // worst peak-to-trough %
  @override
  final double sharpeRatio;

  @override
  String toString() {
    return 'RiskMetrics(volatility: $volatility, beta: $beta, maxDrawdown: $maxDrawdown, sharpeRatio: $sharpeRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskMetricsImpl &&
            (identical(other.volatility, volatility) ||
                other.volatility == volatility) &&
            (identical(other.beta, beta) || other.beta == beta) &&
            (identical(other.maxDrawdown, maxDrawdown) ||
                other.maxDrawdown == maxDrawdown) &&
            (identical(other.sharpeRatio, sharpeRatio) ||
                other.sharpeRatio == sharpeRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, volatility, beta, maxDrawdown, sharpeRatio);

  /// Create a copy of RiskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskMetricsImplCopyWith<_$RiskMetricsImpl> get copyWith =>
      __$$RiskMetricsImplCopyWithImpl<_$RiskMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiskMetricsImplToJson(this);
  }
}

abstract class _RiskMetrics implements RiskMetrics {
  const factory _RiskMetrics({
    required final double volatility,
    required final double beta,
    required final double maxDrawdown,
    required final double sharpeRatio,
  }) = _$RiskMetricsImpl;

  factory _RiskMetrics.fromJson(Map<String, dynamic> json) =
      _$RiskMetricsImpl.fromJson;

  @override
  double get volatility; // annualized %, std dev of daily returns
  @override
  double get beta; // vs VN-Index
  @override
  double get maxDrawdown; // worst peak-to-trough %
  @override
  double get sharpeRatio;

  /// Create a copy of RiskMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskMetricsImplCopyWith<_$RiskMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FaAnalysis _$FaAnalysisFromJson(Map<String, dynamic> json) {
  return _FaAnalysis.fromJson(json);
}

/// @nodoc
mixin _$FaAnalysis {
  String get symbol => throw _privateConstructorUsedError;
  PiotroskiScore? get piotroski => throw _privateConstructorUsedError;
  AltmanZScore? get altmanZOriginal => throw _privateConstructorUsedError;
  AltmanZScore? get altmanZEm => throw _privateConstructorUsedError;
  List<DuPontAnalysis>? get dupont => throw _privateConstructorUsedError;
  List<GrowthMetrics>? get growth => throw _privateConstructorUsedError;
  ValuationResult? get valuation => throw _privateConstructorUsedError;
  RiskMetrics? get risk => throw _privateConstructorUsedError;

  /// Serializes this FaAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FaAnalysisCopyWith<FaAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FaAnalysisCopyWith<$Res> {
  factory $FaAnalysisCopyWith(
    FaAnalysis value,
    $Res Function(FaAnalysis) then,
  ) = _$FaAnalysisCopyWithImpl<$Res, FaAnalysis>;
  @useResult
  $Res call({
    String symbol,
    PiotroskiScore? piotroski,
    AltmanZScore? altmanZOriginal,
    AltmanZScore? altmanZEm,
    List<DuPontAnalysis>? dupont,
    List<GrowthMetrics>? growth,
    ValuationResult? valuation,
    RiskMetrics? risk,
  });

  $PiotroskiScoreCopyWith<$Res>? get piotroski;
  $AltmanZScoreCopyWith<$Res>? get altmanZOriginal;
  $AltmanZScoreCopyWith<$Res>? get altmanZEm;
  $ValuationResultCopyWith<$Res>? get valuation;
  $RiskMetricsCopyWith<$Res>? get risk;
}

/// @nodoc
class _$FaAnalysisCopyWithImpl<$Res, $Val extends FaAnalysis>
    implements $FaAnalysisCopyWith<$Res> {
  _$FaAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? piotroski = freezed,
    Object? altmanZOriginal = freezed,
    Object? altmanZEm = freezed,
    Object? dupont = freezed,
    Object? growth = freezed,
    Object? valuation = freezed,
    Object? risk = freezed,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            piotroski:
                freezed == piotroski
                    ? _value.piotroski
                    : piotroski // ignore: cast_nullable_to_non_nullable
                        as PiotroskiScore?,
            altmanZOriginal:
                freezed == altmanZOriginal
                    ? _value.altmanZOriginal
                    : altmanZOriginal // ignore: cast_nullable_to_non_nullable
                        as AltmanZScore?,
            altmanZEm:
                freezed == altmanZEm
                    ? _value.altmanZEm
                    : altmanZEm // ignore: cast_nullable_to_non_nullable
                        as AltmanZScore?,
            dupont:
                freezed == dupont
                    ? _value.dupont
                    : dupont // ignore: cast_nullable_to_non_nullable
                        as List<DuPontAnalysis>?,
            growth:
                freezed == growth
                    ? _value.growth
                    : growth // ignore: cast_nullable_to_non_nullable
                        as List<GrowthMetrics>?,
            valuation:
                freezed == valuation
                    ? _value.valuation
                    : valuation // ignore: cast_nullable_to_non_nullable
                        as ValuationResult?,
            risk:
                freezed == risk
                    ? _value.risk
                    : risk // ignore: cast_nullable_to_non_nullable
                        as RiskMetrics?,
          )
          as $Val,
    );
  }

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PiotroskiScoreCopyWith<$Res>? get piotroski {
    if (_value.piotroski == null) {
      return null;
    }

    return $PiotroskiScoreCopyWith<$Res>(_value.piotroski!, (value) {
      return _then(_value.copyWith(piotroski: value) as $Val);
    });
  }

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AltmanZScoreCopyWith<$Res>? get altmanZOriginal {
    if (_value.altmanZOriginal == null) {
      return null;
    }

    return $AltmanZScoreCopyWith<$Res>(_value.altmanZOriginal!, (value) {
      return _then(_value.copyWith(altmanZOriginal: value) as $Val);
    });
  }

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AltmanZScoreCopyWith<$Res>? get altmanZEm {
    if (_value.altmanZEm == null) {
      return null;
    }

    return $AltmanZScoreCopyWith<$Res>(_value.altmanZEm!, (value) {
      return _then(_value.copyWith(altmanZEm: value) as $Val);
    });
  }

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ValuationResultCopyWith<$Res>? get valuation {
    if (_value.valuation == null) {
      return null;
    }

    return $ValuationResultCopyWith<$Res>(_value.valuation!, (value) {
      return _then(_value.copyWith(valuation: value) as $Val);
    });
  }

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RiskMetricsCopyWith<$Res>? get risk {
    if (_value.risk == null) {
      return null;
    }

    return $RiskMetricsCopyWith<$Res>(_value.risk!, (value) {
      return _then(_value.copyWith(risk: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FaAnalysisImplCopyWith<$Res>
    implements $FaAnalysisCopyWith<$Res> {
  factory _$$FaAnalysisImplCopyWith(
    _$FaAnalysisImpl value,
    $Res Function(_$FaAnalysisImpl) then,
  ) = __$$FaAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    PiotroskiScore? piotroski,
    AltmanZScore? altmanZOriginal,
    AltmanZScore? altmanZEm,
    List<DuPontAnalysis>? dupont,
    List<GrowthMetrics>? growth,
    ValuationResult? valuation,
    RiskMetrics? risk,
  });

  @override
  $PiotroskiScoreCopyWith<$Res>? get piotroski;
  @override
  $AltmanZScoreCopyWith<$Res>? get altmanZOriginal;
  @override
  $AltmanZScoreCopyWith<$Res>? get altmanZEm;
  @override
  $ValuationResultCopyWith<$Res>? get valuation;
  @override
  $RiskMetricsCopyWith<$Res>? get risk;
}

/// @nodoc
class __$$FaAnalysisImplCopyWithImpl<$Res>
    extends _$FaAnalysisCopyWithImpl<$Res, _$FaAnalysisImpl>
    implements _$$FaAnalysisImplCopyWith<$Res> {
  __$$FaAnalysisImplCopyWithImpl(
    _$FaAnalysisImpl _value,
    $Res Function(_$FaAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? piotroski = freezed,
    Object? altmanZOriginal = freezed,
    Object? altmanZEm = freezed,
    Object? dupont = freezed,
    Object? growth = freezed,
    Object? valuation = freezed,
    Object? risk = freezed,
  }) {
    return _then(
      _$FaAnalysisImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        piotroski:
            freezed == piotroski
                ? _value.piotroski
                : piotroski // ignore: cast_nullable_to_non_nullable
                    as PiotroskiScore?,
        altmanZOriginal:
            freezed == altmanZOriginal
                ? _value.altmanZOriginal
                : altmanZOriginal // ignore: cast_nullable_to_non_nullable
                    as AltmanZScore?,
        altmanZEm:
            freezed == altmanZEm
                ? _value.altmanZEm
                : altmanZEm // ignore: cast_nullable_to_non_nullable
                    as AltmanZScore?,
        dupont:
            freezed == dupont
                ? _value._dupont
                : dupont // ignore: cast_nullable_to_non_nullable
                    as List<DuPontAnalysis>?,
        growth:
            freezed == growth
                ? _value._growth
                : growth // ignore: cast_nullable_to_non_nullable
                    as List<GrowthMetrics>?,
        valuation:
            freezed == valuation
                ? _value.valuation
                : valuation // ignore: cast_nullable_to_non_nullable
                    as ValuationResult?,
        risk:
            freezed == risk
                ? _value.risk
                : risk // ignore: cast_nullable_to_non_nullable
                    as RiskMetrics?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FaAnalysisImpl implements _FaAnalysis {
  const _$FaAnalysisImpl({
    required this.symbol,
    this.piotroski,
    this.altmanZOriginal,
    this.altmanZEm,
    final List<DuPontAnalysis>? dupont,
    final List<GrowthMetrics>? growth,
    this.valuation,
    this.risk,
  }) : _dupont = dupont,
       _growth = growth;

  factory _$FaAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$FaAnalysisImplFromJson(json);

  @override
  final String symbol;
  @override
  final PiotroskiScore? piotroski;
  @override
  final AltmanZScore? altmanZOriginal;
  @override
  final AltmanZScore? altmanZEm;
  final List<DuPontAnalysis>? _dupont;
  @override
  List<DuPontAnalysis>? get dupont {
    final value = _dupont;
    if (value == null) return null;
    if (_dupont is EqualUnmodifiableListView) return _dupont;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<GrowthMetrics>? _growth;
  @override
  List<GrowthMetrics>? get growth {
    final value = _growth;
    if (value == null) return null;
    if (_growth is EqualUnmodifiableListView) return _growth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ValuationResult? valuation;
  @override
  final RiskMetrics? risk;

  @override
  String toString() {
    return 'FaAnalysis(symbol: $symbol, piotroski: $piotroski, altmanZOriginal: $altmanZOriginal, altmanZEm: $altmanZEm, dupont: $dupont, growth: $growth, valuation: $valuation, risk: $risk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FaAnalysisImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.piotroski, piotroski) ||
                other.piotroski == piotroski) &&
            (identical(other.altmanZOriginal, altmanZOriginal) ||
                other.altmanZOriginal == altmanZOriginal) &&
            (identical(other.altmanZEm, altmanZEm) ||
                other.altmanZEm == altmanZEm) &&
            const DeepCollectionEquality().equals(other._dupont, _dupont) &&
            const DeepCollectionEquality().equals(other._growth, _growth) &&
            (identical(other.valuation, valuation) ||
                other.valuation == valuation) &&
            (identical(other.risk, risk) || other.risk == risk));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symbol,
    piotroski,
    altmanZOriginal,
    altmanZEm,
    const DeepCollectionEquality().hash(_dupont),
    const DeepCollectionEquality().hash(_growth),
    valuation,
    risk,
  );

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FaAnalysisImplCopyWith<_$FaAnalysisImpl> get copyWith =>
      __$$FaAnalysisImplCopyWithImpl<_$FaAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FaAnalysisImplToJson(this);
  }
}

abstract class _FaAnalysis implements FaAnalysis {
  const factory _FaAnalysis({
    required final String symbol,
    final PiotroskiScore? piotroski,
    final AltmanZScore? altmanZOriginal,
    final AltmanZScore? altmanZEm,
    final List<DuPontAnalysis>? dupont,
    final List<GrowthMetrics>? growth,
    final ValuationResult? valuation,
    final RiskMetrics? risk,
  }) = _$FaAnalysisImpl;

  factory _FaAnalysis.fromJson(Map<String, dynamic> json) =
      _$FaAnalysisImpl.fromJson;

  @override
  String get symbol;
  @override
  PiotroskiScore? get piotroski;
  @override
  AltmanZScore? get altmanZOriginal;
  @override
  AltmanZScore? get altmanZEm;
  @override
  List<DuPontAnalysis>? get dupont;
  @override
  List<GrowthMetrics>? get growth;
  @override
  ValuationResult? get valuation;
  @override
  RiskMetrics? get risk;

  /// Create a copy of FaAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FaAnalysisImplCopyWith<_$FaAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
