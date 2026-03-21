// This is a generated file - do not edit.
//
// Generated from proto/stock_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class StockData extends $pb.GeneratedMessage {
  factory StockData({
    $core.String? symbol,
    $core.int? matchedPrice,
    $core.int? matchedVolume,
    $core.int? priceChange,
    $core.int? priceChangePercent,
    $fixnum.Int64? totalVolume,
    $fixnum.Int64? totalValue,
    $core.int? openPrice,
    $core.int? highPrice,
    $core.int? lowPrice,
    $core.int? ceiling,
    $core.int? floor,
    $core.int? refPrice,
    $core.int? best1Bid,
    $core.int? best1BidVol,
    $core.int? best2Bid,
    $core.int? best2BidVol,
    $core.int? best3Bid,
    $core.int? best3BidVol,
    $core.int? best1Offer,
    $core.int? best1OfferVol,
    $core.int? best2Offer,
    $core.int? best2OfferVol,
    $core.int? best3Offer,
    $core.int? best3OfferVol,
    $fixnum.Int64? buyForeignQtty,
    $fixnum.Int64? sellForeignQtty,
    $core.String? session,
    $core.int? avgPrice,
    $fixnum.Int64? buyCount,
    $fixnum.Int64? sellCount,
    $fixnum.Int64? netForeignQtty,
    $fixnum.Int64? foreignRoom,
    $fixnum.Int64? currentForeign,
    $core.int? ptMatchedPrice,
    $fixnum.Int64? ptMatchedVolume,
    $core.int? atoPrice,
    $core.int? atcPrice,
    $fixnum.Int64? atoVolume,
    $fixnum.Int64? atcVolume,
    $core.int? best4Bid,
    $core.int? best4BidVol,
    $core.int? best5Bid,
    $core.int? best5BidVol,
    $core.int? best4Offer,
    $core.int? best4OfferVol,
    $core.int? best5Offer,
    $core.int? best5OfferVol,
    $core.String? exchange,
    $fixnum.Int64? totalBuyTradeAmount,
    $fixnum.Int64? totalSellTradeAmount,
    $core.double? indexWeight,
    $core.int? underlyingPrice,
    $core.double? premium,
    $core.double? impliedVol,
    $core.double? delta,
    $core.String? tradingStatus,
    $fixnum.Int64? tradeDate,
    $fixnum.Int64? time,
    $fixnum.Int64? field60,
    $fixnum.Int64? field61,
    $fixnum.Int64? field62,
    $fixnum.Int64? field63,
    $fixnum.Int64? field64,
    $fixnum.Int64? field65,
    $fixnum.Int64? field66,
    $fixnum.Int64? field67,
    $fixnum.Int64? field68,
    $fixnum.Int64? field69,
    $fixnum.Int64? field70,
    $fixnum.Int64? field71,
    $fixnum.Int64? field72,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (matchedPrice != null) result.matchedPrice = matchedPrice;
    if (matchedVolume != null) result.matchedVolume = matchedVolume;
    if (priceChange != null) result.priceChange = priceChange;
    if (priceChangePercent != null)
      result.priceChangePercent = priceChangePercent;
    if (totalVolume != null) result.totalVolume = totalVolume;
    if (totalValue != null) result.totalValue = totalValue;
    if (openPrice != null) result.openPrice = openPrice;
    if (highPrice != null) result.highPrice = highPrice;
    if (lowPrice != null) result.lowPrice = lowPrice;
    if (ceiling != null) result.ceiling = ceiling;
    if (floor != null) result.floor = floor;
    if (refPrice != null) result.refPrice = refPrice;
    if (best1Bid != null) result.best1Bid = best1Bid;
    if (best1BidVol != null) result.best1BidVol = best1BidVol;
    if (best2Bid != null) result.best2Bid = best2Bid;
    if (best2BidVol != null) result.best2BidVol = best2BidVol;
    if (best3Bid != null) result.best3Bid = best3Bid;
    if (best3BidVol != null) result.best3BidVol = best3BidVol;
    if (best1Offer != null) result.best1Offer = best1Offer;
    if (best1OfferVol != null) result.best1OfferVol = best1OfferVol;
    if (best2Offer != null) result.best2Offer = best2Offer;
    if (best2OfferVol != null) result.best2OfferVol = best2OfferVol;
    if (best3Offer != null) result.best3Offer = best3Offer;
    if (best3OfferVol != null) result.best3OfferVol = best3OfferVol;
    if (buyForeignQtty != null) result.buyForeignQtty = buyForeignQtty;
    if (sellForeignQtty != null) result.sellForeignQtty = sellForeignQtty;
    if (session != null) result.session = session;
    if (avgPrice != null) result.avgPrice = avgPrice;
    if (buyCount != null) result.buyCount = buyCount;
    if (sellCount != null) result.sellCount = sellCount;
    if (netForeignQtty != null) result.netForeignQtty = netForeignQtty;
    if (foreignRoom != null) result.foreignRoom = foreignRoom;
    if (currentForeign != null) result.currentForeign = currentForeign;
    if (ptMatchedPrice != null) result.ptMatchedPrice = ptMatchedPrice;
    if (ptMatchedVolume != null) result.ptMatchedVolume = ptMatchedVolume;
    if (atoPrice != null) result.atoPrice = atoPrice;
    if (atcPrice != null) result.atcPrice = atcPrice;
    if (atoVolume != null) result.atoVolume = atoVolume;
    if (atcVolume != null) result.atcVolume = atcVolume;
    if (best4Bid != null) result.best4Bid = best4Bid;
    if (best4BidVol != null) result.best4BidVol = best4BidVol;
    if (best5Bid != null) result.best5Bid = best5Bid;
    if (best5BidVol != null) result.best5BidVol = best5BidVol;
    if (best4Offer != null) result.best4Offer = best4Offer;
    if (best4OfferVol != null) result.best4OfferVol = best4OfferVol;
    if (best5Offer != null) result.best5Offer = best5Offer;
    if (best5OfferVol != null) result.best5OfferVol = best5OfferVol;
    if (exchange != null) result.exchange = exchange;
    if (totalBuyTradeAmount != null)
      result.totalBuyTradeAmount = totalBuyTradeAmount;
    if (totalSellTradeAmount != null)
      result.totalSellTradeAmount = totalSellTradeAmount;
    if (indexWeight != null) result.indexWeight = indexWeight;
    if (underlyingPrice != null) result.underlyingPrice = underlyingPrice;
    if (premium != null) result.premium = premium;
    if (impliedVol != null) result.impliedVol = impliedVol;
    if (delta != null) result.delta = delta;
    if (tradingStatus != null) result.tradingStatus = tradingStatus;
    if (tradeDate != null) result.tradeDate = tradeDate;
    if (time != null) result.time = time;
    if (field60 != null) result.field60 = field60;
    if (field61 != null) result.field61 = field61;
    if (field62 != null) result.field62 = field62;
    if (field63 != null) result.field63 = field63;
    if (field64 != null) result.field64 = field64;
    if (field65 != null) result.field65 = field65;
    if (field66 != null) result.field66 = field66;
    if (field67 != null) result.field67 = field67;
    if (field68 != null) result.field68 = field68;
    if (field69 != null) result.field69 = field69;
    if (field70 != null) result.field70 = field70;
    if (field71 != null) result.field71 = field71;
    if (field72 != null) result.field72 = field72;
    return result;
  }

  StockData._();

  factory StockData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StockData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockData',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aI(2, _omitFieldNames ? '' : 'matchedPrice')
    ..aI(3, _omitFieldNames ? '' : 'matchedVolume')
    ..aI(4, _omitFieldNames ? '' : 'priceChange',
        fieldType: $pb.PbFieldType.OS3)
    ..aI(5, _omitFieldNames ? '' : 'priceChangePercent',
        fieldType: $pb.PbFieldType.OS3)
    ..aInt64(6, _omitFieldNames ? '' : 'totalVolume')
    ..aInt64(7, _omitFieldNames ? '' : 'totalValue')
    ..aI(8, _omitFieldNames ? '' : 'openPrice')
    ..aI(9, _omitFieldNames ? '' : 'highPrice')
    ..aI(10, _omitFieldNames ? '' : 'lowPrice')
    ..aI(11, _omitFieldNames ? '' : 'ceiling')
    ..aI(12, _omitFieldNames ? '' : 'floor')
    ..aI(13, _omitFieldNames ? '' : 'refPrice')
    ..aI(14, _omitFieldNames ? '' : 'best1Bid')
    ..aI(15, _omitFieldNames ? '' : 'best1BidVol')
    ..aI(16, _omitFieldNames ? '' : 'best2Bid')
    ..aI(17, _omitFieldNames ? '' : 'best2BidVol')
    ..aI(18, _omitFieldNames ? '' : 'best3Bid')
    ..aI(19, _omitFieldNames ? '' : 'best3BidVol')
    ..aI(20, _omitFieldNames ? '' : 'best1Offer')
    ..aI(21, _omitFieldNames ? '' : 'best1OfferVol')
    ..aI(22, _omitFieldNames ? '' : 'best2Offer')
    ..aI(23, _omitFieldNames ? '' : 'best2OfferVol')
    ..aI(24, _omitFieldNames ? '' : 'best3Offer')
    ..aI(25, _omitFieldNames ? '' : 'best3OfferVol')
    ..aInt64(26, _omitFieldNames ? '' : 'buyForeignQtty')
    ..aInt64(27, _omitFieldNames ? '' : 'sellForeignQtty')
    ..aOS(28, _omitFieldNames ? '' : 'session')
    ..aI(29, _omitFieldNames ? '' : 'avgPrice')
    ..aInt64(30, _omitFieldNames ? '' : 'buyCount')
    ..aInt64(31, _omitFieldNames ? '' : 'sellCount')
    ..aInt64(32, _omitFieldNames ? '' : 'netForeignQtty')
    ..aInt64(33, _omitFieldNames ? '' : 'foreignRoom')
    ..aInt64(34, _omitFieldNames ? '' : 'currentForeign')
    ..aI(35, _omitFieldNames ? '' : 'ptMatchedPrice')
    ..aInt64(36, _omitFieldNames ? '' : 'ptMatchedVolume')
    ..aI(37, _omitFieldNames ? '' : 'atoPrice')
    ..aI(38, _omitFieldNames ? '' : 'atcPrice')
    ..aInt64(39, _omitFieldNames ? '' : 'atoVolume')
    ..aInt64(40, _omitFieldNames ? '' : 'atcVolume')
    ..aI(41, _omitFieldNames ? '' : 'best4Bid')
    ..aI(42, _omitFieldNames ? '' : 'best4BidVol')
    ..aI(43, _omitFieldNames ? '' : 'best5Bid')
    ..aI(44, _omitFieldNames ? '' : 'best5BidVol')
    ..aI(45, _omitFieldNames ? '' : 'best4Offer')
    ..aI(46, _omitFieldNames ? '' : 'best4OfferVol')
    ..aI(47, _omitFieldNames ? '' : 'best5Offer')
    ..aI(48, _omitFieldNames ? '' : 'best5OfferVol')
    ..aOS(49, _omitFieldNames ? '' : 'exchange')
    ..aInt64(50, _omitFieldNames ? '' : 'totalBuyTradeAmount')
    ..aInt64(51, _omitFieldNames ? '' : 'totalSellTradeAmount')
    ..aD(52, _omitFieldNames ? '' : 'indexWeight')
    ..aI(53, _omitFieldNames ? '' : 'underlyingPrice')
    ..aD(54, _omitFieldNames ? '' : 'premium')
    ..aD(55, _omitFieldNames ? '' : 'impliedVol')
    ..aD(56, _omitFieldNames ? '' : 'delta')
    ..aOS(57, _omitFieldNames ? '' : 'tradingStatus')
    ..aInt64(58, _omitFieldNames ? '' : 'tradeDate')
    ..aInt64(59, _omitFieldNames ? '' : 'time')
    ..aInt64(60, _omitFieldNames ? '' : 'field60')
    ..aInt64(61, _omitFieldNames ? '' : 'field61')
    ..aInt64(62, _omitFieldNames ? '' : 'field62')
    ..aInt64(63, _omitFieldNames ? '' : 'field63')
    ..aInt64(64, _omitFieldNames ? '' : 'field64')
    ..aInt64(65, _omitFieldNames ? '' : 'field65')
    ..aInt64(66, _omitFieldNames ? '' : 'field66')
    ..aInt64(67, _omitFieldNames ? '' : 'field67')
    ..aInt64(68, _omitFieldNames ? '' : 'field68')
    ..aInt64(69, _omitFieldNames ? '' : 'field69')
    ..aInt64(70, _omitFieldNames ? '' : 'field70')
    ..aInt64(71, _omitFieldNames ? '' : 'field71')
    ..aInt64(72, _omitFieldNames ? '' : 'field72')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockData copyWith(void Function(StockData) updates) =>
      super.copyWith((message) => updates(message as StockData)) as StockData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StockData create() => StockData._();
  @$core.override
  StockData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StockData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StockData>(create);
  static StockData? _defaultInstance;

  /// ── Định danh ─────────────────────────────────────────────────────────────
  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  /// ── Giá khớp lệnh ─────────────────────────────────────────────────────────
  @$pb.TagNumber(2)
  $core.int get matchedPrice => $_getIZ(1);
  @$pb.TagNumber(2)
  set matchedPrice($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchedPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchedPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get matchedVolume => $_getIZ(2);
  @$pb.TagNumber(3)
  set matchedVolume($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMatchedVolume() => $_has(2);
  @$pb.TagNumber(3)
  void clearMatchedVolume() => $_clearField(3);

  /// ── Thay đổi giá ──────────────────────────────────────────────────────────
  @$pb.TagNumber(4)
  $core.int get priceChange => $_getIZ(3);
  @$pb.TagNumber(4)
  set priceChange($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceChange() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceChange() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get priceChangePercent => $_getIZ(4);
  @$pb.TagNumber(5)
  set priceChangePercent($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPriceChangePercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriceChangePercent() => $_clearField(5);

  /// ── Tổng khối lượng & giá trị ─────────────────────────────────────────────
  @$pb.TagNumber(6)
  $fixnum.Int64 get totalVolume => $_getI64(5);
  @$pb.TagNumber(6)
  set totalVolume($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalVolume() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalVolume() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get totalValue => $_getI64(6);
  @$pb.TagNumber(7)
  set totalValue($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalValue() => $_clearField(7);

  /// ── OHLC ──────────────────────────────────────────────────────────────────
  @$pb.TagNumber(8)
  $core.int get openPrice => $_getIZ(7);
  @$pb.TagNumber(8)
  set openPrice($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOpenPrice() => $_has(7);
  @$pb.TagNumber(8)
  void clearOpenPrice() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get highPrice => $_getIZ(8);
  @$pb.TagNumber(9)
  set highPrice($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHighPrice() => $_has(8);
  @$pb.TagNumber(9)
  void clearHighPrice() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get lowPrice => $_getIZ(9);
  @$pb.TagNumber(10)
  set lowPrice($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLowPrice() => $_has(9);
  @$pb.TagNumber(10)
  void clearLowPrice() => $_clearField(10);

  /// ── Giá tham chiếu ────────────────────────────────────────────────────────
  @$pb.TagNumber(11)
  $core.int get ceiling => $_getIZ(10);
  @$pb.TagNumber(11)
  set ceiling($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCeiling() => $_has(10);
  @$pb.TagNumber(11)
  void clearCeiling() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get floor => $_getIZ(11);
  @$pb.TagNumber(12)
  set floor($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFloor() => $_has(11);
  @$pb.TagNumber(12)
  void clearFloor() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get refPrice => $_getIZ(12);
  @$pb.TagNumber(13)
  set refPrice($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRefPrice() => $_has(12);
  @$pb.TagNumber(13)
  void clearRefPrice() => $_clearField(13);

  /// ── 3 bước giá mua (Bid) ──────────────────────────────────────────────────
  @$pb.TagNumber(14)
  $core.int get best1Bid => $_getIZ(13);
  @$pb.TagNumber(14)
  set best1Bid($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBest1Bid() => $_has(13);
  @$pb.TagNumber(14)
  void clearBest1Bid() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get best1BidVol => $_getIZ(14);
  @$pb.TagNumber(15)
  set best1BidVol($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBest1BidVol() => $_has(14);
  @$pb.TagNumber(15)
  void clearBest1BidVol() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get best2Bid => $_getIZ(15);
  @$pb.TagNumber(16)
  set best2Bid($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasBest2Bid() => $_has(15);
  @$pb.TagNumber(16)
  void clearBest2Bid() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get best2BidVol => $_getIZ(16);
  @$pb.TagNumber(17)
  set best2BidVol($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasBest2BidVol() => $_has(16);
  @$pb.TagNumber(17)
  void clearBest2BidVol() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get best3Bid => $_getIZ(17);
  @$pb.TagNumber(18)
  set best3Bid($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasBest3Bid() => $_has(17);
  @$pb.TagNumber(18)
  void clearBest3Bid() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get best3BidVol => $_getIZ(18);
  @$pb.TagNumber(19)
  set best3BidVol($core.int value) => $_setSignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasBest3BidVol() => $_has(18);
  @$pb.TagNumber(19)
  void clearBest3BidVol() => $_clearField(19);

  /// ── 3 bước giá bán (Ask / Offer) ──────────────────────────────────────────
  @$pb.TagNumber(20)
  $core.int get best1Offer => $_getIZ(19);
  @$pb.TagNumber(20)
  set best1Offer($core.int value) => $_setSignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasBest1Offer() => $_has(19);
  @$pb.TagNumber(20)
  void clearBest1Offer() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get best1OfferVol => $_getIZ(20);
  @$pb.TagNumber(21)
  set best1OfferVol($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasBest1OfferVol() => $_has(20);
  @$pb.TagNumber(21)
  void clearBest1OfferVol() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get best2Offer => $_getIZ(21);
  @$pb.TagNumber(22)
  set best2Offer($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasBest2Offer() => $_has(21);
  @$pb.TagNumber(22)
  void clearBest2Offer() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.int get best2OfferVol => $_getIZ(22);
  @$pb.TagNumber(23)
  set best2OfferVol($core.int value) => $_setSignedInt32(22, value);
  @$pb.TagNumber(23)
  $core.bool hasBest2OfferVol() => $_has(22);
  @$pb.TagNumber(23)
  void clearBest2OfferVol() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.int get best3Offer => $_getIZ(23);
  @$pb.TagNumber(24)
  set best3Offer($core.int value) => $_setSignedInt32(23, value);
  @$pb.TagNumber(24)
  $core.bool hasBest3Offer() => $_has(23);
  @$pb.TagNumber(24)
  void clearBest3Offer() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get best3OfferVol => $_getIZ(24);
  @$pb.TagNumber(25)
  set best3OfferVol($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasBest3OfferVol() => $_has(24);
  @$pb.TagNumber(25)
  void clearBest3OfferVol() => $_clearField(25);

  /// ── Khối ngoại ────────────────────────────────────────────────────────────
  @$pb.TagNumber(26)
  $fixnum.Int64 get buyForeignQtty => $_getI64(25);
  @$pb.TagNumber(26)
  set buyForeignQtty($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasBuyForeignQtty() => $_has(25);
  @$pb.TagNumber(26)
  void clearBuyForeignQtty() => $_clearField(26);

  @$pb.TagNumber(27)
  $fixnum.Int64 get sellForeignQtty => $_getI64(26);
  @$pb.TagNumber(27)
  set sellForeignQtty($fixnum.Int64 value) => $_setInt64(26, value);
  @$pb.TagNumber(27)
  $core.bool hasSellForeignQtty() => $_has(26);
  @$pb.TagNumber(27)
  void clearSellForeignQtty() => $_clearField(27);

  /// ── Phiên giao dịch ───────────────────────────────────────────────────────
  @$pb.TagNumber(28)
  $core.String get session => $_getSZ(27);
  @$pb.TagNumber(28)
  set session($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasSession() => $_has(27);
  @$pb.TagNumber(28)
  void clearSession() => $_clearField(28);

  /// ── Thống kê bổ sung ──────────────────────────────────────────────────────
  @$pb.TagNumber(29)
  $core.int get avgPrice => $_getIZ(28);
  @$pb.TagNumber(29)
  set avgPrice($core.int value) => $_setSignedInt32(28, value);
  @$pb.TagNumber(29)
  $core.bool hasAvgPrice() => $_has(28);
  @$pb.TagNumber(29)
  void clearAvgPrice() => $_clearField(29);

  @$pb.TagNumber(30)
  $fixnum.Int64 get buyCount => $_getI64(29);
  @$pb.TagNumber(30)
  set buyCount($fixnum.Int64 value) => $_setInt64(29, value);
  @$pb.TagNumber(30)
  $core.bool hasBuyCount() => $_has(29);
  @$pb.TagNumber(30)
  void clearBuyCount() => $_clearField(30);

  @$pb.TagNumber(31)
  $fixnum.Int64 get sellCount => $_getI64(30);
  @$pb.TagNumber(31)
  set sellCount($fixnum.Int64 value) => $_setInt64(30, value);
  @$pb.TagNumber(31)
  $core.bool hasSellCount() => $_has(30);
  @$pb.TagNumber(31)
  void clearSellCount() => $_clearField(31);

  @$pb.TagNumber(32)
  $fixnum.Int64 get netForeignQtty => $_getI64(31);
  @$pb.TagNumber(32)
  set netForeignQtty($fixnum.Int64 value) => $_setInt64(31, value);
  @$pb.TagNumber(32)
  $core.bool hasNetForeignQtty() => $_has(31);
  @$pb.TagNumber(32)
  void clearNetForeignQtty() => $_clearField(32);

  /// ── Room nước ngoài ───────────────────────────────────────────────────────
  @$pb.TagNumber(33)
  $fixnum.Int64 get foreignRoom => $_getI64(32);
  @$pb.TagNumber(33)
  set foreignRoom($fixnum.Int64 value) => $_setInt64(32, value);
  @$pb.TagNumber(33)
  $core.bool hasForeignRoom() => $_has(32);
  @$pb.TagNumber(33)
  void clearForeignRoom() => $_clearField(33);

  @$pb.TagNumber(34)
  $fixnum.Int64 get currentForeign => $_getI64(33);
  @$pb.TagNumber(34)
  set currentForeign($fixnum.Int64 value) => $_setInt64(33, value);
  @$pb.TagNumber(34)
  $core.bool hasCurrentForeign() => $_has(33);
  @$pb.TagNumber(34)
  void clearCurrentForeign() => $_clearField(34);

  /// ── Giá & KL thỏa thuận (put-through) ────────────────────────────────────
  @$pb.TagNumber(35)
  $core.int get ptMatchedPrice => $_getIZ(34);
  @$pb.TagNumber(35)
  set ptMatchedPrice($core.int value) => $_setSignedInt32(34, value);
  @$pb.TagNumber(35)
  $core.bool hasPtMatchedPrice() => $_has(34);
  @$pb.TagNumber(35)
  void clearPtMatchedPrice() => $_clearField(35);

  @$pb.TagNumber(36)
  $fixnum.Int64 get ptMatchedVolume => $_getI64(35);
  @$pb.TagNumber(36)
  set ptMatchedVolume($fixnum.Int64 value) => $_setInt64(35, value);
  @$pb.TagNumber(36)
  $core.bool hasPtMatchedVolume() => $_has(35);
  @$pb.TagNumber(36)
  void clearPtMatchedVolume() => $_clearField(36);

  /// ── ATO / ATC ─────────────────────────────────────────────────────────────
  @$pb.TagNumber(37)
  $core.int get atoPrice => $_getIZ(36);
  @$pb.TagNumber(37)
  set atoPrice($core.int value) => $_setSignedInt32(36, value);
  @$pb.TagNumber(37)
  $core.bool hasAtoPrice() => $_has(36);
  @$pb.TagNumber(37)
  void clearAtoPrice() => $_clearField(37);

  @$pb.TagNumber(38)
  $core.int get atcPrice => $_getIZ(37);
  @$pb.TagNumber(38)
  set atcPrice($core.int value) => $_setSignedInt32(37, value);
  @$pb.TagNumber(38)
  $core.bool hasAtcPrice() => $_has(37);
  @$pb.TagNumber(38)
  void clearAtcPrice() => $_clearField(38);

  /// ── Dư lệnh ATO/ATC ───────────────────────────────────────────────────────
  @$pb.TagNumber(39)
  $fixnum.Int64 get atoVolume => $_getI64(38);
  @$pb.TagNumber(39)
  set atoVolume($fixnum.Int64 value) => $_setInt64(38, value);
  @$pb.TagNumber(39)
  $core.bool hasAtoVolume() => $_has(38);
  @$pb.TagNumber(39)
  void clearAtoVolume() => $_clearField(39);

  @$pb.TagNumber(40)
  $fixnum.Int64 get atcVolume => $_getI64(39);
  @$pb.TagNumber(40)
  set atcVolume($fixnum.Int64 value) => $_setInt64(39, value);
  @$pb.TagNumber(40)
  $core.bool hasAtcVolume() => $_has(39);
  @$pb.TagNumber(40)
  void clearAtcVolume() => $_clearField(40);

  /// ── Bid/Ask bước 4 & 5 (nếu sàn hỗ trợ) ─────────────────────────────────
  @$pb.TagNumber(41)
  $core.int get best4Bid => $_getIZ(40);
  @$pb.TagNumber(41)
  set best4Bid($core.int value) => $_setSignedInt32(40, value);
  @$pb.TagNumber(41)
  $core.bool hasBest4Bid() => $_has(40);
  @$pb.TagNumber(41)
  void clearBest4Bid() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.int get best4BidVol => $_getIZ(41);
  @$pb.TagNumber(42)
  set best4BidVol($core.int value) => $_setSignedInt32(41, value);
  @$pb.TagNumber(42)
  $core.bool hasBest4BidVol() => $_has(41);
  @$pb.TagNumber(42)
  void clearBest4BidVol() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.int get best5Bid => $_getIZ(42);
  @$pb.TagNumber(43)
  set best5Bid($core.int value) => $_setSignedInt32(42, value);
  @$pb.TagNumber(43)
  $core.bool hasBest5Bid() => $_has(42);
  @$pb.TagNumber(43)
  void clearBest5Bid() => $_clearField(43);

  @$pb.TagNumber(44)
  $core.int get best5BidVol => $_getIZ(43);
  @$pb.TagNumber(44)
  set best5BidVol($core.int value) => $_setSignedInt32(43, value);
  @$pb.TagNumber(44)
  $core.bool hasBest5BidVol() => $_has(43);
  @$pb.TagNumber(44)
  void clearBest5BidVol() => $_clearField(44);

  @$pb.TagNumber(45)
  $core.int get best4Offer => $_getIZ(44);
  @$pb.TagNumber(45)
  set best4Offer($core.int value) => $_setSignedInt32(44, value);
  @$pb.TagNumber(45)
  $core.bool hasBest4Offer() => $_has(44);
  @$pb.TagNumber(45)
  void clearBest4Offer() => $_clearField(45);

  @$pb.TagNumber(46)
  $core.int get best4OfferVol => $_getIZ(45);
  @$pb.TagNumber(46)
  set best4OfferVol($core.int value) => $_setSignedInt32(45, value);
  @$pb.TagNumber(46)
  $core.bool hasBest4OfferVol() => $_has(45);
  @$pb.TagNumber(46)
  void clearBest4OfferVol() => $_clearField(46);

  @$pb.TagNumber(47)
  $core.int get best5Offer => $_getIZ(46);
  @$pb.TagNumber(47)
  set best5Offer($core.int value) => $_setSignedInt32(46, value);
  @$pb.TagNumber(47)
  $core.bool hasBest5Offer() => $_has(46);
  @$pb.TagNumber(47)
  void clearBest5Offer() => $_clearField(47);

  @$pb.TagNumber(48)
  $core.int get best5OfferVol => $_getIZ(47);
  @$pb.TagNumber(48)
  set best5OfferVol($core.int value) => $_setSignedInt32(47, value);
  @$pb.TagNumber(48)
  $core.bool hasBest5OfferVol() => $_has(47);
  @$pb.TagNumber(48)
  void clearBest5OfferVol() => $_clearField(48);

  /// ── Tên sàn ───────────────────────────────────────────────────────────────
  @$pb.TagNumber(49)
  $core.String get exchange => $_getSZ(48);
  @$pb.TagNumber(49)
  set exchange($core.String value) => $_setString(48, value);
  @$pb.TagNumber(49)
  $core.bool hasExchange() => $_has(48);
  @$pb.TagNumber(49)
  void clearExchange() => $_clearField(49);

  /// ── Số dư lệnh mua/bán ────────────────────────────────────────────────────
  @$pb.TagNumber(50)
  $fixnum.Int64 get totalBuyTradeAmount => $_getI64(49);
  @$pb.TagNumber(50)
  set totalBuyTradeAmount($fixnum.Int64 value) => $_setInt64(49, value);
  @$pb.TagNumber(50)
  $core.bool hasTotalBuyTradeAmount() => $_has(49);
  @$pb.TagNumber(50)
  void clearTotalBuyTradeAmount() => $_clearField(50);

  @$pb.TagNumber(51)
  $fixnum.Int64 get totalSellTradeAmount => $_getI64(50);
  @$pb.TagNumber(51)
  set totalSellTradeAmount($fixnum.Int64 value) => $_setInt64(50, value);
  @$pb.TagNumber(51)
  $core.bool hasTotalSellTradeAmount() => $_has(50);
  @$pb.TagNumber(51)
  void clearTotalSellTradeAmount() => $_clearField(51);

  /// ── Market cap / Index weight (nếu có) ────────────────────────────────────
  @$pb.TagNumber(52)
  $core.double get indexWeight => $_getN(51);
  @$pb.TagNumber(52)
  set indexWeight($core.double value) => $_setDouble(51, value);
  @$pb.TagNumber(52)
  $core.bool hasIndexWeight() => $_has(51);
  @$pb.TagNumber(52)
  void clearIndexWeight() => $_clearField(52);

  /// ── Dữ liệu phái sinh / warrant (nếu áp dụng) ────────────────────────────
  @$pb.TagNumber(53)
  $core.int get underlyingPrice => $_getIZ(52);
  @$pb.TagNumber(53)
  set underlyingPrice($core.int value) => $_setSignedInt32(52, value);
  @$pb.TagNumber(53)
  $core.bool hasUnderlyingPrice() => $_has(52);
  @$pb.TagNumber(53)
  void clearUnderlyingPrice() => $_clearField(53);

  @$pb.TagNumber(54)
  $core.double get premium => $_getN(53);
  @$pb.TagNumber(54)
  set premium($core.double value) => $_setDouble(53, value);
  @$pb.TagNumber(54)
  $core.bool hasPremium() => $_has(53);
  @$pb.TagNumber(54)
  void clearPremium() => $_clearField(54);

  @$pb.TagNumber(55)
  $core.double get impliedVol => $_getN(54);
  @$pb.TagNumber(55)
  set impliedVol($core.double value) => $_setDouble(54, value);
  @$pb.TagNumber(55)
  $core.bool hasImpliedVol() => $_has(54);
  @$pb.TagNumber(55)
  void clearImpliedVol() => $_clearField(55);

  @$pb.TagNumber(56)
  $core.double get delta => $_getN(55);
  @$pb.TagNumber(56)
  set delta($core.double value) => $_setDouble(55, value);
  @$pb.TagNumber(56)
  $core.bool hasDelta() => $_has(55);
  @$pb.TagNumber(56)
  void clearDelta() => $_clearField(56);

  /// ── Trạng thái ────────────────────────────────────────────────────────────
  @$pb.TagNumber(57)
  $core.String get tradingStatus => $_getSZ(56);
  @$pb.TagNumber(57)
  set tradingStatus($core.String value) => $_setString(56, value);
  @$pb.TagNumber(57)
  $core.bool hasTradingStatus() => $_has(56);
  @$pb.TagNumber(57)
  void clearTradingStatus() => $_clearField(57);

  /// ── Timestamp ─────────────────────────────────────────────────────────────
  @$pb.TagNumber(58)
  $fixnum.Int64 get tradeDate => $_getI64(57);
  @$pb.TagNumber(58)
  set tradeDate($fixnum.Int64 value) => $_setInt64(57, value);
  @$pb.TagNumber(58)
  $core.bool hasTradeDate() => $_has(57);
  @$pb.TagNumber(58)
  void clearTradeDate() => $_clearField(58);

  @$pb.TagNumber(59)
  $fixnum.Int64 get time => $_getI64(58);
  @$pb.TagNumber(59)
  set time($fixnum.Int64 value) => $_setInt64(58, value);
  @$pb.TagNumber(59)
  $core.bool hasTime() => $_has(58);
  @$pb.TagNumber(59)
  void clearTime() => $_clearField(59);

  /// ── Fields 60–72: reserved / unknown từ JS bundle ─────────────────────────
  @$pb.TagNumber(60)
  $fixnum.Int64 get field60 => $_getI64(59);
  @$pb.TagNumber(60)
  set field60($fixnum.Int64 value) => $_setInt64(59, value);
  @$pb.TagNumber(60)
  $core.bool hasField60() => $_has(59);
  @$pb.TagNumber(60)
  void clearField60() => $_clearField(60);

  @$pb.TagNumber(61)
  $fixnum.Int64 get field61 => $_getI64(60);
  @$pb.TagNumber(61)
  set field61($fixnum.Int64 value) => $_setInt64(60, value);
  @$pb.TagNumber(61)
  $core.bool hasField61() => $_has(60);
  @$pb.TagNumber(61)
  void clearField61() => $_clearField(61);

  @$pb.TagNumber(62)
  $fixnum.Int64 get field62 => $_getI64(61);
  @$pb.TagNumber(62)
  set field62($fixnum.Int64 value) => $_setInt64(61, value);
  @$pb.TagNumber(62)
  $core.bool hasField62() => $_has(61);
  @$pb.TagNumber(62)
  void clearField62() => $_clearField(62);

  @$pb.TagNumber(63)
  $fixnum.Int64 get field63 => $_getI64(62);
  @$pb.TagNumber(63)
  set field63($fixnum.Int64 value) => $_setInt64(62, value);
  @$pb.TagNumber(63)
  $core.bool hasField63() => $_has(62);
  @$pb.TagNumber(63)
  void clearField63() => $_clearField(63);

  @$pb.TagNumber(64)
  $fixnum.Int64 get field64 => $_getI64(63);
  @$pb.TagNumber(64)
  set field64($fixnum.Int64 value) => $_setInt64(63, value);
  @$pb.TagNumber(64)
  $core.bool hasField64() => $_has(63);
  @$pb.TagNumber(64)
  void clearField64() => $_clearField(64);

  @$pb.TagNumber(65)
  $fixnum.Int64 get field65 => $_getI64(64);
  @$pb.TagNumber(65)
  set field65($fixnum.Int64 value) => $_setInt64(64, value);
  @$pb.TagNumber(65)
  $core.bool hasField65() => $_has(64);
  @$pb.TagNumber(65)
  void clearField65() => $_clearField(65);

  @$pb.TagNumber(66)
  $fixnum.Int64 get field66 => $_getI64(65);
  @$pb.TagNumber(66)
  set field66($fixnum.Int64 value) => $_setInt64(65, value);
  @$pb.TagNumber(66)
  $core.bool hasField66() => $_has(65);
  @$pb.TagNumber(66)
  void clearField66() => $_clearField(66);

  @$pb.TagNumber(67)
  $fixnum.Int64 get field67 => $_getI64(66);
  @$pb.TagNumber(67)
  set field67($fixnum.Int64 value) => $_setInt64(66, value);
  @$pb.TagNumber(67)
  $core.bool hasField67() => $_has(66);
  @$pb.TagNumber(67)
  void clearField67() => $_clearField(67);

  @$pb.TagNumber(68)
  $fixnum.Int64 get field68 => $_getI64(67);
  @$pb.TagNumber(68)
  set field68($fixnum.Int64 value) => $_setInt64(67, value);
  @$pb.TagNumber(68)
  $core.bool hasField68() => $_has(67);
  @$pb.TagNumber(68)
  void clearField68() => $_clearField(68);

  @$pb.TagNumber(69)
  $fixnum.Int64 get field69 => $_getI64(68);
  @$pb.TagNumber(69)
  set field69($fixnum.Int64 value) => $_setInt64(68, value);
  @$pb.TagNumber(69)
  $core.bool hasField69() => $_has(68);
  @$pb.TagNumber(69)
  void clearField69() => $_clearField(69);

  @$pb.TagNumber(70)
  $fixnum.Int64 get field70 => $_getI64(69);
  @$pb.TagNumber(70)
  set field70($fixnum.Int64 value) => $_setInt64(69, value);
  @$pb.TagNumber(70)
  $core.bool hasField70() => $_has(69);
  @$pb.TagNumber(70)
  void clearField70() => $_clearField(70);

  @$pb.TagNumber(71)
  $fixnum.Int64 get field71 => $_getI64(70);
  @$pb.TagNumber(71)
  set field71($fixnum.Int64 value) => $_setInt64(70, value);
  @$pb.TagNumber(71)
  $core.bool hasField71() => $_has(70);
  @$pb.TagNumber(71)
  void clearField71() => $_clearField(71);

  @$pb.TagNumber(72)
  $fixnum.Int64 get field72 => $_getI64(71);
  @$pb.TagNumber(72)
  set field72($fixnum.Int64 value) => $_setInt64(71, value);
  @$pb.TagNumber(72)
  $core.bool hasField72() => $_has(71);
  @$pb.TagNumber(72)
  void clearField72() => $_clearField(72);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
