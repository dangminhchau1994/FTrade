// This is a generated file - do not edit.
//
// Generated from proto/stock_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use stockDataDescriptor instead')
const StockData$json = {
  '1': 'StockData',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'matched_price', '3': 2, '4': 1, '5': 5, '10': 'matchedPrice'},
    {'1': 'matched_volume', '3': 3, '4': 1, '5': 5, '10': 'matchedVolume'},
    {'1': 'price_change', '3': 4, '4': 1, '5': 17, '10': 'priceChange'},
    {
      '1': 'price_change_percent',
      '3': 5,
      '4': 1,
      '5': 17,
      '10': 'priceChangePercent'
    },
    {'1': 'total_volume', '3': 6, '4': 1, '5': 3, '10': 'totalVolume'},
    {'1': 'total_value', '3': 7, '4': 1, '5': 3, '10': 'totalValue'},
    {'1': 'open_price', '3': 8, '4': 1, '5': 5, '10': 'openPrice'},
    {'1': 'high_price', '3': 9, '4': 1, '5': 5, '10': 'highPrice'},
    {'1': 'low_price', '3': 10, '4': 1, '5': 5, '10': 'lowPrice'},
    {'1': 'ceiling', '3': 11, '4': 1, '5': 5, '10': 'ceiling'},
    {'1': 'floor', '3': 12, '4': 1, '5': 5, '10': 'floor'},
    {'1': 'ref_price', '3': 13, '4': 1, '5': 5, '10': 'refPrice'},
    {'1': 'best1_bid', '3': 14, '4': 1, '5': 5, '10': 'best1Bid'},
    {'1': 'best1_bid_vol', '3': 15, '4': 1, '5': 5, '10': 'best1BidVol'},
    {'1': 'best2_bid', '3': 16, '4': 1, '5': 5, '10': 'best2Bid'},
    {'1': 'best2_bid_vol', '3': 17, '4': 1, '5': 5, '10': 'best2BidVol'},
    {'1': 'best3_bid', '3': 18, '4': 1, '5': 5, '10': 'best3Bid'},
    {'1': 'best3_bid_vol', '3': 19, '4': 1, '5': 5, '10': 'best3BidVol'},
    {'1': 'best1_offer', '3': 20, '4': 1, '5': 5, '10': 'best1Offer'},
    {'1': 'best1_offer_vol', '3': 21, '4': 1, '5': 5, '10': 'best1OfferVol'},
    {'1': 'best2_offer', '3': 22, '4': 1, '5': 5, '10': 'best2Offer'},
    {'1': 'best2_offer_vol', '3': 23, '4': 1, '5': 5, '10': 'best2OfferVol'},
    {'1': 'best3_offer', '3': 24, '4': 1, '5': 5, '10': 'best3Offer'},
    {'1': 'best3_offer_vol', '3': 25, '4': 1, '5': 5, '10': 'best3OfferVol'},
    {'1': 'buy_foreign_qtty', '3': 26, '4': 1, '5': 3, '10': 'buyForeignQtty'},
    {
      '1': 'sell_foreign_qtty',
      '3': 27,
      '4': 1,
      '5': 3,
      '10': 'sellForeignQtty'
    },
    {'1': 'session', '3': 28, '4': 1, '5': 9, '10': 'session'},
    {'1': 'avg_price', '3': 29, '4': 1, '5': 5, '10': 'avgPrice'},
    {'1': 'buy_count', '3': 30, '4': 1, '5': 3, '10': 'buyCount'},
    {'1': 'sell_count', '3': 31, '4': 1, '5': 3, '10': 'sellCount'},
    {'1': 'net_foreign_qtty', '3': 32, '4': 1, '5': 3, '10': 'netForeignQtty'},
    {'1': 'foreign_room', '3': 33, '4': 1, '5': 3, '10': 'foreignRoom'},
    {'1': 'current_foreign', '3': 34, '4': 1, '5': 3, '10': 'currentForeign'},
    {'1': 'pt_matched_price', '3': 35, '4': 1, '5': 5, '10': 'ptMatchedPrice'},
    {
      '1': 'pt_matched_volume',
      '3': 36,
      '4': 1,
      '5': 3,
      '10': 'ptMatchedVolume'
    },
    {'1': 'ato_price', '3': 37, '4': 1, '5': 5, '10': 'atoPrice'},
    {'1': 'atc_price', '3': 38, '4': 1, '5': 5, '10': 'atcPrice'},
    {'1': 'ato_volume', '3': 39, '4': 1, '5': 3, '10': 'atoVolume'},
    {'1': 'atc_volume', '3': 40, '4': 1, '5': 3, '10': 'atcVolume'},
    {'1': 'best4_bid', '3': 41, '4': 1, '5': 5, '10': 'best4Bid'},
    {'1': 'best4_bid_vol', '3': 42, '4': 1, '5': 5, '10': 'best4BidVol'},
    {'1': 'best5_bid', '3': 43, '4': 1, '5': 5, '10': 'best5Bid'},
    {'1': 'best5_bid_vol', '3': 44, '4': 1, '5': 5, '10': 'best5BidVol'},
    {'1': 'best4_offer', '3': 45, '4': 1, '5': 5, '10': 'best4Offer'},
    {'1': 'best4_offer_vol', '3': 46, '4': 1, '5': 5, '10': 'best4OfferVol'},
    {'1': 'best5_offer', '3': 47, '4': 1, '5': 5, '10': 'best5Offer'},
    {'1': 'best5_offer_vol', '3': 48, '4': 1, '5': 5, '10': 'best5OfferVol'},
    {'1': 'exchange', '3': 49, '4': 1, '5': 9, '10': 'exchange'},
    {
      '1': 'total_buy_trade_amount',
      '3': 50,
      '4': 1,
      '5': 3,
      '10': 'totalBuyTradeAmount'
    },
    {
      '1': 'total_sell_trade_amount',
      '3': 51,
      '4': 1,
      '5': 3,
      '10': 'totalSellTradeAmount'
    },
    {'1': 'index_weight', '3': 52, '4': 1, '5': 1, '10': 'indexWeight'},
    {'1': 'underlying_price', '3': 53, '4': 1, '5': 5, '10': 'underlyingPrice'},
    {'1': 'premium', '3': 54, '4': 1, '5': 1, '10': 'premium'},
    {'1': 'implied_vol', '3': 55, '4': 1, '5': 1, '10': 'impliedVol'},
    {'1': 'delta', '3': 56, '4': 1, '5': 1, '10': 'delta'},
    {'1': 'trading_status', '3': 57, '4': 1, '5': 9, '10': 'tradingStatus'},
    {'1': 'trade_date', '3': 58, '4': 1, '5': 3, '10': 'tradeDate'},
    {'1': 'time', '3': 59, '4': 1, '5': 3, '10': 'time'},
    {'1': 'field60', '3': 60, '4': 1, '5': 3, '10': 'field60'},
    {'1': 'field61', '3': 61, '4': 1, '5': 3, '10': 'field61'},
    {'1': 'field62', '3': 62, '4': 1, '5': 3, '10': 'field62'},
    {'1': 'field63', '3': 63, '4': 1, '5': 3, '10': 'field63'},
    {'1': 'field64', '3': 64, '4': 1, '5': 3, '10': 'field64'},
    {'1': 'field65', '3': 65, '4': 1, '5': 3, '10': 'field65'},
    {'1': 'field66', '3': 66, '4': 1, '5': 3, '10': 'field66'},
    {'1': 'field67', '3': 67, '4': 1, '5': 3, '10': 'field67'},
    {'1': 'field68', '3': 68, '4': 1, '5': 3, '10': 'field68'},
    {'1': 'field69', '3': 69, '4': 1, '5': 3, '10': 'field69'},
    {'1': 'field70', '3': 70, '4': 1, '5': 3, '10': 'field70'},
    {'1': 'field71', '3': 71, '4': 1, '5': 3, '10': 'field71'},
    {'1': 'field72', '3': 72, '4': 1, '5': 3, '10': 'field72'},
  ],
};

