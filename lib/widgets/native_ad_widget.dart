import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services_ads_storage_local/ad_mob_service.dart';

/// Native Ad Widget that can be embedded in any screen
/// Auto-refreshes every 10 seconds to maximize ad revenue
class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 60);

 @override
  void initState() {
    super.initState();
    _loadAd();
    _startAutoRefresh();
  }

  void _loadAd() {
    // Dispose old ad before loading new one
    _nativeAd?.dispose();
    _isAdLoaded = false;
    
    _nativeAd = AdMobService().loadNativeAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        if (mounted) {
          setState(() {
            _isAdLoaded = false;
          });
        }
      },
    );
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      if (mounted) {
        _loadAd(); // Reload ad every 10 seconds
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AdWidget(ad: _nativeAd!),
      ),
    );
  }
}
