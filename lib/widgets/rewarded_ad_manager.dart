import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fitness/services/ad_mob_service.dart';

/// Rewarded Video Ad Manager
/// Manages loading, showing, and handling rewards from rewarded video ads
class RewardedAdManager extends StatefulWidget {
  /// Callback when user earns a reward
  final Function(RewardItem reward)? onRewardEarned;
  
  /// Custom reward button widget
  final Widget? customButton;
  
  /// Auto-load ad on init
  final bool autoLoad;

  const RewardedAdManager({
    super.key,
    this.onRewardEarned,
    this.customButton,
    this.autoLoad = true,
  });

  @override
  State<RewardedAdManager> createState() => _RewardedAdManagerState();
}

class _RewardedAdManagerState extends State<RewardedAdManager> {
  final AdMobService _adMobService = AdMobService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoLoad) {
      _loadRewardedAd();
    }
  }

  void _loadRewardedAd() {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    _adMobService.loadRewardedAd(
      onAdLoaded: () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      onAdFailedToLoad: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load ad: ${error.message}'),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      },
    );
  }

  Future<void> _showRewardedAd() async {
    if (!_adMobService.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad is not ready yet. Please wait...'),
          backgroundColor: Color(0xFFFFAA00),
        ),
      );
      return;
    }

    await _adMobService.showRewardedAd(
      onUserEarnedReward: (ad, reward) {
        // User earned the reward
        if (mounted) {
          widget.onRewardEarned?.call(reward);
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 You earned ${reward.amount} ${reward.type}!'),
              backgroundColor: Colors.green.shade600,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customButton != null) {
      return GestureDetector(
        onTap: _showRewardedAd,
        child: widget.customButton!,
      );
    }

    return _buildDefaultButton();
  }

  Widget _buildDefaultButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _adMobService.isRewardedAdReady ? _showRewardedAd : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: _adMobService.isRewardedAdReady
                  ? const LinearGradient(
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.grey.shade300,
                        Colors.grey.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _adMobService.isRewardedAdReady
                  ? [
                      BoxShadow(
                        color: const Color(0xFF92A3FD).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  const Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 24,
                  ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    _isLoading
                        ? 'Loading Ad...'
                        : _adMobService.isRewardedAdReady
                            ? 'Watch Video & Earn Rewards'
                            : 'Ad Not Ready',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the ad here as it's managed by the singleton service
    super.dispose();
  }
}

/// Simple button to trigger rewarded video ad
class WatchAdButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isReady;
  final String text;

  const WatchAdButton({
    super.key,
    this.onPressed,
    this.isReady = true,
    this.text = 'Watch Ad',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isReady ? onPressed : null,
      icon: const Icon(Icons.play_circle_outline, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF92A3FD),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }
}
