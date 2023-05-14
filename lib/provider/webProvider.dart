import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebProvider extends ChangeNotifier
{
  TextEditingController txtsearch = TextEditingController();
  InAppWebViewController? appWebViewController;
  PullToRefreshController? pullToRefreshController;
  double progress=0;

  void changeProgress(double value)
  {
    progress=value;
    notifyListeners();
  }
}