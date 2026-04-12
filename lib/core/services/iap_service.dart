import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/app_constants.dart';

class IapService {
  IapService._();

  static const productId = 'ftrade_premium_monthly';

  static final _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _sub;

  // Broadcasts true when premium is activated
  static final _premiumController = StreamController<bool>.broadcast();
  static Stream<bool> get premiumStream => _premiumController.stream;

  static String? _lastError;
  static String? get lastError => _lastError;

  static Future<void> init() async {
    _sub?.cancel();
    _sub = _iap.purchaseStream.listen(_onPurchases, onError: (e) {
      debugPrint('IAP stream error: $e');
    });
  }

  static Future<ProductDetails?> loadProduct() async {
    final available = await _iap.isAvailable();
    if (!available) return null;
    final resp = await _iap.queryProductDetails({productId});
    if (resp.productDetails.isEmpty) return null;
    return resp.productDetails.first;
  }

  static Future<bool> buyPremium(ProductDetails product) async {
    _lastError = null;
    final param = PurchaseParam(productDetails: product);
    try {
      return await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  static Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        final ok = await _verifyWithBackend(p);
        if (ok) _premiumController.add(true);
      } else if (p.status == PurchaseStatus.error) {
        _lastError = p.error?.message;
        debugPrint('IAP error: ${p.error}');
      }
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
  }

  static Future<bool> _verifyWithBackend(PurchaseDetails p) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) return false;

      final body = Platform.isIOS
          ? {'platform': 'ios', 'receiptData': p.verificationData.serverVerificationData, 'productId': p.productID}
          : {'platform': 'android', 'purchaseToken': p.verificationData.serverVerificationData, 'productId': p.productID};

      final resp = await Dio().post(
        '${AppConstants.functionsBaseUrl}/iap/verify',
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return resp.data['success'] == true;
    } catch (e) {
      debugPrint('IAP verify error: $e');
      return false;
    }
  }

  static void dispose() {
    _sub?.cancel();
    _premiumController.close();
  }
}
