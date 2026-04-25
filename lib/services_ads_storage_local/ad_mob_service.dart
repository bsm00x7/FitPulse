import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();
  // Production Ad Unit IDs
  static const String _productionAppId =
      'ca-app-pub-3890360716260111~2101330014';
  // Native Advanced Ad Units (2 available - rotating for better fill rate)
  static const String _productionNativeAdUnitId1 =
      'ca-app-pub-3890360716260111/5242977604'; // Ads Natif
  static const String _productionNativeAdUnitId2 =
      'ca-app-pub-3890360716260111/6939457217'; // fitn

  // Rewarded Interstitial Ad Unit
  static const String _productionRewardedAdUnitId =
      'ca-app-pub-3890360716260111/4485217096'; // adsrewoersvidoe

  // Test Ad Unit IDs (for development only)
  static const String _testNativeAdUnitId =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // Track which native ad unit to use (alternate for better fill rate)
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
        print('⚠️ AdMob SDK already initialized');
      }
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      if (kDebugMode) {
        print('✅ AdMob SDK initialized successfully');
        print('📱 Using ${kDebugMode ? "TEST" : "PRODUCTION"} ad units');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize AdMob SDK: $e');
      }
      rethrow;
    }
  }

  /// Load a Native Ad with improved error handling
  /// [onAdLoaded] callback when ad loads successfully
  /// [onAdFailedToLoad] callback when ad fails to load
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
            print(
              '✅ Native Ad loaded successfully (Total active ads: ${_loadedAds.length})',
            );
          }

          onAdLoaded(nativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('❌ Native Ad failed to load:');
            print('   Code: ${error.code}');
            print('   Message: ${error.message}');
            print('   Domain: ${error.domain}');
          }

          ad.dispose();
          onAdFailedToLoad(ad as NativeAd, error);
        },
        onAdClicked: (ad) {
          if (kDebugMode) {
            print('👆 Native Ad clicked');
          }
        },
        onAdImpression: (ad) {
          if (kDebugMode) {
            print('👁️ Native Ad impression recorded');
          }
        },
        onAdClosed: (ad) {
          if (kDebugMode) {
            print('🔒 Native Ad closed');
          }
        },
        onAdOpened: (ad) {
          if (kDebugMode) {
            print('🔓 Native Ad opened');
          }
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

    // Load the ad
    ad.load();

    return ad;
  }

  /// Dispose a specific ad and remove from tracking
  void disposeAd(NativeAd ad) {
    ad.dispose();
    _loadedAds.remove(ad);

    if (kDebugMode) {
      print('🗑️ Ad disposed (Remaining active ads: ${_loadedAds.length})');
    }
  }

  /// Dispose all active ads - call this when app is closing
  void disposeAll() {
    if (kDebugMode) {
      print('🗑️ Disposing all ads (${_loadedAds.length} active ads)');
    }

    for (var ad in _loadedAds) {
      ad.dispose();
    }
    _loadedAds.clear();
  }

  /// Load a Rewarded Ad
  /// [onAdLoaded] callback when ad loads successfully
  /// [onAdFailedToLoad] callback when ad fails to load
  /// [onUserEarnedReward] callback when user earns reward by watching the ad
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

          // Set up full screen content callback
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (kDebugMode) {
                print('🎬 Rewarded Ad showed full screen content');
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              if (kDebugMode) {
                print('❌ Rewarded Ad dismissed');
              }
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
              if (kDebugMode) {
                print('❌ Rewarded Ad failed to show: ${error.message}');
              }
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
            },
            onAdImpression: (ad) {
              if (kDebugMode) {
                print('👁️ Rewarded Ad impression recorded');
              }
            },
          );

          if (kDebugMode) {
            print('✅ Rewarded Ad loaded successfully');
          }

          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('❌ Rewarded Ad failed to load:');
            print('   Code: ${error.code}');
            print('   Message: ${error.message}');
            print('   Domain: ${error.domain}');
          }

          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Show the loaded rewarded ad
  /// [onUserEarnedReward] callback when user completes watching and earns reward
  Future<void> showRewardedAd({
    required Function(AdWithoutView ad, RewardItem reward) onUserEarnedReward,
  }) async {
    if (_rewardedAd == null || !_isRewardedAdReady) {
      if (kDebugMode) {
        print('⚠️ Rewarded Ad not ready to show');
      }
      return;
    }

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        if (kDebugMode) {
          print('🎁 User earned reward:');
          print('   Type: ${reward.type}');
          print('   Amount: ${reward.amount}');
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
      print('🗑️ Rewarded Ad disposed');
    }
  }

  /// Get the current environment (production or test)
  String get currentEnvironment =>
      kDebugMode ? 'TEST (Debug Mode)' : 'PRODUCTION (Release Mode)';

  /// Check if test ads are being used
  bool get isUsingTestAds => kDebugMode;
}
