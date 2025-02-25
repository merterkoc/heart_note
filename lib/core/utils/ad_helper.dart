import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdType { banner, interstitial, rewarded }

class AdHelper {
  final String? bannerAdUnitId;
  final String? interstitialAdUnitId;
  final String? rewardedAdUnitId;

  AdHelper({
    this.bannerAdUnitId,
    this.interstitialAdUnitId,
    this.rewardedAdUnitId,
  });

  factory AdHelper.create() {
    if (kDebugMode) {
      return AdHelper(
        bannerAdUnitId:
            'ca-app-pub-3940256099942544/6300978111', // Android test banner ad unit ID
        interstitialAdUnitId:
            'ca-app-pub-3940256099942544/1033173712', // Android test interstitial ad unit ID
        rewardedAdUnitId:
            'ca-app-pub-3940256099942544/5224354917', // Android test rewarded ad unit ID
      );
    } else {
      return AdHelper(
        bannerAdUnitId:
            '<YOUR_BANNER_AD_UNIT_ID>', // Kendi banner reklam birimi kimliğinizle değiştirin
        interstitialAdUnitId:
            '<YOUR_INTERSTITIAL_AD_UNIT_ID>', // Kendi geçiş reklamı birimi kimliğinizle değiştirin
        rewardedAdUnitId:
            '<YOUR_REWARDED_AD_UNIT_ID>', // Kendi ödüllü reklam birimi kimliğinizle değiştirin
      );
    }
  }

  String? getAdUnitId(AdType adType) {
    switch (adType) {
      case AdType.banner:
        return bannerAdUnitId;
      case AdType.interstitial:
        return interstitialAdUnitId;
      case AdType.rewarded:
        return rewardedAdUnitId;
      default:
        return null;
    }
  }
}
