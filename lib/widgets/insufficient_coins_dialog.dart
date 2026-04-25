import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services_ads_storage_local/ad_mob_service.dart';
import '../services_ads_storage_local/coin_service.dart';

/// Dialog shown when user doesn't have enough coins to start an exercise
/// Offers option to watch a rewarded ad to earn coins
class InsufficientCoinsDialog extends StatefulWidget {
  final int currentCoins;
  final int requiredCoins;

  const InsufficientCoinsDialog({
    super.key,
    required this.currentCoins,
    required this.requiredCoins,
  });

  @override
  State<InsufficientCoinsDialog> createState() =>
      _InsufficientCoinsDialogState();
}

class _InsufficientCoinsDialogState extends State<InsufficientCoinsDialog> {
  final CoinService _coinService = CoinService();
  final AdMobService _adMobService = AdMobService();
  bool _isLoadingAd = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    setState(() {
      _isLoadingAd = true;
    });

    _adMobService.loadRewardedAd(
      onAdLoaded: () {
        if (mounted) {
          setState(() {
            _isLoadingAd = false;
          });
        }
      },
      onAdFailedToLoad: (error) {
        if (mounted) {
          setState(() {
            _isLoadingAd = false;
          });
        }
      },
    );
  }

  Future<void> _watchAdAndEarnCoins() async {
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
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
        // Grant coins to user
        await _coinService.rewardForAd();

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 You earned ${_coinService.adReward} coins!'),
              backgroundColor: Colors.green.shade600,
              duration: const Duration(seconds: 2),
            ),
          );

          // Close dialog after a brief delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.of(
                context,
              ).pop(true); // Return true to indicate coins were earned
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coinsNeeded = widget.requiredCoins - widget.currentCoins;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFF7F8F8)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monetization_on,
                size: 48,
                color: Color(0xFFF59E0B),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Insufficient Coins',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1617),
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              'You need $coinsNeeded more coins to start this exercise.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // Coin Balance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Balance: ${widget.currentCoins} coins',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1617),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Watch Ad Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoadingAd || !_adMobService.isRewardedAdReady
                    ? null
                    : _watchAdAndEarnCoins,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF92A3FD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoadingAd
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_circle_filled, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Watch Ad & Earn ${_coinService.adReward} Coins',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF7B6F72), fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the insufficient coins dialog
Future<bool?> showInsufficientCoinsDialog(
  BuildContext context, {
  required int currentCoins,
  required int requiredCoins,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => InsufficientCoinsDialog(
      currentCoins: currentCoins,
      requiredCoins: requiredCoins,
    ),
  );
}
