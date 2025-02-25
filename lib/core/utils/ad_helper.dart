import 'package:flutter/foundation.dart';

enum AdType { banner, interstitial }

class AdHelper {
  final String? bannerAdUnitId;
  final String? interstitialAdUnitId;

  AdHelper({
    this.bannerAdUnitId,
    this.interstitialAdUnitId,
  });

  factory AdHelper.create() {
    if (kDebugMode) {
      return AdHelper(
        bannerAdUnitId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialAdUnitId: 'ca-app-pub-3940256099942544/1033173712',
      );
    } else {
      return AdHelper(
        bannerAdUnitId: 'ca-app-pub-1828238571410767/5671706060',
        interstitialAdUnitId: 'ca-app-pub-1828238571410767/1979070734',
      );
    }
  }

  String? getAdUnitId(AdType adType) {
    switch (adType) {
      case AdType.banner:
        return bannerAdUnitId;
      case AdType.interstitial:
        return interstitialAdUnitId;
      default:
        return null;
    }
  }
}
