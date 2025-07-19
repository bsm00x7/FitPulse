
// navigator_controller.dart
import 'package:fitness/core/constant/StoregKey.dart';
import 'package:fitness/service/preferanceManger.dart';
import 'package:flutter/material.dart';

import '../../Signup/signup.dart';


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
  void navigatorSignupPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>  Signup(),
      ),

    );
    PreferenceManager().setBoll(StoregKey.FirstTime, true);
    notifyListeners();
  }

}