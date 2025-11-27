import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Coin Service - Manages user coins throughout the app
/// Users earn coins by watching ads and spend them on exercises
class CoinService extends ChangeNotifier {
  static final CoinService _instance = CoinService._internal();
  factory CoinService() => _instance;
  CoinService._internal();

  static const String _coinKey = 'user_coins';
  static const int _initialCoins = 70;
  static const int _exerciseCost = 10;
  static const int _adReward = 10;

  int _coins = _initialCoins;
  int get coins => _coins;

  /// Initialize the coin service - call this at app startup
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _coins = prefs.getInt(_coinKey) ?? _initialCoins;
    
    // If this is first launch, set initial coins
    if (!prefs.containsKey(_coinKey)) {
      await _saveCoins(_initialCoins);
    }
    
    notifyListeners();
    
    if (kDebugMode) {
      print('💰 CoinService initialized with $_coins coins');
    }
  }

  /// Save coins to persistent storage
  Future<void> _saveCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinKey, amount);
  }

  /// Add coins to user balance
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _saveCoins(_coins);
    notifyListeners();
    
    if (kDebugMode) {
      print('💰 Added $amount coins. New balance: $_coins');
    }
  }

  /// Spend coins (deduct from balance)
  /// Returns true if successful, false if insufficient coins
  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await _saveCoins(_coins);
      notifyListeners();
      
      if (kDebugMode) {
        print('💰 Spent $amount coins. New balance: $_coins');
      }
      return true;
    }
    
    if (kDebugMode) {
      print('⚠️ Insufficient coins. Need $amount, have $_coins');
    }
    return false;
  }

  /// Check if user has enough coins for an action
  bool hasEnoughCoins(int amount) {
    return _coins >= amount;
  }

  /// Get the cost of starting an exercise
  int get exerciseCost => _exerciseCost;

  /// Get the reward amount for watching an ad
  int get adReward => _adReward;

  /// Check if user can afford an exercise
  bool canAffordExercise() {
    return hasEnoughCoins(_exerciseCost);
  }

  /// Spend coins for an exercise
  Future<bool> purchaseExercise() async {
    return await spendCoins(_exerciseCost);
  }

  /// Reward user for watching an ad
  Future<void> rewardForAd() async {
    await addCoins(_adReward);
  }

  /// Reset coins (for testing purposes)
  Future<void> resetCoins() async {
    _coins = _initialCoins;
    await _saveCoins(_coins);
    notifyListeners();
    
    if (kDebugMode) {
      print('💰 Coins reset to $_initialCoins');
    }
  }
}
