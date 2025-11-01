import 'package:flutter/material.dart';

class MessagingController extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: false);

  void notify() {
    notifyListeners();
  }
  void scrollToBottom() {
    scrollController.jumpTo(
      0
    );
    notify();
  }



}