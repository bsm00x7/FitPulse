
// navigator_controller.dart
import 'package:fitness/core/constant/StoregKey.dart';
import 'package:fitness/core/featuers/login/login.dart';
import 'package:fitness/service/preferanceManger.dart';
import 'package:flutter/material.dart';



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
    PreferenceManager().setBoll(StoregKey.firstTime, true);
    notifyListeners();
  }

}