/// Descriptor for `StockData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockDataDescriptor = $convert.base64Decode(
    'CglTdG9ja0RhdGESFgoGc3ltYm9sGAEgASgJUgZzeW1ib2wSIwoNbWF0Y2hlZF9wcmljZRgCIA'
    'EoBVIMbWF0Y2hlZFByaWNlEiUKDm1hdGNoZWRfdm9sdW1lGAMgASgFUg1tYXRjaGVkVm9sdW1l'
    'EiEKDHByaWNlX2NoYW5nZRgEIAEoEVILcHJpY2VDaGFuZ2USMAoUcHJpY2VfY2hhbmdlX3Blcm'
    'NlbnQYBSABKBFSEnByaWNlQ2hhbmdlUGVyY2VudBIhCgx0b3RhbF92b2x1bWUYBiABKANSC3Rv'
    'dGFsVm9sdW1lEh8KC3RvdGFsX3ZhbHVlGAcgASgDUgp0b3RhbFZhbHVlEh0KCm9wZW5fcHJpY2'
    'UYCCABKAVSCW9wZW5QcmljZRIdCgpoaWdoX3ByaWNlGAkgASgFUgloaWdoUHJpY2USGwoJbG93'
    'X3ByaWNlGAogASgFUghsb3dQcmljZRIYCgdjZWlsaW5nGAsgASgFUgdjZWlsaW5nEhQKBWZsb2'
    '9yGAwgASgFUgVmbG9vchIbCglyZWZfcHJpY2UYDSABKAVSCHJlZlByaWNlEhsKCWJlc3QxX2Jp'
    'ZBgOIAEoBVIIYmVzdDFCaWQSIgoNYmVzdDFfYmlkX3ZvbBgPIAEoBVILYmVzdDFCaWRWb2wSGw'
    'oJYmVzdDJfYmlkGBAgASgFUghiZXN0MkJpZBIiCg1iZXN0Ml9iaWRfdm9sGBEgASgFUgtiZXN0'
    'MkJpZFZvbBIbCgliZXN0M19iaWQYEiABKAVSCGJlc3QzQmlkEiIKDWJlc3QzX2JpZF92b2wYEy'
    'ABKAVSC2Jlc3QzQmlkVm9sEh8KC2Jlc3QxX29mZmVyGBQgASgFUgpiZXN0MU9mZmVyEiYKD2Jl'
    'c3QxX29mZmVyX3ZvbBgVIAEoBVINYmVzdDFPZmZlclZvbBIfCgtiZXN0Ml9vZmZlchgWIAEoBV'
    'IKYmVzdDJPZmZlchImCg9iZXN0Ml9vZmZlcl92b2wYFyABKAVSDWJlc3QyT2ZmZXJWb2wSHwoL'
    'YmVzdDNfb2ZmZXIYGCABKAVSCmJlc3QzT2ZmZXISJgoPYmVzdDNfb2ZmZXJfdm9sGBkgASgFUg'
    '1iZXN0M09mZmVyVm9sEigKEGJ1eV9mb3JlaWduX3F0dHkYGiABKANSDmJ1eUZvcmVpZ25RdHR5'
    'EioKEXNlbGxfZm9yZWlnbl9xdHR5GBsgASgDUg9zZWxsRm9yZWlnblF0dHkSGAoHc2Vzc2lvbh'
    'gcIAEoCVIHc2Vzc2lvbhIbCglhdmdfcHJpY2UYHSABKAVSCGF2Z1ByaWNlEhsKCWJ1eV9jb3Vu'
    'dBgeIAEoA1IIYnV5Q291bnQSHQoKc2VsbF9jb3VudBgfIAEoA1IJc2VsbENvdW50EigKEG5ldF'
    '9mb3JlaWduX3F0dHkYICABKANSDm5ldEZvcmVpZ25RdHR5EiEKDGZvcmVpZ25fcm9vbRghIAEo'
    'A1ILZm9yZWlnblJvb20SJwoPY3VycmVudF9mb3JlaWduGCIgASgDUg5jdXJyZW50Rm9yZWlnbh'
    'IoChBwdF9tYXRjaGVkX3ByaWNlGCMgASgFUg5wdE1hdGNoZWRQcmljZRIqChFwdF9tYXRjaGVk'
    'X3ZvbHVtZRgkIAEoA1IPcHRNYXRjaGVkVm9sdW1lEhsKCWF0b19wcmljZRglIAEoBVIIYXRvUH'
    'JpY2USGwoJYXRjX3ByaWNlGCYgASgFUghhdGNQcmljZRIdCgphdG9fdm9sdW1lGCcgASgDUglh'
    'dG9Wb2x1bWUSHQoKYXRjX3ZvbHVtZRgoIAEoA1IJYXRjVm9sdW1lEhsKCWJlc3Q0X2JpZBgpIA'
    'EoBVIIYmVzdDRCaWQSIgoNYmVzdDRfYmlkX3ZvbBgqIAEoBVILYmVzdDRCaWRWb2wSGwoJYmVz'
    'dDVfYmlkGCsgASgFUghiZXN0NUJpZBIiCg1iZXN0NV9iaWRfdm9sGCwgASgFUgtiZXN0NUJpZF'
    'ZvbBIfCgtiZXN0NF9vZmZlchgtIAEoBVIKYmVzdDRPZmZlchImCg9iZXN0NF9vZmZlcl92b2wY'
    'LiABKAVSDWJlc3Q0T2ZmZXJWb2wSHwoLYmVzdDVfb2ZmZXIYLyABKAVSCmJlc3Q1T2ZmZXISJg'
    'oPYmVzdDVfb2ZmZXJfdm9sGDAgASgFUg1iZXN0NU9mZmVyVm9sEhoKCGV4Y2hhbmdlGDEgASgJ'
    'UghleGNoYW5nZRIzChZ0b3RhbF9idXlfdHJhZGVfYW1vdW50GDIgASgDUhN0b3RhbEJ1eVRyYW'
    'RlQW1vdW50EjUKF3RvdGFsX3NlbGxfdHJhZGVfYW1vdW50GDMgASgDUhR0b3RhbFNlbGxUcmFk'
    'ZUFtb3VudBIhCgxpbmRleF93ZWlnaHQYNCABKAFSC2luZGV4V2VpZ2h0EikKEHVuZGVybHlpbm'
    'dfcHJpY2UYNSABKAVSD3VuZGVybHlpbmdQcmljZRIYCgdwcmVtaXVtGDYgASgBUgdwcmVtaXVt'
    'Eh8KC2ltcGxpZWRfdm9sGDcgASgBUgppbXBsaWVkVm9sEhQKBWRlbHRhGDggASgBUgVkZWx0YR'
    'IlCg50cmFkaW5nX3N0YXR1cxg5IAEoCVINdHJhZGluZ1N0YXR1cxIdCgp0cmFkZV9kYXRlGDog'
    'ASgDUgl0cmFkZURhdGUSEgoEdGltZRg7IAEoA1IEdGltZRIYCgdmaWVsZDYwGDwgASgDUgdmaW'
    'VsZDYwEhgKB2ZpZWxkNjEYPSABKANSB2ZpZWxkNjESGAoHZmllbGQ2Mhg+IAEoA1IHZmllbGQ2'
    'MhIYCgdmaWVsZDYzGD8gASgDUgdmaWVsZDYzEhgKB2ZpZWxkNjQYQCABKANSB2ZpZWxkNjQSGA'
    'oHZmllbGQ2NRhBIAEoA1IHZmllbGQ2NRIYCgdmaWVsZDY2GEIgASgDUgdmaWVsZDY2EhgKB2Zp'
    'ZWxkNjcYQyABKANSB2ZpZWxkNjcSGAoHZmllbGQ2OBhEIAEoA1IHZmllbGQ2OBIYCgdmaWVsZD'
    'Y5GEUgASgDUgdmaWVsZDY5EhgKB2ZpZWxkNzAYRiABKANSB2ZpZWxkNzASGAoHZmllbGQ3MRhH'
    'IAEoA1IHZmllbGQ3MRIYCgdmaWVsZDcyGEggASgDUgdmaWVsZDcy');
