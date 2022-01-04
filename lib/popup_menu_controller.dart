import 'package:flutter/material.dart';

class PopupMenuChatController extends ChangeNotifier {
  bool menuIsShowing = false;
  Offset onLongPressOffset = Offset.zero;

  void showMenu({Offset? offsetTouch}) {
    offsetTouch ??= Offset.zero;
    onLongPressOffset = offsetTouch;
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}