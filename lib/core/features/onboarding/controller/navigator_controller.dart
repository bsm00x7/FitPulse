
// navigator_controller.dart

import 'package:flutter/material.dart';

import '../../../../services_ads_storage_local/preference_manager.dart';
import '../../../constant/storage_key.dart';
import '../../login/login.dart';



class NavigatorController extends ChangeNotifier {
  int currentPage = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  void nextPage() {
    currentPage++;
    notifyListeners();
  }
  void jumpPage() {
    pageController.jumpToPage(currentPage);
    notifyListeners();
  }
  void movePageWithIndex(int index) {
    currentPage = index;
    notifyListeners();
  }
  void navigatorLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>  Login(),
      ),
    );
    PreferenceManager().setBool(StorageKey.firstTime, true);
    notifyListeners();
  }

}