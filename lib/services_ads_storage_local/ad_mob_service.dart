import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // Native Advanced Ad Units (2 available - rotating for better fill rate)
  static final String _productionNativeAdUnitId1 = dotenv.get('PRODUCTION_NATIVE_AD_UNIT_ID1'); // native ads
  static  final String _productionNativeAdUnitId2 =
      dotenv.get('PRODUCTION_NATIVE_AD_UNIT_ID2'); // fitn

  // Rewarded Interstitial Ad Unit
  static final  String _productionRewardedAdUnitId =
     dotenv.get('PRODUCTION_REWARDED_AD_UNIT_ID'); // adsrewoersvidoe

  // Test Ad Unit IDs (for development only)
  static final String _testNativeAdUnitId = dotenv.get('TEST_NATIVE_AD_UNIT_ID1');
      static final String _testRewardedAdUnitId =dotenv.get('TEST_REWARDED_AD_UNIT_ID');
  static int _nativeAdIndex = 0;

  // Use production IDs by default, test IDs in debug mode
  static String get nativeAdUnitId {
    if (kDebugMode) {
      return _testNativeAdUnitId;
    }

    // Alternate between two native ad units for better fill rate
    _nativeAdIndex = (_nativeAdIndex + 1) % 2;
    return _nativeAdIndex == 0
        ? _productionNativeAdUnitId1
        : _productionNativeAdUnitId2;
  }

  static String get rewardedAdUnitId {
    return kDebugMode ? _testRewardedAdUnitId : _productionRewardedAdUnitId;
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Track loaded ads for proper cleanup
  final List<NativeAd> _loadedAds = [];
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool get isRewardedAdReady => _isRewardedAdReady;

  Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) {
        debugPrint('⚠️ AdMob SDK already initialized');
      }
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('✅ AdMob SDK initialized successfully');
        debugPrint('📱 Using ${kDebugMode ? "TEST" : "PRODUCTION"} ad units');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to initialize AdMob SDK: $e');
      }
      rethrow;
    }
  }

  /// Load a Native Ad with improved error handling
  NativeAd loadNativeAd({
    required Function(NativeAd ad) onAdLoaded,
    required Function(NativeAd ad, LoadAdError error) onAdFailedToLoad,
  }) {
    final ad = NativeAd(
      adUnitId: nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          final nativeAd = ad as NativeAd;
          _loadedAds.add(nativeAd);
          if (kDebugMode) {
            debugPrint(
              '✅ Native Ad loaded successfully (Total active ads: ${_loadedAds.length})',
            );
          }
          onAdLoaded(nativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            debugPrint('❌ Native Ad failed to load: ${error.message}');
          }
          ad.dispose();
          onAdFailedToLoad(ad as NativeAd, error);
        },
        onAdClicked: (ad) {
          if (kDebugMode) debugPrint('👆 Native Ad clicked');
        },
        onAdImpression: (ad) {
          if (kDebugMode) debugPrint('👁️ Native Ad impression recorded');
        },
        onAdClosed: (ad) {
          if (kDebugMode) debugPrint('🔒 Native Ad closed');
        },
        onAdOpened: (ad) {
          if (kDebugMode) debugPrint('🔓 Native Ad opened');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: const Color(0xFFF7F8F8),
        cornerRadius: 16.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFFB4C0FE),
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF1D1617),
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF7B6F72),
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFF7B6F72),
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      ),
    );

    ad.load();
    return ad;
  }

  /// Dispose a specific ad and remove from tracking
  void disposeAd(NativeAd ad) {
    ad.dispose();
    _loadedAds.remove(ad);
    if (kDebugMode) {
      debugPrint('🗑️ Ad disposed (Remaining active ads: ${_loadedAds.length})');
    }
  }

  /// Dispose all active ads - call this when app is closing
  void disposeAll() {
    if (kDebugMode) {
      debugPrint('🗑️ Disposing all ads (${_loadedAds.length} active ads)');
    }
    for (var ad in _loadedAds) {
      ad.dispose();
    }
    _loadedAds.clear();
  }

  /// Load a Rewarded Ad
  void loadRewardedAd({
    Function()? onAdLoaded,
    Function(LoadAdError error)? onAdFailedToLoad,
    Function(AdWithoutView ad, RewardItem reward)? onUserEarnedReward,
  }) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _setRewardedAdCallbacks(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: onAdFailedToLoad,
            onUserEarnedReward: onUserEarnedReward,
          );
          if (kDebugMode) {
            debugPrint('✅ Rewarded Ad loaded successfully');
          }
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('❌ Rewarded Ad failed to load: ${error.message}');
          }
          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Private helper to set full screen callbacks and reduce complexity
  void _setRewardedAdCallbacks({
    Function()? onAdLoaded,
    Function(LoadAdError error)? onAdFailedToLoad,
    Function(AdWithoutView ad, RewardItem reward)? onUserEarnedReward,
  }) {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) debugPrint('🎬 Rewarded Ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) debugPrint('❌ Rewarded Ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        // Auto-reload next ad
        loadRewardedAd(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
          onUserEarnedReward: onUserEarnedReward,
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) debugPrint('❌ Rewarded Ad failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
      },
      onAdImpression: (ad) {
        if (kDebugMode) debugPrint('👁️ Rewarded Ad impression recorded');
      },
    );
  }

  /// Show the loaded rewarded ad
  Future<void> showRewardedAd({
    required Function(AdWithoutView ad, RewardItem reward) onUserEarnedReward,
  }) async {
    if (_rewardedAd == null || !_isRewardedAdReady) {
      if (kDebugMode) {
        debugPrint('⚠️ Rewarded Ad not ready to show');
      }
      return;
    }

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        if (kDebugMode) {
          debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
        }
        onUserEarnedReward(ad, reward);
      },
    );
  }

  /// Dispose the rewarded ad
  void disposeRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
    if (kDebugMode) {
      debugPrint('🗑️ Rewarded Ad disposed');
    }
  }

  /// Get the current environment (production or test)
  String get currentEnvironment =>
      kDebugMode ? 'TEST (Debug Mode)' : 'PRODUCTION (Release Mode)';

  /// Check if test ads are being used
  bool get isUsingTestAds => kDebugMode;
}
